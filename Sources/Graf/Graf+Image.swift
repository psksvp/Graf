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
  public class Image : DrawableBitmap
  {
    private let pngs: Cairo.PNGSurface
    private let imageBoundary: Polygon
    
    private let canWidth: Double
    private let canHeight: Double
    
    override public var width: UInt32 {UInt32(pngs.width)}
    override public var height: UInt32 {UInt32(pngs.height)}
    
    override public var boundary: Polygon {imageBoundary}
    
    
    public init(_ f: String)
    {
      self.pngs = Cairo.PNGSurface(f)
      canWidth = sqrt(pngs.width * pngs.width + pngs.height * pngs.height)
      canHeight = canWidth
      imageBoundary = Graf.rect(0, 0, pngs.width, pngs.height)
      super.init(UInt32(canWidth), UInt32(canHeight))
    }
    
    @discardableResult
    override public func moveTo(_ x: Double, _ y: Double) -> DrawableBitmap
    {
      imageBoundary.moveTo(x, y)
      return super.moveTo(x, y)
    }
    
    @discardableResult
    override public func translate(_ dx: Double, _ dy: Double) -> DrawableBitmap
    {
      imageBoundary.translate(dx, dy)
      return super.translate(dx, dy)
    }
    
    @discardableResult
    override public func rotate(_ angle: Double) -> DrawableBitmap
    {
      imageBoundary.rotate(angle)
      return super.rotate(angle)
    }
    
    
    override public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      clear()
      let xd = (canWidth - Double(width)) / 2
      let yd = (canHeight - Double(height)) / 2
      pngs.paintToContext(super.surface.context, xd, yd)
      cairo_surface_flush(super.surface.csurface)
      super.draw(dc)
    }
  }
}
