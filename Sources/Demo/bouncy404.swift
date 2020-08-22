//
//  bouncy404.swift
//  
//
//  Created by psksvp on 23/5/20.
//

import Foundation
import Graf

#if os(Linux)
import SGLMath
#endif

func bouncy404()
{
  class Drifter
  {
    let movable: Graf.Geometry
    var velocity: Vector3e
    var rotationRate: Double
    
    init(_ s: Graf.Geometry, velocity v: Vector3e = Vector3e.random(in: -5 ... 5),
                      rotationRate r: Double = Double.random(in: 0.01 ... 0.05))
    {
      self.movable = s
      self.velocity = v
      self.rotationRate = r
    }
    
    func drift(_ dc: Graf.DrawingContext)
    {
      movable.translate(self.velocity.x,
                      self.velocity.y).rotate(self.rotationRate)
      movable.draw(dc, stroke: false)
      let c = movable.boundary.center
      dc.strokeColor = Graf.Color.green
      dc.fill = Graf.Fill.color(0.3, 0.4, 0.6, 0.5)
      Graf.vectorLine(c.x, c.y, velocity * 20, headDegree: 0.5).draw(dc)
    }
  }
  
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
  
  let text = Graf.Text("Hello Graf", font: Graf.Font(name: "Arial", size: 30))
  text.moveTo(w - 100, h - 100)
  text.color = Graf.Color.blue
  
  let image = Graf.Image("./media/monalisa.png")
  image.moveTo(100, h - 100)
  
  let difters = [Drifter(rect), Drifter(triangle), Drifter(ellipse), Drifter(text), Drifter(image)]
  
  //var timeTotal = 0.0
  //var frameCount = 0
  
  func wallCollider()
  {
    for a in difters
    {
      for w in walls
      {
        if let (aEdge, wEdge) = Graf.intersected(a.movable.boundary, w.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          while nil != Graf.intersected(a.movable.boundary, w.boundary)
          {
            a.movable.translate(v.x, v.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 4.0)
          a.rotationRate = -a.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
        }
      }
    }
  }
  
  func wallColliderPar()
  {
    for a in difters
    {
      //for w in walls
      DispatchQueue.concurrentPerform(iterations: walls.count)
      {
        idx in
        let w = walls[idx]
        if let (aEdge, wEdge) = Graf.intersected(a.movable.boundary, w.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          while nil != Graf.intersected(a.movable.boundary, w.boundary)
          {
            a.movable.translate(v.x, v.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 2.0)
          a.rotationRate = -a.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
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
        if let (aEdge, wEdge) = Graf.intersected(a.movable.boundary, w.movable.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          let u = aEdge.reflectRay(vector: w.velocity).0
          while nil != Graf.intersected(a.movable.boundary, w.movable.boundary)
          {
            a.movable.translate(v.x, v.y)
            w.movable.translate(u.x, u.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 2.0)
          a.rotationRate = -a.rotationRate
          w.velocity = u * Double.random(in: 1.5 ... 2.0)
          w.rotationRate = -w.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
        }
      }
    }
  }
  
  func diftersColliderPar()
  {
    //for i in 0 ..< difters.count
    DispatchQueue.concurrentPerform(iterations: difters.count)
    {
      i in
      let a = difters[i]
      for j in i + 1 ..< difters.count
      {
        
        let w = difters[j]
        if let (aEdge, wEdge) = Graf.intersected(a.movable.boundary, w.movable.boundary)
        {
          let v = wEdge.reflectRay(vector: a.velocity).0
          let u = aEdge.reflectRay(vector: w.velocity).0
          while nil != Graf.intersected(a.movable.boundary, w.movable.boundary)
          {
            a.movable.translate(v.x, v.y)
            w.movable.translate(u.x, u.y)
          }
          a.velocity = v * Double.random(in: 1.5 ... 3.0)
          a.rotationRate = -a.rotationRate
          w.velocity = u * Double.random(in: 1.5 ... 3.0)
          w.rotationRate = -w.rotationRate
          intersectedEdges.append(contentsOf: [aEdge, wEdge])
        }
      }
    }
  }
  
  func boundPolicing(_ a: Graf.Geometry)
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
    
    dc.clear()
    
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
      dc.strokeColor = Graf.Color.red
      dc.strokeWeight = 5
      e.draw(dc)
    }
    intersectedEdges.removeAll(keepingCapacity: true)
    dc.strokeColor = Graf.Color.black
    dc.strokeWeight = 1
    
    for b in difters
    {
      boundPolicing(b.movable)
    }
  }
}
