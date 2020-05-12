//
//  Graf+DrawingContext.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import CommonSwift
import SDL2

extension Graf
{
  public class DrawingContext
  {
    public let width: UInt32
    public let height: UInt32
    
    public var strokeColor = Color.black
    public var fill:Graf.Fill = .color(Color.white)
    
    let sdlRenderer: OpaquePointer
  
    init(_ v: Graf.View)
    {
      width = v.width
      height = v.height
      sdlRenderer = v.sdlRenderer
    }
    
    public func clear(_ bgColor: Graf.Color = Graf.Color.white)
    {
      boxRGBA(sdlRenderer,
              0,0,
              Int16(width),
              Int16(height),
              bgColor.greenChannel,
              bgColor.greenChannel,
              bgColor.blueChannel,
              bgColor.alphaChannel)
    }
    
    public func setPixel(_ x: Int16, _ y: Int16, _ c: Graf.Color)
    {
      pixelRGBA(sdlRenderer, x, y,
                c.redChannel,
                c.greenChannel,
                c.blueChannel,
                c.alphaChannel)
    }
    
    public func line(_ x1: Int16, _ y1: Int16, _ x2: Int16, _ y2: Int16)
    {
      aalineRGBA(sdlRenderer,x1,
                             y1,
                             x2,
                             y2,
                            strokeColor.redChannel,
                            strokeColor.greenChannel,
                            strokeColor.blueChannel,
                            strokeColor.alphaChannel)
    }
    
    
    public func stokePolygon(_ xs:[Int16], _ ys:[Int16], _ c: Graf.Color = Graf.Color.black)
    {
      aapolygonRGBA(sdlRenderer, xs, ys, Int32(xs.count), strokeColor.redChannel,
                                                          strokeColor.greenChannel,
                                                          strokeColor.blueChannel,
                                                          strokeColor.alphaChannel)
    }
    
    public func fillPolygon(_ xs:[Int16], _ ys:[Int16])
    {
      switch fill
      {
        case let .color(c) :filledPolygonRGBA(sdlRenderer,
                                              xs, ys, Int32(xs.count),
                                              c.redChannel,
                                              c.greenChannel,
                                              c.blueChannel,
                                              c.alphaChannel)
        case let .texture(image): texturedPolygon(sdlRenderer,
                                                  xs, ys, Int32(xs.count),
                                                  image.surface,
                                                  0, 0)
      }
    }
    

  } // DrawingContext
}


protocol Drawable
{
  func draw(_ dc: Graf.DrawingContext, stroke: Bool, fill: Bool)
}

