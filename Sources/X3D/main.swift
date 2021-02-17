import Graf

print("Hello, world!")

class GrafDisplay : Display
{
  private let w: Int
  private let h: Int
  
  var width: Int { w }
  var height: Int { h }
  
  init(_ w: Int, h: Int)
  {
    self.w = w
    self.h = h
  }
  
  func setPixel(_ x: Int, _ y: Int, _ c: Color)
  {
    
  }
  
  func clear(_ c: Color)
  {
    
  }
}
