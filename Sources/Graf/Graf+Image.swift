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
    private let pngs: Cairo.PNGSurface
    private let surface: Cairo.BitmapSurface

    private var x: Double = 0
    private var y: Double = 0
    
    public lazy var width: Int32 = cairo_image_surface_get_width(surface.csurface)
    public lazy var height: Int32 = cairo_image_surface_get_height(surface.csurface)
    
    public init(_ f: String)
    {
      self.pngs = Cairo.PNGSurface(f)
      self.surface = Cairo.BitmapSurface(UInt32(pngs.width), UInt32(pngs.height))
      pngs.paintToContext(self.surface.context, 0, 0)
    }
    
    @discardableResult
    public func moveTo(_ x: Double, _ y: Double) -> Image
    {
      self.x = x
      self.y = y
      return self
    }
    
    @discardableResult
    public func rotate(_ angle: Double) -> Image
    {
      surface.context.translate(Double(width) / 2.0, Double(height) / 2.0)
      surface.context.rotate(angle)
      surface.context.translate(-Double(width) / 2.0, -Double(height) / 2.0)
      
      return self
    }
    
    @discardableResult
    public func scale(_ sx: Double, _ sy: Double) -> Image
    {
      surface.context.scale(sx, sy)
      return self
    }
    
    private func clear()
    {
      cairo_rectangle(surface.context.cr, x, y, Double(width), Double(height))
      cairo_set_source_rgba(surface.context.cr, 0, 0, 0, 1)
      cairo_fill(surface.context.cr)
      cairo_surface_flush(surface.csurface)
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      cairo_set_operator(self.surface.context.cr, CAIRO_OPERATOR_OUT)
      clear()
      pngs.paintToContext(self.surface.context, 0, 0)
      surface.paintToContext(dc.context, x, y)
    }
  }
}
