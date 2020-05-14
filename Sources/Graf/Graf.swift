//
//  Graf.swift
//  
//
//  Created by psksvp on 21/4/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2018. by Pongsak Suvanpong (psksvp@gmail.com)
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


public class Graf
{
  private static var sharedGraf: Graf? = nil
  
  @discardableResult 
  class func single() -> Graf
  {
    switch sharedGraf
    {
      case .some(let graf) : return graf
      case .none           : sharedGraf = Graf()
                             return sharedGraf!
    }
  }
  
  private var views:[UInt32 : View] = [ : ]
  private var looping = false
  
  private init()
  {
    SDL_InitSubSystem(SDL_INIT_VIDEO|SDL_INIT_AUDIO)
  }
  
  deinit
  {
    SDL_Quit()
  }
  
  ///////////
  public enum Event
  {
    case keyPressed(keyCode: UInt32)
    case keyReleased(keyCode: UInt32)
    case mousePressed(mouseX: Int32, mouseY: Int32, button: UInt8)
    case mouseReleased(mouseX: Int32, mouseY: Int32, button: UInt8)
    case mouseMoved(mouseX: Int32, mouseY: Int32)
    case mouseWheel(deltaX: Int32, deltaY: Int32)
  }
  
  public typealias Color = Cairo.Color
  
  static public var mouseLocation: (Int32, Int32)
  {
    var x: Int32 = 0
    var y: Int32 = 0
    SDL_GetMouseState( &x, &y )
    return (x, y)
  }
  
  public class func initialize()
  {
    Graf.single()
  }
  
  public class func newView(_ n: String, _ w: UInt32, _ h: UInt32) -> View
  {
    let v = View(n, w, h)
    Graf.single().views[v.id] = v
    return v
  }
  
  public class func view(_ n: String) -> View?
  {
    for v in Graf.single().views.values
    {
      if v.name == n
      {
        return v
      }
    }
    
    return nil
  }
  
  public class func run()
  {
    func dispatchEvent(_ vid: UInt32, _ e: SDL_Event)
    {
      guard let v = Graf.single().views[vid] else { return }
      var x: Int32 = 0
      var y: Int32 = 0
      
      switch(SDL_EventType(e.type))
      {
        case SDL_KEYDOWN:
          v.handleEvent(Event.keyPressed(keyCode: e.key.keysym.scancode.rawValue))
        
        case SDL_KEYUP:
          v.handleEvent(Event.keyReleased(keyCode: e.key.keysym.scancode.rawValue))
        
        case SDL_MOUSEBUTTONDOWN:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mousePressed(mouseX: x,
                                           mouseY: y,
                                           button: e.button.button))
        
        case SDL_MOUSEBUTTONUP:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mouseReleased(mouseX: x,
                                            mouseY: y,
                                            button: e.button.button))
        
        case SDL_MOUSEMOTION:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mouseMoved(mouseX: x, mouseY: y))
        
        case SDL_MOUSEWHEEL:
          v.handleEvent(Event.mouseWheel(deltaX: event.wheel.x, deltaY: event.wheel.y))
        
        case SDL_WINDOWEVENT where event.window.event == SDL_WINDOWEVENT_CLOSE.rawValue:
          Log.info("Quiting")
          self.quit()
      
        default:
          break
      }
    }
    
    Graf.single().looping = true
    var event: SDL_Event = SDL_Event()
    while Graf.single().looping
    {
      for v in Graf.single().views.values
      {
        v.render()
      }
      
      while SDL_PollEvent(&event) != 0
      {
        dispatchEvent(event.window.windowID, event)
      }
    }
  }
  
  public class func quit()
  {
    Graf.single().looping = false
  }
  
  ///////
  
  
  
  public class func playAudio(fileName f:String)
  {
    #if os(macOS)
    let cmd = ["/usr/bin/afplay", f]
    #else
    let cmd = ["/usr/bin/ffplay", "-nodisp", "-autoexit", f]
    #endif
    
    DispatchQueue.global(qos: .background).async
    {
      if #available(OSX 10.13, *)
      {
        OS.spawn(cmd, nil)
      }
      else
      {
        Log.error("spawn is unavailable.")
      }
    }
    
  }
} //Graf
