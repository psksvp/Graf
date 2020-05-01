//
//  File.swift
//  
//
//  Created by psksvp on 1/5/20.
//

import Foundation


func demoStaticDraw()
{
  let graf = Graf.shared()

  let v = graf.newView(name: "static", size: Graf.Size(width: 640, height: 600))
  
  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fillColor = Graf.Color(0.8, 0.5, 0.9, 0.6)
  
    Graf.line(0, 0, dc.width, dc.height).draw(dc)
    Graf.line(0, dc.height, dc.width, 0).draw(dc)
  
    Graf.rect(10, 10, 100, 100).draw(dc)
    dc.fillColor = Graf.Color(0.2, 0.5, 0.9, 0.6)
    Graf.ellipse(dc.width/2, dc.height/2, 200, 100).draw(dc)
    dc.fillColor = Graf.Color(0.2, 0.5, 0.3, 0.6)
    Graf.circle(dc.width - 100, 50, 50).draw(dc)
  }
  
  graf.run()
}

func demoDrawWithEvent()
{
  let graf = Graf.shared()

  let v = graf.newView(name: "events", size: Graf.Size(width: 640, height: 600))
  var x:Double = 0
  var y:Double = 50

  //let locText = Graf.Text(320, 100, "")
  let cross = Graf.ellipse(320, 300, 100, 160, step: 0.1)
  let l = Graf.line(320, 200, 320, 400)
  let r = Graf.rect(300, 10, 100, 300)
  var angle = 0.0

  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fillColor = Graf.Color(0, 0.8, 0, 0.5)
    
    let m = cross.rotate(angle).moveTo(x, y)
    m.draw(dc)
    m.boundary.draw(dc, fill: false)
    
    l.rotate(angle).draw(dc)
    r.rotate(angle).draw(dc)
    
    angle = angle + 0.01
    
  }

  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .keyPressed(let code) :
        print("keycode \(code)")
      case .keyReleased(let code) where code == 44 :
        graf.quit()
      case .mouseMoved(let mx, let my) :
        x = Double(mx)
        y = Double(my)

      case .mousePressed(_ , _, let button) :
        print("button \(button)")
        cross.shear(1, 0)
      
      case .mouseWheel(let dx, let dy) :
        print("wheel \(dx) \(dy)")
      
      default:
        break
    }
  }
  
  graf.run()
}

func demoHitTest()
{
  let poly = [Graf.ellipse(320, 200, 100, 200),
              Graf.rect(10, 10, 100, 150),
              Graf.triangle(10, 300, 50, 300, 25, 200)]
  
  let v = Graf.shared().newView(name: "hit testing", size: Graf.Size(width: 640, height: 600))
  var x:Double = 0
  var y:Double = 0
  
  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    
    for s in poly
    {
      if s.hitTest((x, y))
      {
        dc.fillColor = Graf.Color.red
      }
      else
      {
        dc.fillColor = Graf.Color.green
      }
      s.draw(dc)
    }
  }
  
  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mouseMoved(let mx, let my) :
        x = Double(mx)
        y = Double(my)
      
      default: break
    }
  }
  Graf.shared().run()
}

func demoBall()
{
  let v = Graf.shared().newView(name: "hit testing", size: Graf.Size(width: 640, height: 600))
  var x = Double(v.size.width / 2)
  var y = Double(v.size.height / 2)
  var r = 50.0
  var vx = Double.random(in: -10.0 ... 10.0)
  var vy = Double.random(in: -10.0 ... 10.0)
  
  func distance(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double
  {
    let dx = x1 - x2
    let dy = y1 - y2
    return sqrt( dx * dx + dy * dy )
  }
  
  v.draw
  {
    dc in
    
    dc.clear()
    
    Graf.circle(x, y, r).draw(dc, fill: false)
    
    x = x + vx
    y = y + vy
    
    if x + r >= dc.width || x - r <= 0
    {
      vx = -vx
    }
    
    if y + r >= dc.height || y - r <= 0
    {
      vy = -vy
    }
  }
  
  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mousePressed(let mx, let my, _):
        print(evt)
        if distance(Double(mx), Double(my), x, y) <= r
        {
          r = Double.random(in: 20 ... 60)
          vx = Double.random(in: -10.0 ... 10.0)
          vy = Double.random(in: -10.0 ... 10.0)
        }
      
      default: break
    }
  }
  
  
  
  Graf.shared().run()
}



