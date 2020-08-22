/*
*  The BSD 3-Clause License
*  Copyright (c) 2020. by Pongsak Suvanpong (psksvp@gmail.com)
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification,
*  are permitted provided that the following conditions are met:
*
*  1. Redistributions of source code must retain the above copyright notice,
*  this list of conditions and the following disclaimer.
*
*  2. Redistributions in binary form must reproduce the above copyright notice,
*  this list of conditions and the following disclaimer in the documentation
*  and/or other materials provided with the distribution.
*
*  3. Neither the name of the copyright holder nor the names of its contributors may
*  be used to endorse or promote products derived from this software without
*  specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
*  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
*  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
*  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
*  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* This information is provided for personal educational purposes only.
*
* The author does not guarantee the accuracy of this information.
*
* By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
*/
import Foundation
import CommonSwift
import Graf

print("Hello, world!")
print(FileManager.default.currentDirectoryPath)

Graf.initialize()

let p = PolarGraph(400, 800)
p.start()


Graf.startRunloop()



class PolarGraph
{
  let width: Double
  let height: Double
  var pen = false
  var leftLength: Double
  var rightLength: Double
  var speed: Double
  
  var headLocation: (Double, Double)
  {
    let x = (width * width + leftLength * leftLength - rightLength * rightLength) / (2 * width)
    let y = sqrt(rightLength * rightLength - (width - x) * (width - x))
    return (x, y)
  }
  
  private var segments = [Graf.Polygon]()
  
  init(_ w: Double, _ h: Double)
  {
    self.width = w
    self.height = h
    self.leftLength = 300
    self.rightLength = 300
    self.speed = 5
  }
  
  func start()
  {
    let view = Graf.newView("Polargraph", UInt32(width), UInt32(height))
    view.draw(draw)
    view.onInputEvent(input)
    reset()
  }
  
  func reset()
  {
    segments.removeAll(keepingCapacity: true)
  }
  
  func draw(_ ctx: Graf.DrawingContext)
  {
    ctx.clear()
    ctx.strokeColor = Graf.Color.black
    for s in segments
    {
      s.draw(ctx)
    }
    
    drawWires(ctx)
    drawHead(ctx)
    drawStatus(ctx)
  }
  
  func input(_ evt: Graf.Event)
  {
    switch evt
    {
      case .keyPressed(225) : leftLength = leftLength - speed
      case .keyPressed(29 ) : leftLength = leftLength + speed
      case .keyPressed(229) : rightLength = rightLength - speed
      case .keyPressed(56 ) : rightLength = rightLength + speed
      case .keyPressed(44 ) : pen = !pen
      case .keyPressed(let code) : print(code)
      default: break
    }
  }
  
  func drawWires(_ ctx: Graf.DrawingContext)
  {
    let (x, y) = headLocation
    ctx.strokeColor = Graf.Color.blue
    Graf.line(0, 0, x, y).draw(ctx)
    ctx.strokeColor = Graf.Color.green
    Graf.line(width, 0, x, y).draw(ctx)
  }
  
  
  func drawHead(_ ctx: Graf.DrawingContext)
  {
    let R = 20.0
    let r = R / 2
  
    let (x, y) = headLocation
    ctx.fill = Graf.Fill(Graf.Color.black)
    Graf.circle(x, y, R).draw(ctx, stroke: false, fill: true)
    ctx.fill = Graf.Fill(Graf.Color.white)
    Graf.circle(x, y, r).draw(ctx, stroke: false, fill: true)
    ctx.strokeColor = Graf.Color.red
    Graf.line(x - r, y, x + r, y).draw(ctx)
    Graf.line(x, y - r, x, y + r).draw(ctx)
  }
  
  func drawStatus(_ ctx:Graf.DrawingContext)
  {
    let (x, y) = headLocation
    let text = Graf.Text("x = \(x), y = \(y), pen = \(pen)")
    text.moveTo(100, height - 20)
    text.draw(ctx)
  }
  
}


