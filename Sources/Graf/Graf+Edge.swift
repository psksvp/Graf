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
    let p1:Vector3
    let p2:Vector3
  
    var length: Double
    {
      #if os(macOS)
      return simd_distance(p1, p2)
      #else
      return length(p1, p2)
      #endif
    }
  
    var normal: (Vector3, Vector3)
    {
      let d = p2 - p1
      return (Vector3(-d.y, d.x, 1.0), Vector3(d.y, -d.x, 1.0))
    }
  
    init(_ p:Vector3, _ q:Vector3)
    {
      p1 = p
      p2 = q
    }
  
    func intersect(_ e: Edge) -> Bool
    {
      //http://web.archive.org/web/20141127210836/http://content.gpwiki.org/index.php/Polygon_Collision
      func determinant(_ v1: Vector3, _ v2: Vector3) -> Double
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
    
    func reflect(vector v: Vector3) -> (Vector3, Vector3)
    {
      func reflect(_ incident: Vector3, _ normal: Vector3) -> Vector3
      {
        #if os(macOS)
        return simd_reflect(simd_normalize(incident),
                            simd_normalize(normal))
        #else
        return reflect(normalize(incident),
                       normalize(normal))
        #endif
      }
      
      let (n1, n2) = self.normal
      return (reflect(v, n1), reflect(v, n2))
    }
  } // class Edge
} // extension Graf
