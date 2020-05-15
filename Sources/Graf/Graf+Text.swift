//
//  Graf+Text.swift
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

extension Graf
{
  public class Text : Drawable
  {
    var text: String = ""
    var coord: (Double, Double) = (0.0, 0.0)
    var alignCenter: Bool = true
    
    public init(_ x: Double, _ y: Double, _ s: String, centerAtCoord: Bool = true)
    {
      text = s
      coord = (x, y)
      alignCenter = centerAtCoord
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      dc.fill.cPattern.setAsSourceInContext(dc.context)
      
      if(alignCenter)
      {
        let (w, h) = extend(dc)
        let (x, y) = (coord.0 + w / 2, coord.1 + h / 2)
        cairo_move_to(dc.context.cr, x, y)
      }
      else
      {
        cairo_move_to(dc.context.cr, coord.0, coord.1)
      }
      cairo_move_to(dc.context.cr, coord.0, coord.1)
      cairo_show_text(dc.context.cr, text)
    }
    
    public func extend(_ dc: DrawingContext) -> (Double, Double)
    {
      var ex = cairo_text_extents_t()
      
      cairo_text_extents(dc.context.cr, text, &ex)
      return (ex.width, ex.height)
    }
  }
}
