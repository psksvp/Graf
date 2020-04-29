//
//  File.swift
//  
//
//  Created by psksvp on 29/4/20.
//

import Foundation
import SDL2
import CCairo
import CommonSwift

extension Graf
{
  class View
  {
    private let sdlWindow: OpaquePointer
    private let sdlRenderer: OpaquePointer
    private let sdlTexture: OpaquePointer
    
    private var drawing = false
    private var drawFunc: ((DrawingContext) -> Void)? = nil
    private var eventHandlerFunc: ((Event) -> Void)? = nil
    
    var id: UInt32
    {
      SDL_GetWindowID(sdlWindow)
    }
    
    var size: Size
    {
       var w: Int32 = 0
       var h: Int32 = 0
       SDL_GetWindowSize(sdlWindow, &w, &h)
       return Size(width: Uint32(w), height: UInt32(h))
    }
    
    init(name: String, size: Size)
    {
      self.sdlWindow = SDL_CreateWindow(name,
                                        -1,
                                        -1,
                                        Int32(size.width),
                                        Int32(size.height),
                                        SDL_WINDOW_SHOWN.rawValue | SDL_WINDOW_ALLOW_HIGHDPI.rawValue)
      self.sdlRenderer = SDL_CreateRenderer(sdlWindow, -1, SDL_RENDERER_PRESENTVSYNC.rawValue)
      self.sdlTexture = SDL_CreateTexture(sdlRenderer,
                                          SDL_PIXELFORMAT_ARGB8888.rawValue,
                                          Int32(SDL_TEXTUREACCESS_STREAMING.rawValue),
                                          Int32(size.width),
                                          Int32(size.height))
    }
    
    deinit
    {
      if drawing
      {
        endDraw()
      }
      SDL_DestroyTexture(sdlTexture)
      SDL_DestroyRenderer(sdlRenderer)
      SDL_DestroyWindow(sdlWindow)
    }
    
    func fucus()
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
     
    func beginDraw() -> DrawingContext
    {
      if drawing
      {
        endDraw()
      }
      var pitch: Int32 = 0
      var pixels: UnsafeMutableRawPointer? = nil
      SDL_LockTexture(self.sdlTexture,
                      nil,
                      &pixels,
                      &pitch)
      drawing = true
      return DrawingContext(size.width, size.height, UnsafeMutablePointer<UInt8>(OpaquePointer(pixels!)), pitch)
    }
    
    func endDraw()
    {
      guard drawing else
      {
        Log.warn("View.endDraw called without matching beginDraw")
        return
      }
      
      SDL_UnlockTexture(sdlTexture)
      SDL_RenderCopy(sdlRenderer, sdlTexture, nil, nil);
      SDL_RenderPresent(sdlRenderer)
      drawing = false
    }
    
    // hooks
    func draw(_ df:  @escaping (DrawingContext) -> Void)
    {
      drawFunc = df
    }
    
    func onInputEvent(_ ehf: @escaping (Event) -> Void)
    {
      eventHandlerFunc = ehf
    }
  }
}
