//
//  Demo.swift
//  
//
//  Created by psksvp on 23/5/20.
//

import Foundation
import Graf

func animation101()
{
  Graf.initialize()
  let view = Graf.newView("Hello Graf", 640, 480)
  
  var x = 0.0
  let y = Double(view.height) / 2
  
  view.draw
  {
    dc in
    
    dc.clear()
    Graf.ellipse(x, y, 200, 100).draw(dc)
    
    x = x + 1
  }
  
  Graf.startRunloop()
}

func animation102()
{
  Graf.initialize()
  let view = Graf.newView("Hello Graf", 640, 480)
  
  var x = 0.0
  var y = Double(view.height) / 2
  
  view.draw
  {
    dc in
    
    dc.clear()
    Graf.ellipse(x, y, 200, 100).draw(dc)
    
    x = x + 1
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case let .mousePressed(mouseX: mx, mouseY: my, button: _) :
        x = Double(mx)
        y = Double(my)
      
      default: break
    }
  }
  Graf.startRunloop()
}

func animation103()
{
  Graf.initialize()
  let view = Graf.newView("Hello Graf", 640, 480)
  
  var x = Double(view.width) / 2
  var y = Double(view.height) / 2
  var vx = Double.random(in: 1 ... 5)
  var vy = Double.random(in: 1 ... 5)
  let r = 50.0
  
  view.draw
  {
    dc in
    
    dc.clear()
    Graf.circle(x, y, r).draw(dc)
    
    x = x + vx
    y = y + vy
    
    if x + r >= Double(dc.width)
    {
      vx = -vx
      x = Double(dc.width) - r
    }
    
    if x - r <= 0
    {
      vx = -vx
      x = 0 + r
    }
    
    if y + r >= Double(dc.height)
    {
      vy = -vy
      y = Double(dc.height) - r
    }
    
    if y - r <= 0
    {
      vy = -vy 
      y = 0 + r
    }
  }
  
  Graf.startRunloop()
}

func simpleStaticWithEvent()
{
  Graf.initialize()
  let view = Graf.newView("Hello Graf", 640, 480, retain: true)
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .mousePressed(let mx, let my, _) :
        view.draw
        {
          dc in
          
          dc.fill = Graf.Fill(Graf.Color.random)
          Graf.circle(Double(mx),
                      Double(my),
                      Double.random(in: 5 ... 50)).draw(dc)
        }
      
      default : break
    }
  }
  
  Graf.startRunloop()
}

func randomShapes()
{
  Graf.initialize()
  
  let view = Graf.newView("Hello Graf", 800, 600, retain: true)
  
  view.draw
  {
    dc in
    let x = Double.random(in: 0 ... Double(view.width))
    let y = Double.random(in: 0 ... Double(view.width))
    let w = Double.random(in: 10 ... 100)
    let h = Double.random(in: 10 ... 100)
    
    dc.fill = Graf.Fill(Graf.Color.random)
    dc.strokeColor = Graf.Color.random
    switch Int.random(in: 0 ... 3)
    {
      case 0: Graf.rect(x, y, w, h).draw(dc)
      case 1: Graf.arc(x, y, w, h, startAngle: 0, endAngle: Double.random(in: 0 ... 2 * Double.pi)).draw(dc)
      case 2: Graf.ellipse(x, y, w, h).draw(dc)
      case 3: Graf.circle(x, y, w).draw(dc)
      default: break
    }
    
  }
  
  Graf.startRunloop()
}
