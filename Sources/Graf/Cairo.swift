//
//  Cairo.swift
//  
//
//  Created by psksvp on 25/4/20.
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

public struct Cairo //namespace
{
  private init() {} // stop it from being used as an instance
  
  public class Color
  {
    private var component = [0.0, 0.0, 0.0, 0.0]
    
    public var redChannel: Double
    {
      get { component[0] }
      set { component[0] = newValue.clamped(to: 0 ... 1)}
    }
    
    public var greenChannel: Double
    {
      get { component[1] }
      set { component[1] = newValue.clamped(to: 0 ... 1)}
    }
    
    public var blueChannel: Double
    {
      get { component[2] }
      set { component[2] = newValue.clamped(to: 0 ... 1)}
    }
    
    public var alphaChannel: Double
    {
      get { component[3] }
      set { component[3] = newValue.clamped(to: 0 ... 1)}
    }
    
    public static var transparent: Color
    {
      Color(0, 0, 0, 0)
    }
    
    public static var red: Color
    {
      Color(1, 0, 0, 1)
    }
    
    public static var green: Color
    {
      Color(0, 1, 0, 1)
    }
    
    public static var blue: Color
    {
      Color(0, 0, 1, 1)
    }
    
    public static var black: Color
    {
      Color(0, 0, 0, 1)
    }
    
    public static var white: Color
    {
      Color(1, 1, 1, 1)
    }
    
    public static var random:Color
    {
      Color(Double.random(in: 0 ... 1),
            Double.random(in: 0 ... 1),
            Double.random(in: 0 ... 1),
            Double.random(in: 0 ... 1))
    }
    
    public init(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1.0)
    {
      redChannel = r
      greenChannel = g
      blueChannel = b
      alphaChannel = a
    }
    
    public var bytes: [UInt8]
    {
      [UInt8(redChannel * 255),
       UInt8(greenChannel * 255),
       UInt8(blueChannel * 255),
       UInt8(alphaChannel * 255)]
    }
    
    func setAsSourceInContext(_ c: Context)
    {
      cairo_set_source_rgba(c.cr, redChannel, greenChannel, blueChannel, alphaChannel)
    }
  }
  
  class FillPattern
  {
    let pattern: OpaquePointer
    
    init(_ s: Surface)
    {
      self.pattern = cairo_pattern_create_for_surface(s.csurface)
    }
    
    init(_ c: Color)
    {
      self.pattern = cairo_pattern_create_rgba(c.redChannel,
                                               c.greenChannel,
                                               c.blueChannel,
                                               c.alphaChannel)
    }
    
    init(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double)
    {
      self.pattern = cairo_pattern_create_linear(x0, y0, x1, y1)
    }
    
    init(_ cx0: Double, _ cy0: Double, _ radius0: Double,
         _ cx1: Double, _ cy1: Double, _ radius1: Double)
    {
      self.pattern = cairo_pattern_create_radial(cx0,
                                                 cy0,
                                                 radius0,
                                                 cx1,
                                                 cy1,
                                                 radius1)
    }
    
    deinit
    {
      cairo_pattern_destroy(pattern)
    }
    
    func setAsSourceInContext(_ c: Context)
    {
      cairo_set_source(c.cr, pattern);
      cairo_pattern_set_extend(cairo_get_source(c.cr), CAIRO_EXTEND_PAD);
    }
  }
  
  class Surface
  {
    let csurface: OpaquePointer
    let context: Context
    
    let width: Double
    let height: Double
    
    init(_ s: OpaquePointer)
    {
      self.csurface = s
      self.context = Context(s)
      width = self.context.width
      height = self.context.height
    }
    
    deinit
    {
      cairo_surface_destroy(csurface)
    }
    
    func paintToContext(_ c: Context, _ x: Double, _ y: Double)
    {
      cairo_set_source_surface(c.cr, self.csurface, x, y)
      cairo_paint(c.cr)
    }
    
    static func fromRectOfSurface(_ s: Surface, x: Double, _ y: Double, _ width: Double, _ height: Double) -> Surface
    {
      let s = cairo_surface_create_for_rectangle(s.csurface, x, y, width, height)
      return Surface(s!)
    }
  }
  
  class BitmapSurface : Surface
  {
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      let s = cairo_image_surface_create_for_data(data, CAIRO_FORMAT_ARGB32, Int32(w), Int32(h), stride)
      super.init(s!)
    }
    
    init(_ w: UInt32, _ h: UInt32)
    {
      let s = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, Int32(w), Int32(h))
      super.init(s!)
    }
    
  }
  
  class PNGSurface : Surface
  {
    init(_ filename: String)
    {
      let s = cairo_image_surface_create_from_png(filename)
      super.init(s!)
    }
  }
  
  class Context
  {
    let cr: OpaquePointer
    let width: Double
    let height: Double
    
    init(_ surface: OpaquePointer)
    {
      cr = cairo_create(surface)
      var x1: Double = 0
      var y1: Double = 0
      var x2: Double = 0
      var y2: Double = 0
      cairo_clip_extents(cr, &x1, &y1, &x2, &y2)
      width = x2 - x1
      height = y2 - y1
    }
    
    deinit
    {
      cairo_destroy(cr)
    }
    
    func fill(_ c: FillPattern, preserved: Bool = false)
    {
      c.setAsSourceInContext(self)
      if preserved
      {
        cairo_fill_preserve(cr)
      }
      else
      {
        cairo_fill(cr)
      }
    }
    
    func stroke(_ c: Color, preserved: Bool = false)
    {
      c.setAsSourceInContext(self)
      if preserved
      {
        cairo_stroke_preserve(cr)
      }
      else
      {
        cairo_stroke(cr)
      }
    }
    
    func saveStates()
    {
      cairo_save(cr)
    }
    
    func restoreStates()
    {
      cairo_restore(cr)
    }
    
    func translate(_ dx: Double, _ dy: Double)
    {
      cairo_translate(cr, dx, dy)
    }
    
    func rotate(_ angle: Double)
    {
      cairo_rotate(cr, angle)
    }
    
    func scale(_ sx: Double, _ sy: Double)
    {
      cairo_scale(self.cr, sx, sy)
    }
    
  } // context
  
  
}
