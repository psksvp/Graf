//
//  Graf+Polygon+Geometry.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import simd
import CommonSwift


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
    
    func boundaryIntersected() -> Bool
    {
      let b1 = self.boundary
      let r1 = NSRect(x: b1.vertices[0].x,
                      y: b1.vertices[0].y,
                      width: b1.vertices[2].x - b1.vertices[0].x,
                      height: b1.vertices[2].y - b1.vertices[0].y)

      let b2 = p.boundary
      let r2 = NSRect(x: b2.vertices[0].x,
                      y: b2.vertices[0].y,
                      width: b2.vertices[2].x - b2.vertices[0].x,
                      height: b2.vertices[2].y - b2.vertices[0].y)
      

      if NSIntersectsRect(r1, r2)
      {
        let ir = NSIntersectionRect(r1, r2)
        print(ir.width, ir.height)
        return true
      }
      else
      {
        return false
      }
      
      //return NSIntersectsRect(r1, r2)
    }
    
    func edgeIntersect() -> Bool
    {
      // fucking n^2
      for i in 0 ..< self.vertices.count
      {
        for j in 0 ..< p.vertices.count
        {
          if let e1 = self.edge(i),
             let e2 = p.edge(j)
          {
            if e1.intersect(e2)
            {
              return true
            }
          }
          else
          {
            Log.error("i -> \(i) or j -> \(j) is out of range")
            return false
          }
        }
      }
    
      return false
    }

    func vertexInShape() -> Bool
    {
      for v in self.vertices
      {
        if p.contains((v.x, v.y))
        {
          return true
        }
      }

      for v in p.vertices
      {
        if self.contains((v.x, v.y))
        {
          return true
        }
      }

      return false
    }
    

    return edgeIntersect()
  }
}
