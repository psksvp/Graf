//
//  Graf+Polygon.swift
//  
//
//  Created by psksvp on 27/4/20.
//

import Foundation

#if os(macOS)
typealias Vector3 = SIMD3<Double>
#else
import SGLMath
typealias Vector3 = Vector3<Double>
#endif


extension Graf
{
  class Polygon
  {
    var vertices: [Vector3]
    
    var center: Vector3
    {
      let sum = vertices.reduce(Vector3(0, 0, 0))
                {
                  a, b in
                
                  Vector3(a.x + b.x, a.y + b.y, a.z + b.z)
                }
      
      let n = Double(vertices.count)
      return Vector3(sum.x / n,
                           sum.y / n,
                           sum.z / n)
    }
    
    var boundary: Polygon
    {
      guard vertices.count > 0 else {return rect(0, 0, 0, 0)}
      
      let minX = vertices.min{ a, b in a.x < b.x}!.x
      let minY = vertices.min{ a, b in a.y < b.y}!.y
      let maxX = vertices.max{ a, b in a.x < b.x}!.x
      let maxY = vertices.max{ a, b in a.y < b.y}!.y
      
      return rect(minX, minY, maxX - minX, maxY - minY)
    }
    
    
    init(_ p: [(Double, Double)])
    {
      vertices = p.map { Vector3($0.0, $0.1, 1) }
    }
    
    init(_ p: [Vector3])
    {
      vertices = p
    }
    
    func edge(_ s:Int) -> Edge?
    {
      guard s >= 0 && s < self.vertices.count else {return nil}
      
      let p1 = self.vertices[s]
      let p2 = self.vertices[(s + 1) % self.vertices.count]
      return Edge(p1, p2)
    }
    
    func contains(_ v: Vector3) -> Bool
    {
      return contains((v.x, v.y))
    }
    
    func contains(_ p: (Double, Double)) -> Bool
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
  
  class func line(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Polygon
  {
    return Polygon([(x1, y1), (x2, y2)])
  }
  
  class func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> Polygon
  {
    return Polygon([(x, y), (x + w, y), (x + w, y + h), (x, y + h)])
  }
  
  class func arc(_ xc: Double,
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
  
  class func ellipse(_ xc: Double,
                     _ yc: Double,
                     _ w: Double,
                     _ h: Double,
                     step s: Double = 0.1) -> Polygon
  {
    return arc(xc, yc, w, h, startAngle: 0.0, endAngle: 2 * Double.pi, step: s)
  }
  
  class func circle(_ xc: Double, _ yc: Double, _ r: Double, step s: Double = 0.1)-> Polygon
  {
    return ellipse(xc, yc, r + r, r + r, step: s)
  }
  
  class func triangle(_ x1: Double, _ y1: Double,
                      _ x2: Double, _ y2: Double,
                      _ x3: Double, _ y3: Double) -> Polygon
  {
    return Polygon([(x1, y1), (x2, y2), (x3, y3)])
  }
}
