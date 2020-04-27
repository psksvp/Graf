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
  
  
  typealias Color = Cairo.Color
  
  ///////////////////\\
  class DrawingContext
  {
    let surface: Cairo.BitmapSurface
    let context: Cairo.Context
    
    var fillColor: Color = Color.transparent
    var strokeColor: Color = Color.black
    var strokeWeight: Double = 1.0
    {
      didSet
      {
        cairo_set_line_width(context.cr, fabs(strokeWeight))
      }
    }
    
    var fontSize: Double = 14.0
    {
      didSet
      {
        cairo_set_font_size(context.cr, fabs(fontSize))
      }
    }
    
    var fontFace: String = "Arial"
    {
      didSet
      {
        cairo_select_font_face(context.cr,
                               fontFace,
                               CAIRO_FONT_SLANT_NORMAL,
                               CAIRO_FONT_WEIGHT_NORMAL)
      }
    }
    
    lazy var viewRect: Rectangle = Rectangle(self, 0, 0, width, height)
    lazy var width: Double = context.width
    lazy var height: Double = context.height
    
    init(_ w: UInt32, _ h: UInt32, _ data: UnsafeMutablePointer<UInt8>, _ stride: Int32)
    {
      surface = Cairo.BitmapSurface(w, h, data, stride)
      context = surface.context
    }
    
    func clear(_ bgColor: Color = Color.white)
    {
      fillColor = bgColor
      viewRect.fill()
    }
    
    func text(_ x: Double, _ y: Double, _ s: String, size: Double = 30.0)
    {
      fillColor.setAsSourceInContext(context)
      cairo_move_to(context.cr, x, y)
      cairo_show_text(context.cr, s)
    }
    
    func line(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Polygon
    {
      return polygon([(x1, y1), (x2, y2)])
    }
    
    func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> Rectangle
    {
      return Rectangle(self, x, y, w, h)
    }
    
    func arc(_ xc: Double, _ yc: Double, _ r: Double, _ sa: Double, _ ea: Double) -> Ellipse
    {
      return Ellipse(self, xc, yc, r + r, r + r, startAngle: sa, endAngle: ea)
    }
    
    func arc(_ xc: Double, _ yc: Double, _ rx: Double, _ ry: Double, _ sa: Double, _ ea: Double) -> Ellipse
    {
      return Ellipse(self, xc, yc, rx + rx, ry + ry, startAngle: sa, endAngle: ea)
    }
    
    func circle(_ xc: Double, _ yc: Double, _ r: Double) -> Circle
    {
      return Circle(self, xc, yc, r)
    }
    
    func polygon(_ coords:[(Double, Double)]) -> Polygon
    {
      return Polygon(self, coords)
    }
    
    func ellipse(_ xc: Double, _ yc: Double, _ w: Double, _ h: Double) -> Ellipse
    {
      return Ellipse(self, xc, yc, w, h)
    }
  } // DrawingContext
  
  
  /////
  class Polygon
  {
    let vertices: [(Double, Double)]
    private let dc: DrawingContext
    private let context: Cairo.Context
    
    init(_ c: DrawingContext, _ p: [(Double, Double)])
    {
      vertices = p
      dc = c
      context = c.context
    }
    
    private func build()
    {
      guard vertices.count > 0 else {return}
      
      if 2 == vertices.count
      {
        let (x1, y1) = vertices.first!
        let (x2, y2) = vertices.last!
        cairo_move_to(context.cr, x1, y1)
        cairo_line_to(context.cr, x2, y2)
        cairo_close_path(context.cr)
      }
      else
      {
        let (sx, sy) = vertices.first!
        cairo_move_to(context.cr, sx, sy)
        for (x, y) in vertices.dropFirst(1)
        {
          cairo_line_to(context.cr, x, y)
        }
        cairo_close_path(context.cr)
      }

    }
    
    func stroke()
    {
      build()
      context.stroke(dc.strokeColor)
    }
    
    func fill()
    {
      if vertices.count <= 2
      {
        stroke()
      }
      else
      {
        build()
        context.fill(dc.fillColor)
      }
    }
    
    func strokeAndFill()
    {
      build()
      context.stroke(dc.strokeColor, preserved: true)
      context.fill(dc.fillColor)
    }
  } //Polygon
  
  class Rectangle : Polygon
  {
    init(_ c: DrawingContext, _ x: Double, _ y: Double, _ w: Double, _ h: Double)
    {
      super.init(c, [(x, y), (x + w, y), (x + w, y + h), (x, y + h)])
    }
  } // Rectangle
  
  class Ellipse : Polygon
  {
    init(_ c: DrawingContext,
         _ xc: Double,
         _ yc: Double,
         _ w: Double,
         _ h: Double,
         startAngle: Double = 0.0,
         endAngle: Double = 2 * Double.pi,
         step: Double = 0.1 )
    {
      //https://stackoverflow.com/questions/11309596/how-to-get-a-point-on-an-ellipses-outline-given-an-angle
      func copySign(_ a: Double, _ b: Double) -> Double
      {
        let m = fabs(a)
        return b >= 0 ? m : -m
      }
      
      func pointFromAngle(_ a: Double) -> (Double, Double)
      {
        let c = cos(a)
        let s = sin(a)
        let ta = tan(a)
        let rh = w / 2
        let rv = h / 2
        let tt = ta * rh / rv
        let d = 1.0 / sqrt(1.0 + tt * tt)
        let x = xc + copySign(rh * d, c)
        let y = yc + copySign(rv * tt * d, s)
        return (x, y)
      }
      
      var angle = startAngle

      var coords: [(Double, Double)] = [pointFromAngle(angle)]
      angle = angle + step
      while angle < endAngle
      {
        coords.append(pointFromAngle(angle))
        angle = angle + step
      }
      
      super.init(c, coords)
    }
  } // Ellipse
  
  class Circle : Ellipse
  {
    init(_ c: DrawingContext, _ xc: Double, _ yc: Double, _ r: Double)
    {
      super.init(c, xc, yc, r + r, r + r)
    }
  }
  
} //Graf


/*
 POINT rotate_point(float cx,float cy,float angle,POINT p)
 {
   float s = sin(angle);
   float c = cos(angle);

   // translate point back to origin:
   p.x -= cx;
   p.y -= cy;

   // rotate point
   float xnew = p.x * c - p.y * s;
   float ynew = p.x * s + p.y * c;

   // translate point back:
   p.x = xnew + cx;
   p.y = ynew + cy;
   return p;
 }
 */
