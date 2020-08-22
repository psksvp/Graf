//
//  Graf+Turtle.swift
//  Graf
//
//  Created by psksvp on 17/5/20.
//

import Foundation

extension Graf
{
  class Turtle
  {
    var heading: Double = 90
    {
      didSet
      {
        
      }
    }
    
    var penDown: Bool = true
    var penWidth: Double = 1.0
    var penColor: Graf.Color = Graf.Color.black
    
    let view: Graf.View
    
  
    public init(_ w: UInt32, _ h: UInt32)
    {
      self.view = Graf.newView("Title World", w, h, retain: true)
      self.view.draw(self.draw)
    }
    
    func draw(_ ctx: Graf.DrawingContext)
    {
      
    }
  }
}


