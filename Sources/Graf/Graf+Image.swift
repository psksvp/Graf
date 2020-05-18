//
//  Graf+Image.swift
//  
//
//  Created by psksvp on 9/5/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2020. by Pongsak Suvanpong (psksvp@gmail.com)
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification,
*  are permitted provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice,
*  this list of conditions and the following disclaimer.
*
*  2. Redistributions in binary form must reproduce the above copyright notice,
*  this list of conditions and the following disclaimer in the documentation
*  and/or other materials provided with the distribution.
*
*  3. Neither the name of the copyright holder nor the names of its contributors may
*  be used to endorse or promote products derived from this software without
*  specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
*  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* This information is provided for personal educational purposes only.
*
* The author does not guarantee the accuracy of this information.
*
* By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
*/

import Foundation
import CCairo

extension Graf
{
  public class Image : Drawable
  {
    let surface: Cairo.BitmapSurface
    
    private let pngs: Cairo.PNGSurface
    private var x: Double = 0
    private var y: Double = 0
    
    private let canSize: Double
    
    public lazy var width: UInt32 = UInt32(pngs.width)
    public lazy var height: UInt32 = UInt32(pngs.height)
    
    public var boundary: Polygon
    {
      return Graf.rect(x, y, canSize, canSize)
    }
    
    public var center: Vector3e
    {
      return Vector3e(x - canSize / 2, y - canSize / 2, 1)
    }
    
    public init(_ f: String)
    {
      self.pngs = Cairo.PNGSurface(f)
      canSize = sqrt(pngs.width * pngs.width + pngs.height * pngs.height)
      self.surface = Cairo.BitmapSurface(UInt32(canSize), UInt32(canSize))
      composite()
    }
    
    @discardableResult
    public func moveTo(_ x: Double, _ y: Double) -> Image
    {
      self.x = x - canSize / 2
      self.y = y - canSize / 2
      return self
    }
    
    @discardableResult
    public func rotate(_ angle: Double) -> Image
    {
      surface.context.translate(canSize / 2 , canSize / 2)
      surface.context.rotate(angle)
      surface.context.translate(-canSize / 2, -canSize / 2)
      
      return self
    }
    
    @discardableResult
    public func scale(_ sx: Double, _ sy: Double) -> Image
    {
      surface.context.scale(sx, sy)
      return self
    }
    
    public func composite()
    {
      cairo_set_operator(self.surface.context.cr, CAIRO_OPERATOR_OUT)
      cairo_rectangle(surface.context.cr, x, y, Double(width), Double(height))
      cairo_set_source_rgba(surface.context.cr, 0, 0, 0, 0)
      cairo_fill(surface.context.cr)
      let xd = (canSize - Double(width)) / 2
      let yd = (canSize - Double(height)) / 2
      pngs.paintToContext(self.surface.context, xd, yd)
      cairo_surface_flush(surface.csurface)
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      composite()
      surface.paintToContext(dc.context, x, y)
    }
  }
}
