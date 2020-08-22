//
//  File.swift
//  
//
//  Created by psksvp on 13/8/20.
//

import Foundation
import Graf


func PinBall()
{
  let rightArm = Graf.rect(200, 400, 100, 10)
  //let leftArm = Graf.rect(width: 200, height: 50)
  
  let view = Graf.newView("PinBall", 400, 600)
  
  view.draw
  {
    dc in
    
    dc.clear()
    
    rightArm.draw(dc)
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case .keyPressed(keyCode: 44): rightArm.rotate(90)
      case .keyReleased(keyCode: 44): rightArm.rotate(-90)
      default : break
    }
  }
}

