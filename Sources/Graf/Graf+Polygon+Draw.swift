//
//  Graf+Polygon+Draw.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import SDL2
import CommonSwift

extension Graf.Polygon : Drawable
{
  public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
  {
    if self.xPoints.count < vertices.count
    {
      self.xPoints.reserveCapacity(vertices.count)
      self.yPoints.reserveCapacity(vertices.count)
    }
    
    self.xPoints.removeAll(keepingCapacity: true)
    self.yPoints.removeAll(keepingCapacity: true)
    
    for v in vertices
    {
      self.xPoints.append(Int16(v.x))
      self.yPoints.append(Int16(v.y))
    }
    
    if fill
    {
      dc.fillPolygon(self.xPoints, self.yPoints)
    }
    
    if stroke
    {
      dc.stokePolygon(self.xPoints, self.yPoints)
    }
    
  }
}
