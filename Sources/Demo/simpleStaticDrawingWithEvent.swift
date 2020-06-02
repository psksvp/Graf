import Foundation
import Graf


func simpleStaticWithEvent()
{
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
}
