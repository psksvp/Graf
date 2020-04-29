//
//  File.swift
//  
//
//  Created by psksvp on 21/4/20.
//

import Foundation
import SDL2
import CCairo
import CommonSwift


class Graf
{
  private static var sharedGraf: Graf? = nil
  
  class func shared() -> Graf
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
    SDL_Init(SDL_INIT_VIDEO)
    SDL_InitSubSystem(SDL_INIT_VIDEO)
  }
  
  deinit
  {
    SDL_Quit()
  }
  
  func newView(name n: String, size s: Size) -> View
  {
    let v = View(name: n, size: s)
    views[v.id] = v
    return v
  }
  
  func run()
  {
    func mouseState(_ e: SDL_Event) -> (Int32, Int32)
    {
      var x: Int32 = 0
      var y: Int32 = 0
      SDL_GetMouseState( &x, &y )
      return (x, y)
    }
    
    func dispatchEvent(_ vid: UInt32, _ e: SDL_Event)
    {
      guard let v = views[vid] else { return }
      var x: Int32 = 0
      var y: Int32 = 0
      
      switch(SDL_EventType(e.type))
      {
        case SDL_KEYDOWN:
          v.handleEvent(Event.keyPressed(e.key.keysym.scancode.rawValue))
        
        case SDL_KEYUP:
          v.handleEvent(Event.keyReleased(e.key.keysym.scancode.rawValue))
        
        case SDL_MOUSEBUTTONDOWN:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mousePressed(x, y, e.button.button))
        
        case SDL_MOUSEBUTTONUP:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mouseReleased(x, y, e.button.button))
        
        case SDL_MOUSEMOTION:
          SDL_GetMouseState( &x, &y )
          v.handleEvent(Event.mouseMoved(x, y))
        
        case SDL_MOUSEWHEEL:
          v.handleEvent(Event.mouseWheel(event.wheel.x, event.wheel.y))
        
        case SDL_WINDOWEVENT where event.window.event == SDL_WINDOWEVENT_CLOSE.rawValue:
          Log.info("Quiting")
          self.quit()
      
        default:
          break
      }
    }
    
    looping = true
    var event: SDL_Event = SDL_Event()
    while looping
    {
      for v in views.values
      {
        v.render()
      }
      
      while SDL_PollEvent(&event) != 0
      {
        dispatchEvent(event.window.windowID, event)
      }
    }
  }
  
  func quit()
  {
    self.looping = false
  }
  
  ///////
  
  enum Event
  {
    case keyPressed(UInt32)
    case keyReleased(UInt32)
    case mousePressed(Int32, Int32, UInt8)
    case mouseReleased(Int32, Int32, UInt8)
    case mouseMoved(Int32, Int32)
    case mouseWheel(Int32, Int32)
  }
  
  struct Size
  {
    var width: UInt32
    var height: UInt32
  }

  typealias Color = Cairo.Color
} //Graf
