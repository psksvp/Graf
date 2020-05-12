//
//  Graf+Image.swift
//  
//
//  Created by psksvp on 9/5/20.
//

import Foundation
import CCairo

extension Graf
{
  public class Image : Drawable
  {
    private let surface: Cairo.PNGSurface
    private var x: Double = 0
    private var y: Double = 0
    
    public lazy var width: Int32 = cairo_image_surface_get_width(surface.csurface)
    public lazy var height: Int32 = cairo_image_surface_get_height(surface.csurface)
    
    public init(_ f: String)
    {
      surface = Cairo.PNGSurface(f)
    }
    
    public func moveTo(_ x: Double, _ y: Double) -> Image
    {
      self.x = x
      self.y = y
      return self
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      cairo_set_source_surface(dc.context.cr, surface.csurface, x + Double(width) / 2, y + Double(height) / 2)
      cairo_paint(dc.context.cr)
    }
  }
}
