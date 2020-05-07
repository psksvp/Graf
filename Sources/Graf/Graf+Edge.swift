//
//  Edge.swift
//  
//
//  Created by psksvp on 4/5/20.
//

import Foundation

#if os(macOS)
import simd
#else
import SGLMath
#endif


extension Graf
{
  class Edge
  {
    let p1:Vector3e
    let p2:Vector3e
  
    var length: Double
    {
      #if os(macOS)
      return simd_distance(p1, p2)
      #else
      return distance(p1, p2)
      #endif
    }
  
    var normal: (Vector3e, Vector3e)
    {
      let d = p2 - p1
      return (Vector3e(-d.y, d.x, 1.0), Vector3e(d.y, -d.x, 1.0))
    }
  
    init(_ p:Vector3e, _ q:Vector3e)
    {
      p1 = p
      p2 = q
    }
  
    func intersect(_ e: Edge) -> Bool
    {
      //http://web.archive.org/web/20141127210836/http://content.gpwiki.org/index.php/Polygon_Collision
      func determinant(_ v1: Vector3e, _ v2: Vector3e) -> Double
      {
        return v1.x * v2.y - v1.y * v2.x
      }
  
      let a = self.p1
      let b = self.p2
      let c = e.p1
      let d = e.p2
      let det = determinant(b - a, c - d);
      let t   = determinant(c - a, c - d) / det;
      let u   = determinant(b - a, c - a) / det;
  
      return !((t < 0) || (u < 0) || (t > 1) || (u > 1))
    }
    
    func reflect(vector v: Vector3e) -> (Vector3e, Vector3e)
    {
      #if os(macOS)
      func reflect(_ incident: Vector3e, _ normal: Vector3e) -> Vector3e
      {
       
        return simd_reflect(simd_normalize(incident),
                            simd_normalize(normal))
      }
      let (n1, n2) = self.normal
      return (reflect(v, n1), reflect(v, n2))
      #else
      let (n1, n2) = self.normal
      let r1 = reflect(v, n1)
      let r2 = reflect(v, n2)
      return (r1, r2)
      #endif
      
      
    }
  } // class Edge
} // extension Graf
