//
//  Graf+Fill.swift
//  
//
//  Created by psksvp on 9/5/20.
//

import Foundation
import CCairo

extension Graf
{
  public class Fill
  {
    let cPattern: Cairo.FillPattern
    
    private init(_ c: Graf.Color)
    {
      cPattern = Cairo.FillPattern(c)
    }
    
    private init(_ f: String)
    {
      cPattern = Cairo.FillPattern(Cairo.PNGSurface(f))
    }
    
    private init(_ x0: Double,
                 _ y0: Double,
                 _ x1: Double,
                 _ y1: Double)
    {
      cPattern = Cairo.FillPattern(x0, y1, x1, y1)
    }
    
    public class func color(_ c: Graf.Color) -> Fill
    {
      return Fill(c)
    }
    
    public class func color(_ r: Double,
                            _ g: Double,
                            _ b: Double,
                            _ a: Double = 1.0) -> Fill
    {
      return color(Graf.Color(r, g, b, a))
    }
    
    public static var colorBlack = Fill.color(0, 0, 0)
    public static var colorWhite = Fill.color(1, 1, 1)
    public static var colorRed = Fill.color(1, 0, 0)
    public static var colorGreen = Fill.color(0, 1, 0)
    public static var colorBlue = Fill.color(0, 0, 1)
    
    public class func image(_ f: String) -> Fill
    {
      return Fill(f)
    }
    
    public class func linearGradient(_ x0: Double,
                                     _ y0: Double,
                                     _ x1: Double,
                                     _ y1: Double,
                                     stopColors: [Color]) -> Fill
    {
      let f = Fill(x0, y0, x1, y1)
      var offset: Double = 0
      let interval = 1.0 / Double(stopColors.count)
      for c in stopColors
      {
        cairo_pattern_add_color_stop_rgba(f.cPattern.pattern,
                                          offset,
                                          c.redChannel,
                                          c.greenChannel,
                                          c.blueChannel,
                                          c.alphaChannel)
        offset = offset + interval
      }
      return f
    }
  }
}
