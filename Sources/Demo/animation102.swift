import Foundation
import Graf

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
