//
//  Graf+Image.swift
//  
//
//  Created by psksvp on 9/5/20.
//

import Foundation
import SDL2

extension Graf
{
  public class Image : Drawable
  {
    let surface:UnsafeMutablePointer<SDL_Surface>
    
    public init(_ f: String)
    {
      self.surface = IMG_Load(f) // error handling?
    }
    
    deinit
    {
      SDL_FreeSurface(surface)
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
    }
  }
}
