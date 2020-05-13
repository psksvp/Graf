//
//  Graf+QuickDraw.swift
//  
//
//  Created by psksvp on 10/5/20.
//
/*
*  The BSD 3-Clause License
*  Copyright (c) 2018. by Pongsak Suvanpong (psksvp@gmail.com)
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
import SDL2

extension Graf
{
  public class QuickDraw
  {
    private let dc:DrawingContext
  
    public init(_ dc: DrawingContext)
    {
      self.dc = dc
    }
    
    public func vline(_ x: UInt32, _ y: UInt32, length: UInt32)
    {
      var cy = y
      while cy - y != length
      {
        dc.setPixel(x, cy, dc.strokeColor)
        cy = cy + 1
      }
    }
    
    public func hline(_ x: UInt32, _ y: UInt32, length: UInt32)
    {
      var cx = x
      while cx - x != length
      {
        dc.setPixel(cx, y, dc.strokeColor)
        cx = cx + 1
      }
    }
    
    /*
     plotLine(int x0, int y0, int x1, int y1)
     dx =  abs(x1-x0);
     sx = x0<x1 ? 1 : -1;
     dy = -abs(y1-y0);
     sy = y0<y1 ? 1 : -1;
     err = dx+dy;  /* error value e_xy */
     while (true)   /* loop */
         plot(x0, y0);
         if (x0==x1 && y0==y1) break;
         e2 = 2*err;
         if (e2 >= dy)
             err += dy; /* e_xy+e_x > 0 */
             x0 += sx;
         end if
         if (e2 <= dx) /* e_xy+e_y < 0 */
             err += dx;
             y0 += sy;
         end if
     end while
     */
    
  }
}
