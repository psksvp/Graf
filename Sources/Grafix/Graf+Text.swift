//
//  Graf+Text.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CCairo
import CommonSwift

extension Graf
{
  class Text : Drawable
  {
    var text: String = ""
    var coord: (Double, Double) = (0.0, 0.0)
    
    init(_ x: Double, _ y: Double, _ s: String)
    {
      text = s
      coord = (x, y)
    }
    
    func draw(_ dc: Graf.DrawingContext, stroke: Bool, fill: Bool)
    {
      dc.fillColor.setAsSourceInContext(dc.context)
      
//      if(centerAtCoord)
//      {
//        let (w, h) = extend(dc)
//        let (x, y) = (coord.0 + w / 2, coord.1 + h / 2)
//        cairo_move_to(dc.context.cr, x, y)
//      }
//      else
//      {
//        cairo_move_to(dc.context.cr, coord.0, coord.1)
//      }
      cairo_move_to(dc.context.cr, coord.0, coord.1)
      cairo_show_text(dc.context.cr, text)
    }
    
    func extend(_ dc: DrawingContext) -> (Double, Double)
    {
      var ex = cairo_text_extents_t()
      
      cairo_text_extents(dc.context.cr, text, &ex)
      return (ex.width, ex.height)
    }
  }
}
