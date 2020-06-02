import Foundation
import Graf

func animation101()
{
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
}

