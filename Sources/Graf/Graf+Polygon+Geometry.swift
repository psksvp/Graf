//
//  Graf+Polygon+Geometry.swift
//  
//
//  Created by psksvp on 29/4/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2020. by Pongsak Suvanpong (psksvp@gmail.com)
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification,
*  are permitted provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice,
*  this list of conditions and the following disclaimer.
*
*  2. Redistributions in binary form must reproduce the above copyright notice,
*  this list of conditions and the following disclaimer in the documentation
*  and/or other materials provided with the distribution.
*
*  3. Neither the name of the copyright holder nor the names of its contributors may
*  be used to endorse or promote products derived from this software without
*  specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
*  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* This information is provided for personal educational purposes only.
*
* The author does not guarantee the accuracy of this information.
*
* By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
*/

import Foundation
import CommonSwift

#if os(macOS)
import simd
#else
import SGLMath
#endif

extension Graf.Polygon : Tranformable
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
  public func moveTo(_ x: Double, _ y: Double) -> Tranformable
  {
    let c = self.center
    return translate(x - c.x, y - c.y)
  }
  
  @discardableResult
  public func translate(_ dx: Double, _ dy: Double) -> Tranformable
  {
    let m = matrix(Vector3e(1,   0, 0),
                   Vector3e(0,   1, 0),
                   Vector3e(dx, dy, 1))
    
    return transform(m)
  }
  
  @discardableResult
  public func scale(_ sx: Double, _ sy: Double) -> Tranformable
  {
    let m = matrix(Vector3e(sx,  0, 0),
                   Vector3e(0,  sy, 0),
                   Vector3e(0,   0, 1))
    let c = self.center
    return transform(m).moveTo(c.x, c.y)
  }
  
  @discardableResult
  public func shear(_ sx: Double, _ sy: Double) -> Tranformable
  {
    let m = matrix(Vector3e(1,  sx, 0),
                  Vector3e(sy,  1, 0),
                  Vector3e(0,   0, 1))
    return transform(m)
  }
  
  @discardableResult
  public func rotate(_ angle: Double) -> Tranformable
  {
    let m = matrix(Vector3e(cos(angle), sin(angle), 0),
                   Vector3e(-sin(angle), cos(angle), 0),
                   Vector3e(0, 0, 1))
    
    let c = self.center
    moveTo(0, 0)
    return transform(m).moveTo(c.x, c.y)
  }
  
  @discardableResult
  public func transform(_ m: Matrix3e) -> Tranformable
  {
    vertices = vertices.map { $0 * m }
    return self
  }
} // Extension Graf.Polygon

extension Graf
{
  public class func transform(_ p: Polygon, _ m: Matrix3e) -> Polygon
  {
    return Polygon(p.vertices.map{$0 * m})
  }
  
  public class func sides(_ p: Polygon) -> [Polygon]
  {
    return (0 ..< p.vertices.count - 1).map { line(p.vertices[$0], p.vertices[$0 + 1])} +
           [Graf.line(p.vertices.last!, p.vertices.first!)]
  }
  
//  public class func triangleMash(_ p: Polygon) -> [Polygon]
//  {
//    guard p.vertices.count > 3 else {return [p]}
//    
//    
//  }
  
  /**
   
   */
  public class func intersected(_ e1: Graf.Edge, _ e2: Graf.Edge) -> Bool
  {
    //http://web.archive.org/web/20141127210836/http://content.gpwiki.org/index.php/Polygon_Collision
    func determinant(_ v1: Vector3e, _ v2: Vector3e) -> Double
    {
      return v1.x * v2.y - v1.y * v2.x
    }
    
    let a = e1.p1
    let b = e1.p2
    let c = e2.p1
    let d = e2.p2
    let det = determinant(b - a, c - d);
    let t   = determinant(c - a, c - d) / det;
    let u   = determinant(b - a, c - a) / det;
    
    return !((t < 0) || (u < 0) || (t > 1) || (u > 1))
  }
  
  //////
  public class  func intersected(_ p: Graf.Polygon,
                                 _ q: Graf.Polygon) -> (Graf.Edge, Graf.Edge)?
  {
    // cheapest but less accurate
    func boundaryIntersected() -> Bool
    {
      let b1 = q.boundingRect
      let r1 = NSRect(x: b1.vertices[0].x,
                      y: b1.vertices[0].y,
                      width: b1.vertices[2].x - b1.vertices[0].x,
                      height: b1.vertices[2].y - b1.vertices[0].y)
      
      let b2 = p.boundingRect
      let r2 = NSRect(x: b2.vertices[0].x,
                      y: b2.vertices[0].y,
                      width: b2.vertices[2].x - b2.vertices[0].x,
                      height: b2.vertices[2].y - b2.vertices[0].y)
      
      return NSIntersectsRect(r1, r2)
    }
    
    // parallel inner loop  of the above
    func edgeIntersectedPar() -> (Graf.Edge, Graf.Edge)?
    {
      // any edge of Polygon polygon intersected with Edge e
      func intersected(polygon: Graf.Polygon, withEdge e: Graf.Edge) -> Int?
      {
        var intersectedIdx = -1
        DispatchQueue.concurrentPerform(iterations: polygon.vertices.count)
        {
          idx in
          
          if Graf.intersected(polygon.edge(idx)!, e)
          {
            intersectedIdx = idx
          }
        }
        
        return intersectedIdx >= 0 ? intersectedIdx : nil
      }
      
      let (w, v) = p.vertices.count >= q.vertices.count ? (p, q) : (q, p)
      
      for i in 0 ..< v.vertices.count
      {
        if let e = v.edge(i),
          let idx = intersected(polygon: w, withEdge: e),
          idx >= 0
        {
          return v === p ? (e, w.edge(idx)!) : (w.edge(idx)!, e)
        }
      }
      return nil
    }
    
    guard p.vertices.count > 0 &&
          q.vertices.count > 0 else {return nil}
    //if boundary has not touched?
    guard boundaryIntersected() else { return nil }
    
    return edgeIntersectedPar()
  }
}
