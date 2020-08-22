//
//  Graf+Polygon.swift
//  
//
//  Created by psksvp on 27/4/20.
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
public typealias Vector3e = SIMD3<Double>
public typealias Matrix3e = double3x3
#else
import SGLMath
public typealias Vector3e = Vector3<Double>
public typealias Matrix3e = Matrix3x3<Double>

extension Vector3e
{
  public static func random(in r:ClosedRange<Double>) -> Vector3e
  {
    return Vector3e(Double.random(in: r), Double.random(in: r), Double.random(in: r))
  }
}

#endif


extension Graf
{
  public class Polygon
  {
    var vertices: [Vector3e]
    
    public var center: Vector3e
    {
      let sum = vertices.reduce(Vector3e(0, 0, 0))
                {
                  a, b in

                  Vector3e(a.x + b.x, a.y + b.y, a.z + b.z)
                }

      let n = Double(vertices.count)
      return Vector3e(sum.x / n,
                      sum.y / n,
                      sum.z / n)
    }
    
    public var boundingRect: Polygon
    {
      guard vertices.count > 0 else {return rect(0, 0, 0, 0)}
      
      let minX = vertices.min{ a, b in a.x < b.x}!.x
      let minY = vertices.min{ a, b in a.y < b.y}!.y
      let maxX = vertices.max{ a, b in a.x < b.x}!.x
      let maxY = vertices.max{ a, b in a.y < b.y}!.y
      
      return rect(minX, minY, maxX - minX, maxY - minY)
    }
    
    public var edges: [Edge]
    {
      return (0 ..< vertices.count).map { self.edge($0)! }
    }
    
    
    public init(_ p: [(Double, Double)])
    {
      vertices = p.map { Vector3e($0.0, $0.1, 1) }
    }
    
    public init(_ p: [Vector3e])
    {
      vertices = p
    }
    
    public func edge(_ s:Int) -> Edge?
    {
      guard s >= 0 && s < self.vertices.count else {return nil}
      
      let p1 = self.vertices[s]
      let p2 = self.vertices[(s + 1) % self.vertices.count]
      return Edge(p1, p2)
    }
    
    public func contains(_ v: Vector3e) -> Bool
    {
      return contains((v.x, v.y))
    }
    
    public func contains(_ p: (Double, Double)) -> Bool
    {
      guard vertices.count > 0 else {return false}
      
      //https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon
      //https://wrf.ecse.rpi.edu/Research/Short_Notes/pnpoly.html
      var hit = false
      var i = 0
      var j = vertices.count - 1
      while i < vertices.count
      {
        let (x, y) = p
        let vi = vertices[i]
        let vj = vertices[j]
        if (vi.y > y) != (vj.y > y) &&
           (x < (vj.x - vi.x) * (y - vi.y) / (vj.y - vi.y) + vi.x)
        {
          hit = !hit
        }
        j = i
        i = i + 1
      }
      return hit
    }
  } // Polygon
  
  
  ///// funcs
  
  /**
    
   */
  public class func line(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Polygon
  {
    return Polygon([(x1, y1), (x2, y2)])
  }
  
  public class func line(_ vs: Vector3e, _ ve: Vector3e) -> Polygon
  {
    return Polygon([vs, ve])
  }
  
  /**
   
   */
  public class func vectorLine(_ x: Double,
                               _ y: Double,
                               _ v: Vector3e,
                               headLength: Double = 15,
                               headDegree: Double = 0.5) -> Polygon
  {
    //http://kapo-cpp.blogspot.com/2008/10/drawing-arrows-with-cairo.html
    func arrowHead(_ length: Double, _ degree: Double) -> (Double, Double, Double, Double)
    {
      let angle = atan2(v.y, v.x) + Double.pi
      
      return (x + v.x + length * cos(angle - degree),
              y + v.y + length * sin(angle - degree),
              x + v.x + length * cos(angle + degree),
              y + v.y + length * sin(angle + degree))
    }
    
    let (hx1, hy1, hx2, hy2) = arrowHead(headLength, headDegree)
    return  Polygon([(x, y), (x + v.x, y + v.y),
                     (hx1, hy1), (hx2, hy2), (x + v.x, y + v.y)])
  }
  
  /**
   
   */
  public class func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> Polygon
  {
    return Polygon([(x, y), (x + w, y), (x + w, y + h), (x, y + h)])
  }
  
  public class func rect(width: Double, height: Double) -> Polygon
  {
    return rect(0, 0, width, height)
  }
  
  
  /**
   
   */
  public class func arc(_ xc: Double,
                        _ yc: Double,
                        _ w: Double,
                        _ h: Double,
                        startAngle: Double,
                        endAngle: Double,
                        step: Double = 0.1 ) -> Polygon
  {
    //https://stackoverflow.com/questions/11309596/how-to-get-a-point-on-an-ellipses-outline-given-an-angle
    func copySign(_ a: Double, _ b: Double) -> Double
    {
      let m = fabs(a)
      return b >= 0 ? m : -m
    }
    
    func pointFromAngle(_ a: Double) -> (Double, Double)
    {
      let c = cos(a)
      let s = sin(a)
      let ta = tan(a)
      let rh = w / 2
      let rv = h / 2
      let tt = ta * rh / rv
      let d = 1.0 / sqrt(1.0 + tt * tt)
      let x = xc + copySign(rh * d, c)
      let y = yc + copySign(rv * tt * d, s)
      return (x, y)
    }
    
    var angle = startAngle

    var coords: [(Double, Double)] = [pointFromAngle(angle)]
    angle = angle + step
    while angle < endAngle
    {
      coords.append(pointFromAngle(angle))
      angle = angle + step
    }
    
    return Polygon(coords)
  }
  
  /**
   
   */
  public class func ellipse(_ xc: Double,
                            _ yc: Double,
                            _ w: Double,
                            _ h: Double,
                            step s: Double = 0.1) -> Polygon
  {
    return arc(xc, yc, w, h, startAngle: 0.0, endAngle: 2 * Double.pi, step: s)
  }
  
  public class func ellipse(width: Double, height: Double, step s: Double) -> Polygon
  {
    return ellipse(0, 0, width, height, step: s);
  }
  
  /**
   
   */
  public class func circle(_ xc: Double, _ yc: Double, _ r: Double, step s: Double = 0.1)-> Polygon
  {
    return ellipse(xc, yc, r + r, r + r, step: s)
  }
  
  /**
   
   */
  public class func triangle(_ x1: Double, _ y1: Double,
                             _ x2: Double, _ y2: Double,
                             _ x3: Double, _ y3: Double) -> Polygon
  {
    return Polygon([(x1, y1), (x2, y2), (x3, y3)])
  }
  
  /**
   
   */
  public class func nSidesPolygon(_ cx: Double, _ cy: Double, _ r: Double, sides: Double) -> Polygon?
  {
    guard  sides > 1 else
    {
      Log.error("sides must be > 1")
      return nil
    }
    
    return circle(cx, cy, r, step: (Double.pi * 2) / sides)
  }
}
