//
//  Graf+DrawingContext.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CCairo
import CommonSwift

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
    
    private let pixels: UnsafeMutablePointer<UInt8>
    
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      surface = Cairo.BitmapSurface(w, h, data, stride)
      context = surface.context
      pixels = data
    }
    
    public func clear(_ bgColor: Color = Color.white)
    {
      fill = Fill.color(bgColor)
      viewRect.draw(self, stroke: false)
    }
    
    public func setPixel(_ x: UInt32, _ y: UInt32, _ color: Color)
    {
      guard x < UInt32(width) && y < UInt32(height) else
      {
        Log.warn("x > width || y > height")
        return
      }
      let addr = Int((y * UInt32(width) + x) * 4) // 4 channels per pix
      let a = UnsafeMutableBufferPointer(start: pixels, count: Int(width) * Int(height) * 4)
      let c = color.argbBytes
      a[addr] = c[0]
      a[addr + 1] = c[1]
      a[addr + 2] = c[2]
      a[addr + 3] = c[3]
    }
  } // DrawingContext
}


protocol Drawable
{
  func draw(_ dc: Graf.DrawingContext, stroke: Bool, fill: Bool)
}

