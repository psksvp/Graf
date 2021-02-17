//
//  File.swift
//  
//
//  Created by psksvp on 4/2/21.
//

import Foundation
import SGLMath

protocol Display
{
  var width:Int {get}
  var height:Int {get}
  func setPixel(_ x: Int, _ y: Int, _ color: vec4)
  func clear(_ color: vec4)
}
