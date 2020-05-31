//
//  Graf+Polygon+Draw.swift
//  
//
//  Created by psksvp on 29/4/20.
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
import CCairo
import CommonSwift

extension Graf.Polygon 
{
  public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
  {
    func buildPath()
    {
      guard self.vertices.count > 0 else {return}
      
      let sp = vertices.first!
      cairo_move_to(dc.context.cr, sp.x, sp.y)
      for p in vertices.dropFirst(1)
      {
        cairo_line_to(dc.context.cr, p.x, p.y)
      }
      cairo_close_path(dc.context.cr)
    }
    
    func doStroke()
    {
      buildPath()
      dc.context.stroke(dc.strokeColor)
    }
    
    func doFill()
    {
      if vertices.count <= 2
      {
        doStroke()
      }
      else
      {
        buildPath()
        dc.context.fill(dc.fill.cPattern)
      }
    }
    
    func doStrokeAndFill()
    {
      buildPath()
      dc.context.stroke(dc.strokeColor, preserved: true)
      dc.context.fill(dc.fill.cPattern)
    }
    
    switch (stroke, fill)
    {
      case (true, true)  : doStrokeAndFill()
      case (true, false) : doStroke()
      case (false, true) : doFill()
      case (false, false): Log.warn("draw without stroke and fill")
    }
    
  }
}
