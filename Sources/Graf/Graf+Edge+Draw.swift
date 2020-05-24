//
//  Graf+Edge+Draw.swift
//  
//
//  Created by psksvp on 24/5/20.
//

import Foundation

extension Graf.Edge
{
  public func draw(_ dc: Graf.DrawingContext)
  {
    Graf.line(self.p1.x, self.p1.y, self.p2.x, self.p2.y).draw(dc)
  }
}
