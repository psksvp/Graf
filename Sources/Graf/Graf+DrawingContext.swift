//
//  Graf+DrawingContext.swift
//  
//
//  Created by psksvp on 29/4/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2018. by Pongsak Suvanpong (psksvp@gmail.com)
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
import SDL2

extension Graf
{
  public class DrawingContext
  {
    let surface: Cairo.BitmapSurface
    let context: Cairo.Context
    
    public var fill: Fill = Fill.color(Color.transparent)
    public var strokeColor: Color = Color.black
    public var strokeWeight: Double = 1.0
    {
      didSet
      {
        cairo_set_line_width(context.cr, fabs(strokeWeight))
      }
    }
    
    public var fontSize: Double = 14.0
    {
      didSet
      {
        cairo_set_font_size(context.cr, fabs(fontSize))
      }
    }
    
    public var fontFace: String = "Arial"
    {
      didSet
      {
        cairo_select_font_face(context.cr,
                               fontFace,
                               CAIRO_FONT_SLANT_NORMAL,
                               CAIRO_FONT_WEIGHT_NORMAL)
      }
    }
    
    
    public lazy var viewRect = rect(0, 0, Double(width), Double(height))
    public lazy var width: UInt32 = UInt32(context.width)
    public lazy var height: UInt32 = UInt32(context.height)
    
    private let pixels: UnsafeMutableBufferPointer<UInt8>
    
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      surface = Cairo.BitmapSurface(w, h, data, stride)
      context = surface.context
      pixels = UnsafeMutableBufferPointer(start: data, count: Int(w) * Int(h) * 4)
    }
    
    public func clear(_ bgColor: Color = Color.white)
    {
      fill = Fill.color(bgColor)
      viewRect.draw(self, stroke: false)
    }
    
    public func setPixel(_ x: Int32, _ y: Int32, _ color: Color)
    {
      guard x < width && y < height && x >= 0 && y >= 0 else
      {
        Log.warn("x > width || y > height || x < 0 || y < 0")
        return
      }
      let addr = Int((y * Int32(width) + x) * 4) // 4 channels per pix
      
      pixels[addr]     = UInt8(color.blueChannel * 255)  // blue
      pixels[addr + 1] = UInt8(color.greenChannel * 255) // green
      pixels[addr + 2] = UInt8(color.redChannel * 255)   // red
      pixels[addr + 3] = UInt8(color.alphaChannel * 255) // alpha
    }
    
    public func saveFrameAsPNG(_ filename:String)
    {
      cairo_surface_write_to_png(self.surface.csurface, filename)
    }
  } // DrawingContext
}


protocol Drawable
{
  func draw(_ dc: Graf.DrawingContext, stroke: Bool, fill: Bool)
}

