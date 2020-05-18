//
//  File.swift
//  
//
//  Created by psksvp on 18/5/20.
//

import Foundation

//class ASM
//{
//  class State<T>
//  {
//    let name:String
//    private var history:[T] = []
//    
//    var value: T
//    {
//      willSet
//      {
//        history.append(newValue)
//      }
//    }
//    
//    init(_ n: String, _ v: T)
//    {
//      name = n
//      value = v
//    }
//    
//    func history(_ i: Int) -> T?
//    {
//      return self.history[i]
//    }
//  }
//  
//  
//  enum TurtleInstructionSet
//  {
//    case Forward(distance: Double)
//    case Backward(distance: Double)
//    case Heading(angle: Double)
//    case Console(text: String)
//    case PenUp
//    case PenDown
//    case Exit(code: Int)
//    case Jump(address: Int)
//  }
//  
//  class Machine
//  {
//    let heading = State<Double>("Heading", 0)
//    let pen: State<Bool>("pen", true)
//    let location: State<(Double, Double)("location", (0.0, 0.0))
//    
//    func execute(_ insrt: [TurtleInstructionSet])
//    {
//      switch
//    }
//  }
//  
//  
//}
