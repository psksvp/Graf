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
  class Text
  {
    var text: String = ""
    var coord: (Double, Double) = (0.0, 0.0)
    
    init(_ x: Double, _ y: Double, _ s: String)
    {
      text = s
      coord = (x, y)
    }
    
    func draw(_ dc: DrawingContext)
    {
      dc.fillColor.setAsSourceInContext(dc.context)
      cairo_move_to(dc.context.cr, coord.0, coord.1)
      cairo_show_text(dc.context.cr, text)
    }
  }
}
