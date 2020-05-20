//
//  Graf+BitmapCanvas.swift
//  
//
//  Created by psksvp on 20/5/20.
//

import Foundation
import CCairo

extension Graf
{
  public class DrawableBitmap : Drawable
  {
    let surface: Cairo.BitmapSurface

    private var x: Double = 0
    private var y: Double = 0
    
    public var width: UInt32 {UInt32(surface.width)}
    public var height: UInt32 {UInt32(surface.height)}
    
    public var boundary: Polygon
    {
      return Graf.rect(x, y, surface.width, surface.height)
    }
    
    public var center: Vector3e
    {
      return Vector3e(x - surface.width / 2, y - surface.width / 2, 1)
    }
    
    public init(_ w: UInt32, _ h: UInt32)
    {
      self.surface = Cairo.BitmapSurface(w, h)
    }
    
    @discardableResult
    public func moveTo(_ x: Double, _ y: Double) -> DrawableBitmap
    {
      self.x = x - surface.width / 2
      self.y = y - surface.height / 2
      return self
    }
    
    @discardableResult
    public func rotate(_ angle: Double) -> DrawableBitmap
    {
      surface.context.translate(surface.width / 2 , surface.height / 2)
      surface.context.rotate(angle)
      surface.context.translate(-surface.width / 2, -surface.height / 2)
      return self
    }
    
    @discardableResult
    public func scale(_ sx: Double, _ sy: Double) -> DrawableBitmap
    {
      surface.context.scale(sx, sy)
      return self
    }
    
    public func clear()
    {
      cairo_set_operator(surface.context.cr, CAIRO_OPERATOR_OUT)
      cairo_rectangle(surface.context.cr, 0, 0, Double(self.width), Double(self.height))
      cairo_set_source_rgba(surface.context.cr, 0, 0, 0, 0)
      cairo_fill(surface.context.cr)
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      surface.paintToContext(dc.context, x, y)
    }
  }
}
