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
    var vertices: [SIMD3<Double>] = []
    
    init(_ p: [(Double, Double)])
    {
      for v in p
      {
        vertices.append(SIMD3<Double>(x: v.0, y: v.1, z: 1))
      }
    }
  }
  
  class Line : Polygon
  {
    init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double)
    {
      super.init([(x1, y1), (x2, y2)])
    }
  }
  
  class Rectangle : Polygon
  {
    init(_ x: Double, _ y: Double, _ w: Double, _ h: Double)
    {
      super.init([(x, y), (x + w, y), (x + w, y + h), (x, y + h)])
    }
  } // Rectangle
  
  class Ellipse : Polygon
  {
    init(_ xc: Double,
         _ yc: Double,
         _ w: Double,
         _ h: Double,
         startAngle: Double = 0.0,
         endAngle: Double = 2 * Double.pi,
         step: Double = 0.1 )
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
      
      super.init(coords)
    }
  } // Ellipse
  
  class Circle : Ellipse
  {
    init(_ xc: Double, _ yc: Double, _ r: Double)
    {
      super.init(xc, yc, r + r, r + r)
    }
  }
}


//extension Shape.Polygon
//{
//  
//  
//  func translate(_ dx: Double, _ dy: Double)
//  {
//    
//  }
//}
