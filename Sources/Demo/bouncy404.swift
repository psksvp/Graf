//
//  bouncy404.swift
//  
//
//  Created by psksvp on 23/5/20.
//

import Foundation
import Graf

func bouncy404()
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
      shape.translate(self.velocity.x,
                      self.velocity.y).rotate(self.rotationRate).draw(dc, stroke: false)
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
          a.velocity = Double.random(in: 1.5 ... 4.0) * v
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
          a.velocity = Double.random(in: 1.5 ... 3.0) * v
          a.rotationRate = -a.rotationRate
          w.velocity = Double.random(in: 1.5 ... 3.0) * u
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
