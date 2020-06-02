import Foundation
import Graf

func animation103()
{
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
}
