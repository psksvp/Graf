print("Hello, world!")

let graf = Graf.shared()

let v0 = graf.newView(name: "HelloWorld0", size: Graf.Size(width: 640, height: 600))
var x:Double = 0
var y:Double = 50

//let locText = Graf.Text(320, 100, "")
let cross = Graf.ellipse(320, 300, 100, 160, step: 0.8)
let l = Graf.line(320, 200, 320, 400)
var angle = 0.05
var sx = 1.0
var sy = 1.0
v0.draw
{
  dc in
  
  dc.clear()
  dc.strokeColor = Graf.Color.black
  dc.fillColor = Graf.Color(0, 0.8, 0, 0.5)
  
  cross.rotate(angle).moveTo(x, y).draw(dc)
  cross.boundary.draw(dc, fill: false)
  
  l.rotate(angle).draw(dc)
  
  
}

v0.onInputEvent
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
      cross.shear(1, 0)
    
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



