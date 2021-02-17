//
//  File.swift
//  
//
//  Created by psksvp on 4/2/21.
//

import Foundation
import SGLMath


public struct Camera
{
  public var position: vec3
  public var eye: vec3
  
  public var viewMatrix: mat4
  {
    SGLMath.lookAtLH(eye, position, vec3(0, 1, 0))
  }
}
