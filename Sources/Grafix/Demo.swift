//
//  File.swift
//  
//
//  Created by psksvp on 1/5/20.
//

import Foundation


func demoStaticDraw()
{
  let v = Graf.newView(name: "static", size: Graf.Size(640, 600))
  
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
  
  Graf.run()
}

func demoDrawWithEvent()
{
  let v = Graf.newView(name: "events", size: Graf.Size( 640, 600))
  var x:Double = 0
  var y:Double = 50

  //let locText = Graf.Text(320, 100, "")
  let cross = Graf.ellipse(320, 300, 100, 160, step: 0.1)
  let l = Graf.rect(320, 200, 10, 400)
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
        Graf.quit()
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
  
  Graf.run()
}

func demoHitTest()
{
  let poly = [Graf.ellipse(320, 200, 100, 200),
              Graf.rect(100, 100, 100, 150),
              Graf.triangle(400, 300, 50, 300, 25, 200)]
  
  let v = Graf.newView(name: "hit testing", size: Graf.Size( 640, 600))
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
  Graf.run()
}

func demoBall()
{
  Graf.shared()
  let v = Graf.newView(name: "hit testing", size: Graf.Size(640, 600))
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
      Graf.playAudio(fileName: "/Users/psksvp/Downloads/beep.mp3")
    }
    
    if y + r >= dc.height || y - r <= 0
    {
      vy = -vy + (Double.random(in: -1.0 ... 1.0)) * sign(-vy)
      Graf.playAudio(fileName: "/Users/psksvp/Downloads/beep.mp3")
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
  
  
  
  Graf.run()
}

func demoPong()
{
  Graf.shared()
  let barWidth = 20.0
  let view = Graf.newView(name: "Pong", size: Graf.Size(900, 480))
  let topBar = Graf.rect(0, 0, view.width, barWidth)
  let bottomBar = Graf.rect(0, view.height - barWidth,  view.width, barWidth)
  let leftBar = Graf.rect(0, barWidth, barWidth, view.height - barWidth)
  let rightPaddle = Graf.rect(view.width - 50, 100, barWidth/2, 100)
  let ball = Graf.circle(view.width / 2, view.height / 2, 20)
  
  var vel = SIMD3<Double>(Double.random(in: 3 ... 9), Double.random(in: 3 ... 9), 1)

  
  view.draw
  {
    dc in
    
    dc.clear()
    
    topBar.draw(dc)
    bottomBar.draw(dc)
    leftBar.draw(dc)
    rightPaddle.draw(dc)
    ball.draw(dc)
    
    if ball.overlapWith(topBar)
    {
      vel = topBar.refect(vector: vel, onSide: 2)!.0 * Double.random(in: 3 ... 9)
    }
    else if ball.overlapWith(bottomBar)
    {
      vel = bottomBar.refect(vector: vel, onSide: 0)!.0 * Double.random(in: 3 ... 9)
    }
    else if ball.overlapWith(leftBar)
    {
      vel = leftBar.refect(vector: vel, onSide: 1)!.0 * Double.random(in: 3 ... 9)
    }
    else if ball.overlapWith(rightPaddle)
    {
      vel = rightPaddle.refect(vector: vel, onSide: 3)!.0 * Double.random(in: 3 ... 9)
    }
    
      
    ball.translate(vel.x, vel.y)
    
    if(ball.center.x > dc.width)
    {
      dc.fillColor = Graf.Color.black
      dc.fontSize = 30
      Graf.Text(dc.width / 2, dc.height / 2, "GAME OVER!").draw(dc)
    }
    
    
    let c = rightPaddle.center
    let (_, nl) = rightPaddle.normal(ofSide: 3)!
    Graf.line(c.x, c.y, c.x + nl.x, c.y + nl.y).draw(dc)
    
    //let r = rightPaddle.refect(vector: vel, onSide: 3)!
    //print(r)
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mouseMoved(_ , let my):
        rightPaddle.moveTo(Double(view.size.width - 50), Double(my))
      case .mouseWheel(_ , let dy):
        if dy > 0
        {
          rightPaddle.rotate(0.1)
        }
        else if dy < 0
        {
          rightPaddle.rotate(-0.1)
        }
      
      default: break
    }
  }
  
  Graf.run()
}



