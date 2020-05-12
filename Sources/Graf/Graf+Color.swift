//
//  Graf+Color.swift
//  
//
//  Created by psksvp on 11/5/20.
//

import Foundation

extension Graf
{
  public class Color
  {
    private var components:[UInt8] = [0, 0, 0, 0]
    
    var redChannel: UInt8
    {
      get {return components[0]}
      set {components[0] = newValue}
    }
    
    var greenChannel: UInt8
    {
      get {return components[1]}
      set {components[1] = newValue}
    }
    
    var blueChannel: UInt8
    {
      get {return components[2]}
      set {components[2] = newValue}
    }
    
    var alphaChannel: UInt8
    {
      get {return components[3]}
      set {components[3] = newValue}
    }
    
    public init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = 255)
    {
      redChannel = r
      greenChannel = g
      blueChannel = b
      alphaChannel = a
    }
    
    public static let black = Color(0, 0, 0)
    public static let white = Color(255, 255, 255)
  }
}
