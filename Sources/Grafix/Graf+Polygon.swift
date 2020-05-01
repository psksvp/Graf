//
//  Graf+Polygon.swift
//  
//
//  Created by psksvp on 27/4/20.
//

import Foundation

extension Graf
{
  class Polygon
  {
    let vertices: [SIMD3<Double>]
    
    var center: SIMD3<Double>
    {
      let sum = vertices.reduce(SIMD3<Double>(0, 0, 0))
                {
                  a, b in
                
                  SIMD3<Double>(a.x + b.x, a.y + b.y, a.z + b.z)
                }
      
      let n = Double(vertices.count)
      return SIMD3<Double>(sum.x / n,
                           sum.y / n,
                           sum.z / n)
    }
    
    var boundary: Polygon
    {
      guard vertices.count > 0 else {return rect(0, 0, 0, 0)}
      
      let minX = vertices.min{ a, b in a.x < b.x}!.x
      let minY = vertices.min{ a, b in a.y < b.y}!.y
      let maxX = vertices.min{ a, b in a.x > b.x}!.x
      let maxY = vertices.min{ a, b in a.y > b.y}!.y
      
      return rect(minX, minY, maxX - minX, maxY - minY)
    }
    
    init(_ p: [(Double, Double)])
    {
      vertices = p.map { SIMD3<Double>($0.0, $0.1, 1) }
    }
    
    init(_ p: [SIMD3<Double>])
    {
      vertices = p
    }
    
    func hitTest(_ p: (Double, Double)) -> Bool
    {
      guard vertices.count > 0 else {return false}
      
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
