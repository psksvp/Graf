import Foundation
import Graf


func randomShapes()
{
  let view = Graf.newView("Hello Graf", 320, 240, retain: true)
  
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
      case 2: Graf.ellipse(x, y, w, h, step: Double.random(in: 0.01 ... 0.08)).draw(dc)
      case 3: Graf.circle(x, y, w, step: Double.random(in: 0.01 ... 0.08)).draw(dc)
      default: break
    }
    
  }
}

