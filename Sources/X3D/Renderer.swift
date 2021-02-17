//
//  File.swift
//  
//
//  Created by psksvp on 5/2/21.
//

import Foundation
import SGLMath

class Renderer
{
  let display: Display
  
  init(_ d: Display)
  {
    display = d
  }
  
  func project(_ coord: vec3, _ transformMat: mat4) -> vec2
  {
    let x = (coord.x * transformMat[0,0]) +
            (coord.y * transformMat[0,1]) +
            (coord.z * transformMat[0,2]) +
                       transformMat[0,3]
    
    let y = (coord.x * transformMat[1,0]) +
            (coord.y * transformMat[1,1]) +
            (coord.z * transformMat[1,2]) +
                       transformMat[1,3]
    
    let z = (coord.x * transformMat[2,0]) +
            (coord.y * transformMat[2,1]) +
            (coord.z * transformMat[2,2]) +
                       transformMat[2,3]
    
    let w = Float(1) / ((coord.x * transformMat[3,0]) +
                        (coord.x * transformMat[3,1]) +
                        (coord.x * transformMat[3,2]) +
                                   transformMat[3,3])
    
    let (px, py, _) = (x * w, y * w, z * w)
    
    return vec2(px * Float(display.width) + Float(display.width) / Float(2.0),
                py * Float(display.height) + Float(display.height) / Float(2.0))
  }
  
  func render(_ mashes: [Mesh], _ c: Camera)
  {
    let projectMat = SGLMath.perspectiveRH(0.78,
                                           Float(display.width) / Float(display.height),
                                           0.01,
                                           1.0)
    
    for m in mashes
    {
      let transformMatrix = m.worldMatrix * c.viewMatrix * projectMat
      for v in m.vertices
      {
        let p = project(v, transformMatrix)
        display.setPixel(Int(p.x), Int(p.y), vec4(0, 0, 0, 1))
      }
    }
    
  }
}
