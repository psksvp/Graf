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

func Bouncy()
{
  class Drifter
  {
    let shape: Graf.Shape
    var velocity: Vector3e
    var rotationRate: Double
    
    init(_ s: Graf.Shape, velocity v: Vector3e = Vector3e.random(in: -5 ... 5),
                      rotationRate r: Double = Double.random(in: 0.01 ... 0.05))
    {
      self.shape = s
      self.velocity = v
      self.rotationRate = r
    }
    
    func drift(_ dc: Graf.DrawingContext)
    {
      shape.translate(self.velocity.x, self.velocity.y).rotate(self.rotationRate).draw(dc, stroke: false)
      let c = shape.boundary.center
      dc.strokeColor = Graf.Color.green
      Graf.vectorLine(c.x, c.y, velocity * 10).draw(dc)
    }
  }
  
  Graf.initialize()
  var intersectedEdges:[Graf.Edge] = []
  let view = Graf.newView("Bouncy", 640, 480)
  let w = Double(view.width)
  let h = Double(view.height)
  let thick = 10.0
  let wood = Graf.Fill.image("./media/wood.png")

  let walls = [Graf.Shape(Graf.rect(0, 0, w, thick), texture: wood),
               Graf.Shape(Graf.rect(0, 0, thick, h), texture: wood),
               Graf.Shape(Graf.rect(0, h - thick, w, thick), texture: wood),
               Graf.Shape(Graf.rect(w - thick, 0, thick, h), texture: wood)]
  
  let rect = Graf.Shape(Graf.rect(w / 2,  h / 2, 25, 80), texture: Graf.Fill.image("./media/brick.png"))
  let triangle = Graf.Shape(Graf.triangle(100, 100, 150, 100, 150, 150),
                        texture: Graf.Fill.image("./media/brick.png"))
  let ellipse = Graf.Shape(Graf.ellipse(200, 200, 70, 40, step: 0.4),
                           texture: Graf.Fill.image("./media/chessboard.png"))
  
  let difters = [Drifter(rect), Drifter(triangle), Drifter(ellipse)]
  
  
  func wallCollider()
  {
    for a in difters
    {
      for w in walls
      {
        if let (aEdge, wEdge) = Graf.intersected(a.shape.boundary, w.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          while nil != Graf.intersected(a.shape.boundary, w.boundary)
          {
            a.shape.translate(v.x, v.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 4.0)
          a.rotationRate = -a.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
          return
        }
      }
    }
  }
  
  func diftersCollider()
  {
    for i in 0 ..< difters.count
    {
      for j in i + 1 ..< difters.count
      {
        let a = difters[i]
        let w = difters[j]
        if let (aEdge, wEdge) = Graf.intersected(a.shape.boundary, w.shape.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          let u = aEdge.reflectRay(vector: w.velocity).0
          while nil != Graf.intersected(a.shape.boundary, w.shape.boundary)
          {
            a.shape.translate(v.x, v.y)
            w.shape.translate(u.x, u.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 3.0)
          a.rotationRate = -a.rotationRate
          w.velocity = u * Double.random(in: 1.5 ... 3.0)
          w.rotationRate = -w.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
          return
        }
      }
    }
  }
  
  func boundChecker(_ a: Graf.Shape)
  {
    let c = a.boundary.center
    if c.x <= 0 || c.x >= w || c.y <= 0 || c.y >= h
    {
      a.moveTo(w / 2, h / 2)
    }
  }
  
  view.draw
  {
    dc in
    //dc.clear()
    
    for w in walls
    {
      w.draw(dc, stroke: false)
    }
    
    for b in difters
    {
      b.drift(dc)
    }
    
    diftersCollider()
    wallCollider()
    
    for e in intersectedEdges
    {
      dc.strokeColor = Graf.Color.random
      dc.strokeWeight = 20
      e.draw(dc)
    }
    intersectedEdges.removeAll(keepingCapacity: true)
    dc.strokeColor = Graf.Color.black
    dc.strokeWeight = 1
    
    for b in difters
    {
      boundChecker(b.shape)
    }
  }
  
  Graf.startRunloop()

}
