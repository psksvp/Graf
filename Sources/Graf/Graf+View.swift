//
//  Graf+View.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import SDL2
import CommonSwift

extension Graf
{
  public class View
  {
    let sdlWindow: OpaquePointer
    let sdlRenderer: OpaquePointer
    
    private var drawing = false
    private var drawFunc: ((DrawingContext) -> Void)? = nil
    private var eventHandlerFunc: ((Event) -> Void)? = nil
    
    public var id: UInt32
    {
      SDL_GetWindowID(sdlWindow)
    }
    
    public let width: UInt32
    public let height: UInt32
    public let name: String
    
    init(_ n: String, _ w: UInt32, _ h: UInt32)
    {
      self.name = n
      self.sdlWindow = SDL_CreateWindow(name,
                                        -1,
                                        -1,
                                        Int32(w),
                                        Int32(h),
                                        SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue)
      self.sdlRenderer = SDL_CreateRenderer(sdlWindow, -1, SDL_RENDERER_PRESENTVSYNC.rawValue)
      self.width = w
      self.height = h
    }
    
    deinit
    {
      if drawing
      {
        endDraw()
      }
      SDL_DestroyRenderer(sdlRenderer)
      SDL_DestroyWindow(sdlWindow)
    }
    
    public func fucus()
    {
      SDL_ShowWindow(sdlWindow)
      SDL_RaiseWindow(sdlWindow)
    }
    
    func handleEvent(_ e: Event)
    {
      guard let ehf = eventHandlerFunc else {return }
      ehf(e)
      if drawing
      {
        endDraw()
      }
    }
    
    func render() -> Void
    {
      guard let df = drawFunc else {return}
      df(beginDraw())
      endDraw()
    }
     
    public func beginDraw() -> DrawingContext
    {
      if drawing
      {
        endDraw()
      }

      drawing = true
      return DrawingContext(self)
    }
    
    public func endDraw()
    {
      guard drawing else
      {
        Log.warn("View.endDraw called without matching beginDraw")
        return
      }
      
      SDL_RenderPresent(sdlRenderer)
      drawing = false
    }
    
    // hooks
    public func draw(_ df:  @escaping (DrawingContext) -> Void)
    {
      drawFunc = df
    }
    
    public func onInputEvent(_ ehf: @escaping (Event) -> Void)
    {
      eventHandlerFunc = ehf
    }
  }
}
