//
//  Graf+Polygon+Draw.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CCairo
import CommonSwift

extension Graf.Polygon : Drawable
{
  func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
  {
    func buildPath()
    {
      guard vertices.count > 0 else {return}
      
      let sp = vertices.first!
      cairo_move_to(dc.context.cr, sp.x, sp.y)
      for p in vertices.dropFirst(1)
      {
        cairo_line_to(dc.context.cr, p.x, p.y)
      }
      cairo_close_path(dc.context.cr)
    }
    
    func doStroke()
    {
      buildPath()
      dc.context.stroke(dc.strokeColor)
    }
    
    func doFill()
    {
      if vertices.count <= 2
      {
        doStroke()
      }
      else
      {
        buildPath()
        dc.context.fill(dc.fillColor)
      }
    }
    
    func doStrokeAndFill()
    {
      buildPath()
      dc.context.stroke(dc.strokeColor, preserved: true)
      dc.context.fill(dc.fillColor)
    }
    
    switch (stroke, fill)
    {
      case (true, true)  : doStrokeAndFill()
      case (true, false) : doStroke()
      case (false, true) : doFill()
      case (false, false): Log.warn("draw without stroke and fill")
    }
    
  }
}
