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
    
    dc.fontSize = 30
    dc.fillColor = Graf.Color(0.2, 0.3, 0.6)
    Graf.Text(200, 400, "Helloworld").draw(dc)
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
  let angle = 0.01

  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fillColor = Graf.Color(0, 0.8, 0, 0.5)
    
    cross.rotate(angle).moveTo(x, y).draw(dc)
    
    
    l.rotate(angle).draw(dc)
    r.rotate(angle).draw(dc)
   
    
    if l.overlapWith(cross)
    {
      cross.boundary.draw(dc, fill: false)
      l.boundary.draw(dc, fill: false)
    }
    
    
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
              Graf.rect(100, 100, 100, 150),
              Graf.triangle(400, 300, 50, 300, 25, 200)]
  
  let v = Graf.shared().newView(name: "hit testing", size: Graf.Size(width: 640, height: 600))
  var x:Double = 0
  var y:Double = 0
  let angle = 0.01
  
  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    poly[2].rotate(angle).draw(dc)
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
  
  let ball = Graf.circle(320, 230, r)
  
  func distance(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double
  {
    let dx = x1 - x2
    let dy = y1 - y2
    return sqrt( dx * dx + dy * dy )
  }
  
  func sign(_ d: Double) -> Double
  {
    return d >= 0.0 ? 1.0 : -1.0
  }
  
  v.draw
  {
    dc in
    
    dc.clear()
    
    ball.moveTo(x, y).draw(dc)
    
    x = x + vx
    y = y + vy
    
    
    if x + r >= dc.width || x - r <= 0
    {
      vx = -vx + (Double.random(in: -1.0 ... 1.0)) * sign(-vx)
      Graf.playAudio(fileName: "/Users/psksvp/Downloads/beep.aiff")
    }
    
    if y + r >= dc.height || y - r <= 0
    {
      vy = -vy + (Double.random(in: -1.0 ... 1.0)) * sign(-vy)
      Graf.playAudio(fileName: "/Users/psksvp/Downloads/beep.aiff")
    }
  }
  
  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mousePressed(let mx, let my, _):
        print(evt)
        if ball.hitTest((Double(mx), Double(my)))
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



