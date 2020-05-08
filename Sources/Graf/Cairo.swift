//
//  Cairo.swift
//  
//
//  Created by psksvp on 25/4/20.
//

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
      set { component[0] = newValue}
    }
    
    public var greenChannel: Double
    {
      get { component[1] }
      set { component[1] = newValue}
    }
    
    public var blueChannel: Double
    {
      get { component[2] }
      set { component[2] = newValue}
    }
    
    public var alphaChannel: Double
    {
      get { component[3] }
      set { component[3] = newValue}
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
    
    public var argbBytes: [UInt8]
    {
      [UInt8(alphaChannel * 255),
       UInt8(redChannel * 255),
       UInt8(greenChannel * 255),
       UInt8(blueChannel * 255)]
    }
    
    func setAsSourceInContext(_ c: Context)
    {
      cairo_set_source_rgba(c.cr, redChannel, greenChannel, blueChannel, alphaChannel)
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
  }
  
  class BitmapSurface : Surface
  {
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      let s = cairo_image_surface_create_for_data(data, CAIRO_FORMAT_ARGB32, Int32(w), Int32(h), stride)
      super.init(s!)
    }
  }
  
  class RectOfSurface : Surface
  {
    init(_ surface: Surface, x: Double, _ y: Double, _ width: Double, _ height: Double)
    {
      let s = cairo_surface_create_for_rectangle(surface.csurface, x, y, width, height)
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
    
    func fill(_ c: Color, preserved: Bool = false)
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
    
    func push()
    {
      cairo_save(cr)
    }
    
    func pop()
    {
      cairo_restore(cr)
    }
  } // context
  
  
}
