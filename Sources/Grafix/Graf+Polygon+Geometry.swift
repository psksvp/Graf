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
  //https://developer.apple.com/documentation/accelerate/working_with_vectors
  
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
  
  func normal(ofSide s: Int) -> (SIMD3<Double>, SIMD3<Double>)?
  {
    //https://stackoverflow.com/questions/1243614/how-do-i-calculate-the-normal-vector-of-a-line-segment/1243676#1243676
    //if we define dx=x2-x1 and dy=y2-y1, then the normals are (-dy, dx) and (dy, -dx).
    
    guard s >= 0 && s < self.vertices.count else {return nil}
    
    let p1 = self.vertices[s]
    let p2 = self.vertices[(s + 1) % self.vertices.count]
    
    let d = p2 - p1
    return (SIMD3<Double>(-d.y, d.x, 1.0), SIMD3<Double>(d.y, -d.x, 1.0))
  }
  
  func refect(vector v: SIMD3<Double>, onSide s: Int) -> (SIMD3<Double>, SIMD3<Double>)?
  {
    func refect(_ incident: SIMD3<Double>, _ normal: SIMD3<Double>) -> SIMD3<Double>
    {
      return simd_reflect(simd_normalize(incident),
                          simd_normalize(normal))
    }
    
    if let (n1, n2) = self.normal(ofSide: s)
    {
      return (refect(v, n1), refect(v, n2))
    }
    else
    {
      return nil
    }
  }
  
}
