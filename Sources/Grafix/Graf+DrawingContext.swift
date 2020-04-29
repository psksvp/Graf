//
//  File.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CCairo
import CommonSwift

extension Graf
{
  class DrawingContext
  {
    let surface: Cairo.BitmapSurface
    let context: Cairo.Context
    
    var fillColor: Color = Color.transparent
    var strokeColor: Color = Color.black
    var strokeWeight: Double = 1.0
    {
      didSet
      {
        cairo_set_line_width(context.cr, fabs(strokeWeight))
      }
    }
    
    var fontSize: Double = 14.0
    {
      didSet
      {
        cairo_set_font_size(context.cr, fabs(fontSize))
      }
    }
    
    var fontFace: String = "Arial"
    {
      didSet
      {
        cairo_select_font_face(context.cr,
                               fontFace,
                               CAIRO_FONT_SLANT_NORMAL,
                               CAIRO_FONT_WEIGHT_NORMAL)
      }
    }
    
    lazy var viewRect: Rectangle = Rectangle(0, 0, width, height)
    lazy var width: Double = context.width
    lazy var height: Double = context.height
    
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      surface = Cairo.BitmapSurface(w, h, data, stride)
      context = surface.context
    }
    
    func clear(_ bgColor: Color = Color.white)
    {
      fillColor = bgColor
      viewRect.draw(self, stroke: false)
    }
  } // DrawingContext
}
