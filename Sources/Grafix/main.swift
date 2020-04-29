print("Hello, world!")

let graf = Graf.shared()

let v0 = graf.newView(name: "HelloWorld0", size: Graf.Size(width: 640, height: 600))
var x:Double = 0
var y:Double = 50

//let locText = Graf.Text(320, 100, "")
let cross = Graf.Ellipse(320, 300, 30, 60)
var angle = 0.0
var sx = 1.0
var sy = 1.0
v0.draw
{
  dc in
  
  dc.clear()
  dc.strokeColor = Graf.Color.black
  dc.fillColor = Graf.Color(0, 0.8, 0, 0.5)
  
  //cross.rotate(angle).moveTo(x, y).draw(dc)
  
  cross.moveTo(x, y).scale(sx, sy).draw(dc)
  
  
//  dc.rect(10, 10, 400, 200).stroke()
//  dc.arc(320, 300, 100, 40, 0, Double.pi).fill()
//
//  dc.ellipse(x, y, 200, 100).strokeAndFill()
//  dc.fillColor = Graf.Color(0.9, 0.8, 0, 0.5)
//  dc.ellipse(x, y, 100, 200).strokeAndFill()
//
//
//  //dc.line(dc.width, 0, x, y).stroke()
//  //dc.line(dc.width, dc.height, x, y).stroke()
//
  
//  dc.text(400, 100, "HelloWorld")
//
//  //dc.rect(10, 10, 400, 200).fill()
//  dc.strokeWeight = 5
//  dc.fillColor = Graf.Color(0.8, 0.3, 0.8)
//  dc.arc(320, 400, 100, 100, 0, Double.pi / 2).strokeAndFill()
//
//  Graf.Circle(x, y, 25).draw(dc)
//  Graf.Line(x, 0, x, dc.height).draw(dc)
//  Graf.Line(0, y, dc.width, y).draw(dc)
//
//  dc.fillColor = Graf.Color(0.3, 0.8, 0.3)
//  dc.fontSize = 20
//  dc.fontFace = "Papyrus"
//  //Graf.Text(320, 100, "\(x) , \(y)").draw(dc)
//  locText.text = "\(x) , \(y)"
//  locText.coord = (x, y)
//  locText.draw(dc)
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
    
    case .mouseWheel(let dx, let dy) :
      print("wheel \(dx) \(dy)")
      sx = sx + Double(dx) / 100.0
      sy = sy + Double(dy) / 100.0
//      angle = angle + (Double(dy) / 10.0)
//      if angle > 360.0
//      {
//        angle = 360.0
//      }
    
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



