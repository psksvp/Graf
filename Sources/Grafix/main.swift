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
  
  dc.ellipse(x, y, 200, 100)
  dc.fillColor = Graf.Color(0.6, 0.8, 0, 0.5)
  dc.ellipse(x, y, 100, 200)
  
  dc.arc(x, y, 25, 0, 2 * Double.pi)
  dc.strokeColor = Graf.Color(1, 0, 0)
  dc.line(0, 0, x, y)
  dc.line(0, dc.height, x, y)
  dc.line(dc.width, 0, x, y)
  dc.line(dc.width, dc.height, x, y)

  
  
  
  
//  dc.strokeColor = Graf.Color(0, 0, 0)
//  dc.fillColor = Graf.Color.transparent
//  dc.ellipse(100, 100, 50, 20)
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



/*
 // C++ program for implementing
 // Mid-Point Ellipse Drawing Algorithm
 #include <bits/stdc++.h>
 using namespace std;

 void midptellipse(int rx, int ry,
         int xc, int yc)
 {
   float dx, dy, d1, d2, x, y;
   x = 0;
   y = ry;

   // Initial decision parameter of region 1
   d1 = (ry * ry) - (rx * rx * ry) +
           (0.25 * rx * rx);
   dx = 2 * ry * ry * x;
   dy = 2 * rx * rx * y;

   // For region 1
   while (dx < dy)
   {

     // Print points based on 4-way symmetry
     cout << x + xc << " , " << y + yc << endl;
     cout << -x + xc << " , " << y + yc << endl;
     cout << x + xc << " , " << -y + yc << endl;
     cout << -x + xc << " , " << -y + yc << endl;

     // Checking and updating value of
     // decision parameter based on algorithm
     if (d1 < 0)
     {
       x++;
       dx = dx + (2 * ry * ry);
       d1 = d1 + dx + (ry * ry);
     }
     else
     {
       x++;
       y--;
       dx = dx + (2 * ry * ry);
       dy = dy - (2 * rx * rx);
       d1 = d1 + dx - dy + (ry * ry);
     }
   }

   // Decision parameter of region 2
   d2 = ((ry * ry) * ((x + 0.5) * (x + 0.5))) +
     ((rx * rx) * ((y - 1) * (y - 1))) -
     (rx * rx * ry * ry);

   // Plotting points of region 2
   while (y >= 0)
   {

     // Print points based on 4-way symmetry
     cout << x + xc << " , " << y + yc << endl;
     cout << -x + xc << " , " << y + yc << endl;
     cout << x + xc << " , " << -y + yc << endl;
     cout << -x + xc << " , " << -y + yc << endl;

     // Checking and updating parameter
     // value based on algorithm
     if (d2 > 0)
     {
       y--;
       dy = dy - (2 * rx * rx);
       d2 = d2 + (rx * rx) - dy;
     }
     else
     {
       y--;
       x++;
       dx = dx + (2 * ry * ry);
       dy = dy - (2 * rx * rx);
       d2 = d2 + dx - dy + (rx * rx);
     }
   }
 }

 // Driver code
 int main()
 {
   // To draw a ellipse of major and
   // minor radius 15, 10 centred at (50, 50)
   midptellipse(10, 15, 50, 50);

   return 0;
 }

 // This code is contributed
 // by Akanksha Rai


 */
