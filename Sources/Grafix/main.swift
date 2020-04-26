print("Hello, world!")

let graf = Graf.shared()

let v0 = graf.newView(name: "HelloWorld0", size: Graf.Size(width: 640, height: 600))
var x:Double = 0
var y:Double = 50

v0.draw
{
  dc in
  dc.clear()
  
  
  dc.strokeColor = Graf.Color(0, 0, 0)
  dc.fillColor = Graf.Color(0, 0.8, 0, 0.5)
  
  dc.ellipse(x, y, 200, 100).strokeAndFill()
  dc.fillColor = Graf.Color(0.9, 0.8, 0, 0.5)
  dc.ellipse(x, y, 100, 200).strokeAndFill()
  
  dc.circle(x, y, 25).fill()
  dc.strokeColor = Graf.Color(0.2, 0.5, 0)
  dc.line(0, 0, x, y).stroke()
  dc.line(0, dc.height, x, y).stroke()
  dc.line(dc.width, 0, x, y).stroke()
  dc.line(dc.width, dc.height, x, y).stroke()

}

v0.onEvent
{
  evt in
  
  switch evt
  {
    case .keyPressed(let code) :
      print("keycode \(code)")
    case .keyReleased(let code) where code == 44 :
      graf.quit()
    case .mouseMoved(let mx, let my) :
      x = Double(mx)
      y = Double(my)

    case .mousePressed(_ , _, let button) :
      print("button \(button)")
    
    case .mouseWheel(let dx, let dy) :
      print("wheel \(dx) \(dy)")
    
    default:
      break
  }
  
}


//let v1 = graf.newView(name: "HelloWorld1", size: Graf.Size(width: 640, height: 200))
//v1.draw
//{
//  dc in
//  dc.test()
//}

graf.run()



