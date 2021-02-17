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
  func setPixel(_ x: Int, _ y: Int, _ c: Color)
  func clear(_ c: Color)
}
