//
//  File.swift
//  
//
//  Created by psksvp on 1/5/20.
//

import Foundation
import Graf

#if os(Linux)
import SGLMath
#endif

func demoSetPixel()
{
  Graf.initialize()
  let v = Graf.newView("static", 320, 240)
  
  var x:UInt32 = 0
  var y:UInt32 = 0
  
  v.draw
  {
    dc in
    

    dc.setPixel(x, y, Graf.Color.random)

  }
  
  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mousePressed(let mx, let my, let button) :
        print("button \(button)")
        x = UInt32(mx)
        y = UInt32(my)
      
      default: break
    }
  }
  Graf.run()
}

func demoStaticDraw()
{
  Graf.initialize()
  let v = Graf.newView("static", 640, 600)
  
  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fill = Graf.Fill.color(0.8, 0.5, 0.9, 0.6)
  
    Graf.line(0, 0, Double(dc.width), Double(dc.height)).draw(dc)
    Graf.line(0, Double(dc.height), Double(dc.width), 0).draw(dc)
  
    Graf.rect(10, 10, 100, 100).draw(dc)
    dc.fill = Graf.Fill.color(0.2, 0.5, 0.9, 0.6)
    Graf.ellipse(Double(dc.width/2), Double(dc.height/2), 200, 100).draw(dc)
    dc.fill = Graf.Fill.color(0.2, 0.5, 0.3, 0.6)
    Graf.circle(Double(dc.width - 100), 50, 50).draw(dc)
    
    dc.fontSize = 30
    dc.fill = Graf.Fill.color(0.2, 0.3, 0.6)
    Graf.Text(200, 400, "Helloworld").draw(dc)
  }
  
  Graf.run()
}

func demoDrawWithEvent()
{
  Graf.initialize()
  let v = Graf.newView("events", 640, 600)
  var x:Double = 0
  var y:Double = 50

  //let locText = Graf.Text(320, 100, "")
  let cross = Graf.rect(320, 300, 100, 160) //, step: 0.1)
  let l = Graf.rect(320, 200, 10, 400)
  let r = Graf.rect(300, 10, 100, 300)
  let angle = 0.01

  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fill = Graf.Fill.color(0, 0.8, 0, 0.5)
    
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
      case let .keyPressed(code) :
        print("keycode \(code)")
      case .keyReleased(let code) where code == 44 :
        Graf.quit()
      case let .mouseMoved(mx, my) :
        x = Double(mx)
        y = Double(my)
 
      case let .mousePressed(_ , _, button) :
        print("button \(button)")
        cross.shear(1, 0)
      
      case let .mouseWheel(dx, dy) :
        print("wheel \(dx) \(dy)")
      
      default:
        break
    }
  }
  
  Graf.run()
}

func demoHitTest()
{
  Graf.initialize()
  let poly = [Graf.ellipse(320, 200, 100, 200),
              Graf.rect(100, 100, 100, 150),
              Graf.triangle(400, 300, 50, 300, 25, 200)]
  
  let v = Graf.newView("hit testing", 640, 600)
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
      if s.contains((x, y))
      {
        dc.fill = Graf.Fill.image("./media/chessboard.png")
      }
      else
      {
        dc.fill = Graf.Fill.colorGreen
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
        print(x, y)
      
      default: break
    }
  }
  Graf.run()
}

func demoPong()
{
  Graf.initialize()
  let barWidth = 20.0
  let view = Graf.newView("Pong", 800, 480)
  let topBar = Graf.rect(0, 0, Double(view.width), barWidth)
  let bottomBar = Graf.rect(0, Double(view.height) - barWidth,  Double(view.width), barWidth)
  let leftBar = Graf.rect(0, barWidth, barWidth, Double(view.height) - barWidth)
  let rightPaddle = Graf.rect(Double(view.width - 50), 100, barWidth/2, 200)
  let ball = Graf.circle(Double(view.width / 2), Double(view.height / 2), 25, step: 0.1)
  var vel = Vector3e(Double.random(in: 3 ... 9), Double.random(in: 3 ... 9), 1)
  
  func moveAwayFrom(_ p: Graf.Polygon, _ reflectRay: Vector3e)
  {
    while ball.overlapWith(p)
    {
      ball.translate(reflectRay.x, reflectRay.y)
      print("moving away \(reflectRay)")
    }
  }
  
  view.draw
  {
    dc in
    
    dc.clear()
    topBar.draw(dc)
    bottomBar.draw(dc)
    leftBar.draw(dc)
    rightPaddle.draw(dc)
    ball.draw(dc, fill: false)
    ball.translate(vel.x, vel.y)
    
    var hit = false
    
    if ball.overlapWith(topBar)
    {
      vel = topBar.edge(2)!.reflectRay(vector: vel).0
      moveAwayFrom(topBar, vel)
      hit = true
    }
    else if ball.overlapWith(bottomBar)
    {
      vel = bottomBar.edge(0)!.reflectRay(vector: vel).0
      moveAwayFrom(bottomBar, vel)
      hit = true
    }
    else if ball.overlapWith(leftBar)
    {
      vel = leftBar.edge(1)!.reflectRay(vector: vel).0
      moveAwayFrom(leftBar, vel)
      hit = true
    }
    else if ball.overlapWith(rightPaddle)
    {
      vel = rightPaddle.edge(3)!.reflectRay(vector: vel).0
      moveAwayFrom(rightPaddle, vel)
      hit = true
    }
    
    if hit
    {
      //print(vel)
      vel = vel * Double.random(in: 9 ... 15)
      //Graf.playAudio(fileName: "./media/beep.mp3")
    }
    
      
    if(!dc.viewRect.contains(ball.center))
    {
      dc.fill = Graf.Fill.color(0, 0, 0)
      dc.fontSize = 30
      Graf.Text(Double(dc.width / 2), Double(dc.height / 2), "GAME OVER!").draw(dc)
    }
    
    
    let c = rightPaddle.center
    let (_, nl) = rightPaddle.edge(3)!.normal
    Graf.line(c.x, c.y, c.x + nl.x, c.y + nl.y).draw(dc)
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mouseMoved(let mx , let my):
        rightPaddle.moveTo(Double(mx), Double(my))

      case .mouseWheel(_ , let dy):
        if dy > 0
        {
          rightPaddle.rotate(0.1)
        }
        else if dy < 0
        {
          rightPaddle.rotate(-0.1)
        }
      case .keyPressed(keyCode: _) :
        ball.moveTo(Double(view.width / 2), Double(view.height / 2))
        vel = Vector3e(Double.random(in: -9 ... 9), Double.random(in: -9 ... 9), 1)
      
      default: break
    }
  }
  
  Graf.run()
}



