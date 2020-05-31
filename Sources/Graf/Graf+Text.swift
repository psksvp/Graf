//
//  Graf+Text.swift
//  
//
//  Created by psksvp on 29/4/20.
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
import CommonSwift

extension Graf
{
  public class Text : Drawable
  {
    private let text: String
    private let xBearing: Double
    private let yBearing: Double
    private let textHeight: UInt32
    private let textBoundary: Polygon
    private let font: Font
    
    public var color: Graf.Color = Graf.Color.black
    override public var height: UInt32 {textHeight}
    override public var boundary: Polygon {textBoundary}
    
    public init(_ s: String, font: Font = Font(name: "Arial", size: UInt32(20)),
                          color c: Graf.Color = Graf.Color.black)
    {
      text = s
      let (w, h, xb, yb) = Cairo.dimensionOfText(s,
                                                 inContext: Cairo.BitmapSurface(10, 10).context,
                                                 usingFont: font)
      (xBearing, yBearing) = (xb, yb)
      textHeight = UInt32(h)
      textBoundary = Graf.rect(0, 0, w, h)
      self.font = font
      self.color = c
      //bitmap surface must be larger than actual text for rotation
      super.init(UInt32(w), UInt32(w))
    }
    
    @discardableResult
    override public func moveTo(_ x: Double, _ y: Double) -> Drawable
    {
      textBoundary.moveTo(x, y)
      return super.moveTo(x, y)
    }
    
    @discardableResult
    override public func translate(_ dx: Double, _ dy: Double) -> Drawable
    {
      textBoundary.translate(dx, dy)
      return super.translate(dx, dy)
    }
    
    @discardableResult
    override public func rotate(_ angle: Double) -> Drawable
    {
      textBoundary.rotate(angle)
      return super.rotate(angle)
    }
  
  
    override public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      super.clear()
      
      //dc.fill.cPattern.setAsSourceInContext(super.surface.context)
      self.color.setAsSourceInContext(super.surface.context)
      self.font.setToCairoContext(super.surface.context)
      cairo_move_to(super.surface.context.cr, xBearing,
                                              yBearing / 2 + Double(super.height) / 2)
      cairo_show_text(super.surface.context.cr, text)
      cairo_surface_flush(super.surface.csurface)
     
      super.draw(dc)
    }
  
  } //Text
} //Graf
