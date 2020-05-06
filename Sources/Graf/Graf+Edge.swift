//
//  Edge.swift
//  
//
//  Created by psksvp on 4/5/20.
//

import Foundation
import simd

extension Graf
{
  class Edge
  {
    let p1:SIMD3<Double>
    let p2:SIMD3<Double>
  
    var length: Double
    {
      simd_distance(p1, p2)
    }
  
    var normal: (SIMD3<Double>, SIMD3<Double>)
    {
      let d = p2 - p1
      return (SIMD3<Double>(-d.y, d.x, 1.0), SIMD3<Double>(d.y, -d.x, 1.0))
    }
  
    init(_ p:SIMD3<Double>, _ q:SIMD3<Double>)
    {
      p1 = p
      p2 = q
    }
  
    func intersect(_ e: Edge) -> Bool
    {
      //http://web.archive.org/web/20141127210836/http://content.gpwiki.org/index.php/Polygon_Collision
      func determinant(_ v1: SIMD3<Double>, _ v2: SIMD3<Double>) -> Double
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
    
    func reflect(vector v: SIMD3<Double>) -> (SIMD3<Double>, SIMD3<Double>)
    {
      func reflect(_ incident: SIMD3<Double>, _ normal: SIMD3<Double>) -> SIMD3<Double>
      {
        return simd_reflect(simd_normalize(incident),
                            simd_normalize(normal))
      }
      
      let (n1, n2) = self.normal
      return (reflect(v, n1), reflect(v, n2))
    }
  } // class Edge
} // extension Graf
