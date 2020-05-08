//
//  Graf+Polygon+Geometry.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CommonSwift

#if os(macOS)
import simd
#else
import SGLMath
#endif

extension Graf.Polygon
{
  //https://developer.apple.com/documentation/accelerate/working_with_vectors
  
  func matrix(_ r0: Vector3e, _ r1: Vector3e, _ r2: Vector3e) -> Matrix3e
  {
    #if os(macOS)
    return double3x3(rows: [r0, r1, r2])
    #else
    return Matrix3x3<Double>(r0, r1, r2).transpose
    #endif
  }

  
  @discardableResult
  public func moveTo(_ x: Double, _ y: Double) -> Graf.Polygon
  {
    let c = self.center
    return translate(x - c.x, y - c.y)
  }
  
  @discardableResult
  public func translate(_ dx: Double, _ dy: Double) -> Graf.Polygon
  {
    let m = matrix(Vector3e(1,   0, 0),
                   Vector3e(0,   1, 0),
                   Vector3e(dx, dy, 1))
    
    return transform(m)
  }
  
  @discardableResult
  public func scale(_ sx: Double, _ sy: Double) -> Graf.Polygon
  {
    let m = matrix(Vector3e(sx,  0, 0),
                   Vector3e(0,  sy, 0),
                   Vector3e(0,   0, 1))
    return transform(m)
  }
  
  @discardableResult
  public func shear(_ sx: Double, _ sy: Double) -> Graf.Polygon
  {
    let m = matrix(Vector3e(1,  sx, 0),
                  Vector3e(sy,  1, 0),
                  Vector3e(0,   0, 1))
    return transform(m)
  }
  
  @discardableResult
  public func rotate(_ angle: Double) -> Graf.Polygon
  {
    let m = matrix(Vector3e(cos(angle), sin(angle), 0),
                   Vector3e(-sin(angle), cos(angle), 0),
                   Vector3e(0, 0, 1))
    
    let c = self.center
    return moveTo(0, 0).transform(m).moveTo(c.x, c.y)
  }
  
  @discardableResult
  public func transform(_ m: Matrix3e) -> Graf.Polygon
  {
    vertices = vertices.map { $0 * m }
    return self
  }
  
  public func overlapWith(_ p: Graf.Polygon) -> Bool
  {
    guard self.vertices.count > 0 &&
             p.vertices.count > 0 else {return false}
    
    // cheapest
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
      
      return NSIntersectsRect(r1, r2)
    }
    
    // more expensive
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
    
    // the most expensive
    func edgeIntersected() -> Bool
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

    
    // would it do a short circult?
    //return boundaryIntersected() && edgeIntersected()
    
    guard boundaryIntersected() else { return false }
    
    return boundaryIntersected()
  }
}
