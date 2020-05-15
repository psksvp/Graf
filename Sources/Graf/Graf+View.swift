//
//  Graf+View.swift
//  
//
//  Created by psksvp on 29/4/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2020. by Pongsak Suvanpong (psksvp@gmail.com)
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification,
*  are permitted provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice,
*  this list of conditions and the following disclaimer.
*
*  2. Redistributions in binary form must reproduce the above copyright notice,
*  this list of conditions and the following disclaimer in the documentation
*  and/or other materials provided with the distribution.
*
*  3. Neither the name of the copyright holder nor the names of its contributors may
*  be used to endorse or promote products derived from this software without
*  specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
*  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* This information is provided for personal educational purposes only.
*
* The author does not guarantee the accuracy of this information.
*
* By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
*/
import Foundation
import SDL2
import CCairo
import CommonSwift

extension Graf
{
  public class View
  {
    private let sdlWindow: OpaquePointer
    private let sdlRenderer: OpaquePointer
    private let sdlTexture: OpaquePointer
    
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
      
      #if os(macOS)
      let pixFmt = SDL_PIXELFORMAT_ARGB8888.rawValue
      #else
      let pixFmt = UInt32(SDL_PIXELFORMAT_ARGB8888)
      #endif
      
      self.sdlTexture = SDL_CreateTexture(sdlRenderer,
                                          pixFmt,
                                          Int32(SDL_TEXTUREACCESS_STREAMING.rawValue),
                                          Int32(w),
                                          Int32(h))
      
      self.width = w
      self.height = h
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
      var pitch: Int32 = 0
      var pixels: UnsafeMutableRawPointer? = nil
      SDL_LockTexture(self.sdlTexture,
                      nil,
                      &pixels,
                      &pitch)
      drawing = true
      return DrawingContext(UInt32(width), UInt32(height), UnsafeMutablePointer<UInt8>(OpaquePointer(pixels!)), pitch)
    }
    
    public func endDraw()
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
