//
//  File.swift
//  
//
//  Created by psksvp on 4/2/21.
//

import Foundation
import SGLMath

public struct Mesh
{
  public var name: String
  public var position: vec3
  public var rotation: vec3
  private(set) var vertices = [vec3]()
  
  public var worldMatrix: mat4
  {
    var world = mat4() // identity
      
    world = SGLMath.rotate(world, rotation.x, vec3(1, 0, 0))
    world = SGLMath.rotate(world, rotation.y, vec3(0, 1, 0))
    world = SGLMath.rotate(world, rotation.z, vec3(0, 0, 1))
    
    return SGLMath.translate(world, position)
  }
}
