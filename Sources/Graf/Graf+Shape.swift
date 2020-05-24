//
//  Graf+Shape.swift
//  
//
//  Created by psksvp on 24/5/20.
//

import Foundation
import CCairo

extension Graf
{
  public class Shape : DrawableBitmap
  {
    private let polygon: Polygon
    private let bound: Polygon
    private let texture: Fill?

    override public var boundary: Polygon {self.bound}

    public init(_ p: Polygon, texture tex: Fill? = nil)
    {
      self.polygon = Polygon(p.vertices) // a copy
      self.bound = p
      self.texture = tex

      let r = polygon.boundingRect
      let w = fabs(r.vertices[2].x - r.vertices[0].x)
      let h = fabs(r.vertices[2].y - r.vertices[0].y)
                                  /// V V triangle case
      let s =  sqrt(w * w + h * h) + (3 == polygon.vertices.count ? h / 2 : 0)
      polygon.moveTo(s / 2, s / 2)
      
      super.init(UInt32(s), UInt32(s), worldX: r.vertices[0].x,
                                       worldY: r.vertices[0].y)
    }
    
    @discardableResult
    public override func moveTo(_ x: Double, _ y: Double) -> DrawableBitmap
    {
      boundary.moveTo(x, y)
      return super.moveTo(x, y)
    }
    
    @discardableResult
    override public func translate(_ dx: Double, _ dy: Double) -> DrawableBitmap
    {
      boundary.translate(dx, dy)
      return super.translate(dx, dy)
    }
    
    @discardableResult
    public override func rotate(_ angle: Double) -> DrawableBitmap
    {
      boundary.rotate(angle)
      return super.rotate(angle)
    }
    
    override public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      clear()
      guard polygon.vertices.count > 0 else {return}
      cairo_set_operator(surface.context.cr, CAIRO_OPERATOR_OVER)
      let targetDC = super.surface.context
      let sp = polygon.vertices.first!
      cairo_move_to(targetDC.cr, sp.x, sp.y)
      for p in polygon.vertices.dropFirst(1)
      {
        cairo_line_to(targetDC.cr, p.x, p.y)
      }
      cairo_close_path(targetDC.cr)
      if stroke
      {
        targetDC.stroke(dc.strokeColor, preserved: true)
      }
      if let tex = self.texture,
         fill
      {
        targetDC.fill(tex.cPattern)
      }
      cairo_surface_flush(super.surface.csurface)
      super.draw(dc)
    }
  }
}
