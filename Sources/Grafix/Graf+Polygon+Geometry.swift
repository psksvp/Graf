//
//  Graf+Polygon+Geometry.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import simd


extension Graf.Polygon
{
  @discardableResult func moveTo(_ x: Double, _ y: Double) -> Graf.Polygon
  {
    let c = self.center
    return translate(x - c.x, y - c.y)
  }
  
  @discardableResult func translate(_ dx: Double, _ dy: Double) -> Graf.Polygon
  {
    let m = double3x3(rows: [SIMD3<Double>(1,   0, 0),
                             SIMD3<Double>(0,   1, 0),
                             SIMD3<Double>(dx, dy, 1)])
    return transform(m)
  }
  
  @discardableResult func scale(_ sx: Double, _ sy: Double) -> Graf.Polygon
  {
    let m = double3x3(rows: [SIMD3<Double>(sx,  0, 0),
                             SIMD3<Double>(0,  sy, 0),
                             SIMD3<Double>(0,   0, 1)])
    return transform(m)
  }
  
  @discardableResult func shear(_ sx: Double, _ sy: Double) -> Graf.Polygon
  {
    let m = double3x3(rows: [SIMD3<Double>(1,  sx, 0),
                             SIMD3<Double>(sy,  1, 0),
                             SIMD3<Double>(0,   0, 1)])
    return transform(m)
  }
  
  @discardableResult func rotate(_ angle: Double) -> Graf.Polygon
  {
    let m = double3x3(rows: [SIMD3<Double>(cos(angle), sin(angle), 0),
                             SIMD3<Double>(-sin(angle), cos(angle), 0),
                             SIMD3<Double>(0, 0, 1)])
    
    let c = self.center
    return moveTo(0, 0).transform(m).moveTo(c.x, c.y)
  }
  
  
  @discardableResult func transform(_ m: double3x3) -> Graf.Polygon
  {
    vertices = vertices.map { $0 * m }
    return self
  }
  
  func overlapWith(_ p: Graf.Polygon) -> Bool
  {
    guard self.vertices.count > 0 &&
             p.vertices.count > 0 else {return false}
     
    for v in self.vertices
    {
      if p.hitTest((v.x, v.y))
      {
        return true
      }
    }
    
    for v in p.vertices
    {
      if self.hitTest((v.x, v.y))
      {
        return true
      }
    }
    
    return false
  }
  
}
