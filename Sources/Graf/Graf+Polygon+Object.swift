//
//  Graf+Polygon+Object.swift
//  
//
//  Created by psksvp on 15/5/20.
//
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

extension Graf
{
  public class Object : Drawable
  {
    public var size: Double = 1
    {
      willSet
      {
        if newValue != size
        {
          let s = 1.0 + (newValue - size)
          polygon.scale(s, s)
        }
      }
    }
    
    public var angle: Double = 0
    {
      willSet
      {
        if newValue != angle
        {
          let delta = angle - newValue
          polygon.rotate(delta)
        }
      }
    }
    
    public var location: Vector3e
    {
      get
      {
        polygon.center
      }
      
      set
      {
        polygon.moveTo(newValue.x, newValue.y)
      }
    }
    
    private let polygon: Graf.Polygon
    
    public init(_ p: Polygon)
    {
      self.polygon = p
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      polygon.draw(dc, stroke: stroke, fill: fill)
    }
  }
}
