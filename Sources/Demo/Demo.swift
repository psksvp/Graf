//
//  File.swift
//  
//
//  Created by psksvp on 1/5/20.
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
import Graf
import CommonSwift

#if os(Linux)
import SGLMath
#endif

func demoSetPixel()
{
  Graf.initialize()
  let v = Graf.newView("static", 320, 240)
  
  var x:Int32 = Int32(v.width / 2)
  var y:Int32 = Int32(v.height / 2)
  
  v.draw
  {
    dc in
    dc.clear()
  
    
    dc.fill = Graf.Fill.color(0, 0, 1)
    Graf.ellipse(Double(v.width / 2), Double(v.height / 2), 100, 50).draw(dc)
    
    dc.strokeColor = Graf.Color(0, 1, 0, 0.5)
    for x in 0 ..< dc.width
    {
      Graf.QuickDraw(dc).vline(Int32(x), 0, length: v.height)
    }
    
    for _ in 0 ..< 100
    {
      let gx = Int32.random(in: x - 50 ... x + 50)
      let gy = Int32.random(in: y - 50 ... y + 50)
      dc.setPixel(gx, gy, Graf.Color(0, 1, 0, 0.5))
    }
  }
  
  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mousePressed(let mx, let my, let button) :
        print("button \(button)")
        x = Int32(mx)
        y = Int32(my)
      
      default: break
    }
  }
  Graf.startRunloop()
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
    
    dc.fill = Graf.Fill.color(0.2, 0.3, 0.6)
    //Graf.Text(200, 400, "Helloworld").draw(dc)
  }
  
  Graf.startRunloop()
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
  
  let image = Graf.Image("./media/chessboard.png", enlargeCanvas: false)
  

  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    dc.fill = Graf.Fill.color(0, 0.8, 0, 0.5)
    
    cross.rotate(angle).moveTo(x, y).draw(dc)
    
    
    l.rotate(angle).draw(dc)
    r.rotate(angle).draw(dc)
   
    
    if let _ = l.overlapWith(cross)
    {
      cross.boundary.draw(dc, fill: false)
      l.boundary.draw(dc, fill: false)
    }
    
    image.moveTo(x, y).draw(dc)
    image.boundary.draw(dc, fill: false)
  }

  v.onInputEvent
  {
    evt in
    
    switch evt
    {
      case let .keyPressed(code) :
        print("keycode \(code)")
      case .keyReleased(let code) where code == 44 :
        Graf.stopRunloop()
      case let .mouseMoved(mx, my) :
        x = Double(mx)
        y = Double(my)
 
      case let .mousePressed(_ , _, button) :
        print("button \(button)")
        cross.shear(1, 0)
      
      case let .mouseWheel(dx, dy) :
        print("wheel \(dx) \(dy)")
        image.rotate(0.1 * (dy >= 0 ? 1 : -1))
      
      default:
        break
    }
  }
  
  Graf.startRunloop()
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
  let tex = Graf.Image("./media/chessboard.png", enlargeCanvas: false)
  let imgFill = Graf.Fill(tex)
  
  v.draw
  {
    dc in
    
    dc.clear()
    dc.strokeColor = Graf.Color.black
    poly[2].rotate(angle).draw(dc)
    tex.rotate(angle)
    for s in poly
    {
      if s.contains((x, y))
      {
        dc.fill = imgFill
      }
      else
      {
        dc.fill = Graf.Fill.colorGreen
      }
      s.draw(dc)
    }
    
    ///tex.moveTo(x, y)
    ///tex.draw(dc)
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
  Graf.startRunloop()
}

func demoPong()
{
  Graf.initialize()
  let barWidth = 20.0
  let view = Graf.newView("Pong", 800, 480)
  let topBar = Graf.rect(0, 0, Double(view.width), barWidth)
  let bottomBar = Graf.rect(0, Double(view.height) - barWidth,  Double(view.width), barWidth)
  let leftBar = Graf.rect(0, barWidth, barWidth, Double(view.height) - barWidth)
  let rightPaddle = Graf.rect(Double(view.width - 50), 100, barWidth, 150)
  let ball = Graf.circle(Double(view.width / 2), Double(view.height / 2), 25, step: 0.1)
  var vel = Vector3e(Double.random(in: 3 ... 9), Double.random(in: 3 ... 9), 1)
  
  func moveAwayFrom(_ p: Graf.Polygon, _ reflectRay: Vector3e)
  {
    while nil != ball.overlapWith(p)
    {
      ball.translate(reflectRay.x, reflectRay.y)
      //print("moving away \(reflectRay)")
    }
  }
  
  view.draw
  {
    dc in
    
    dc.clear()
    dc.fill = Graf.Fill.colorBlack
    topBar.draw(dc)
    bottomBar.draw(dc)
    leftBar.draw(dc)
    dc.fill = Graf.Fill.colorBlue
    rightPaddle.draw(dc)
    dc.fill = Graf.Fill.colorRed
    ball.draw(dc)
    let bc = ball.center
    Graf.vectorLine(bc.x, bc.y, 6 * vel).draw(dc)
    ball.translate(vel.x, vel.y)
    
    var hit = false
    
    if let _ = ball.overlapWith(topBar)
    {
      vel = topBar.edge(2)!.reflectRay(vector: vel).0
      moveAwayFrom(topBar, vel)
      hit = true
    }
    else if let _ = ball.overlapWith(bottomBar)
    {
      vel = bottomBar.edge(0)!.reflectRay(vector: vel).0
      moveAwayFrom(bottomBar, vel)
      hit = true
    }
    else if let _ = ball.overlapWith(leftBar)
    {
      vel = leftBar.edge(1)!.reflectRay(vector: vel).0
      moveAwayFrom(leftBar, vel)
      hit = true
    }
    else if let _ = ball.overlapWith(rightPaddle)
    {
      vel = rightPaddle.edge(3)!.reflectRay(vector: vel).0
      moveAwayFrom(rightPaddle, vel)
      hit = true
    }
    
    if hit
    {
      vel = vel * Double.random(in: 5 ... 9)
      print(vel)
      Graf.playAudio(fileName: "./media/beep.mp3")
    }
    
      
    if(!dc.viewRect.contains(ball.center))
    {
      dc.fill = Graf.Fill.color(0, 0, 0)
      //Graf.Text(Double(dc.width / 2), Double(dc.height / 2), "GAME OVER!").draw(dc)
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
  
  Graf.startRunloop()
}

func pid()
{
  Graf.initialize()
  let view = Graf.newView("PID", 600, 400)
  let target = Graf.Object(Graf.rect(200, 200, 50, 130))
  let oval = Graf.Object(Graf.ellipse(400, 200, 40, 120, step: 0.1))
  
  let text = Graf.Text("HelloWorld")
  
  let pidX = CommonSwift.Math.PID(setPoint: target.location.x,
                                  kP: 0.003, kI: 0.005, kD: 0.003,
                                  outputLimit: -180 ... 180)
  let pidY = CommonSwift.Math.PID(setPoint: target.location.y,
                                  kP: 0.003, kI: 0.005, kD: 0.003,
                                  outputLimit: -180 ... 180)
  
  let pidA = CommonSwift.Math.PID(setPoint: target.angle,
                                  kP: 0.003, kI: 0.005, kD: 0.003,
                                  outputLimit: -180 ... 180)
  
  let pidS = CommonSwift.Math.PID(setPoint: target.size,
                                  kP: 0.003, kI: 0.005, kD: 0.003,
                                  outputLimit: -180 ... 180)
  
  let pids = Math.PIDArray([pidX, pidY, pidA, pidS])

  
  view.draw
  {
    dc in
    
    dc.clear()
    
    let deltas = pids.step(inputs:[oval.location.x,
                                   oval.location.y,
                                   oval.angle,
                                   oval.size])
    dc.fill = Graf.Fill.color(1, 0, 0, 0.5)
    target.draw(dc)
    
    oval.location = oval.location + Vector3e(deltas[0], deltas[1], 1)
    oval.angle = oval.angle + deltas[2]
    oval.size = oval.size + deltas[3]
      
    dc.fill = Graf.Fill.color(0, 1, 0, 0.5)
    oval.draw(dc)
    
    let (mx, my) = Graf.mouseLocation
    
    text.moveTo(Double(mx), Double(my)).draw(dc)

    
    //print(target.angle * deg, oval.angle * deg)
    
  }
  
  func resize(_ code: UInt32)
  {
    print(code)
    
    switch code
    {
      case 82: target.size = target.size + 0.05
      case 81: target.size = target.size - 0.05

      default: break
    }
    
    pids.updateSetPoint(newSetPoints: [target.location.x,
                                       target.location.y,
                                       target.angle,
                                       target.size])
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case let .keyPressed(keyCode: code) :
        resize(code)
      case let .mouseMoved(mouseX: mx, mouseY: my) :
        target.location = Vector3e(Double(mx), Double(my), 1)
        pids.updateSetPoint(newSetPoints: [Double(mx), Double(my), target.angle, target.size])
      
      case .mouseWheel(_ , let dy):
        target.angle = (target.angle + (0.1 * (dy > 0 ? 1 : -1))).clamped(to: 0 ... 2 * Double.pi)
        //target.size = (target.size + (0.01 * (dx > 0 ? 1 : -1)))
        pids.updateSetPoint(newSetPoints: [target.location.x,
                                           target.location.y,
                                           target.angle,
                                           target.size])
      
      default: break
    }
  }
  
  
  
  Graf.startRunloop()
}


// old school drawing
func nonInteractive()
{
  Graf.initialize()
  
  let t = Graf.Text("Helloworld And Mooen")
  let v = Graf.newView("noRunloop", 640, 480, retain: true)
  
  v.draw
  {
    dc in
    dc.clear()
    Graf.line(0, 0, 640, 480).draw(dc)
    Graf.ellipse(320, 240, 100, 200).draw(dc)
    dc.fill = Graf.Fill.color(1, 0, 0, 1)
    t.moveTo(100, 100).draw(dc)
  }
  
  
  if let s = readLine()
  {
    print (s)
  }
  
  v.draw
  {
    dc in
    dc.fill = Graf.Fill.color(0, 0, 0.6)
    Graf.circle(160, 120, 50).draw(dc)
  }
  
  if let s = readLine()
  {
    print (s)
  }
}


func testText()
{
  Graf.initialize()
  
  let t = Graf.Text("Helloworld And Moon")
  let v = Graf.newView("noRunloop", 640, 480)
  
  v.draw
  {
    dc in
    dc.clear()
    Graf.line(0, 0, 640, 480).draw(dc)
    Graf.ellipse(320, 240, 100, 200).draw(dc)
    dc.fill = Graf.Fill.color(1, 0, 0, 1)
    
    let (mx, my) = Graf.mouseLocation
    
    t.moveTo(Double(mx), Double(my)).rotate(0.01).draw(dc)
    t.boundary.draw(dc, fill: false)
  }
  
  Graf.startRunloop()
}



