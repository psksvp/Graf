//
//  Graf+DirectDraw.swift
//  
//
//  Created by psksvp on 10/5/20.
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
import SDL2

extension Graf
{
  public class DirectDraw
  {
    private let dc:DrawingContext
  
    public init(_ dc: DrawingContext)
    {
      self.dc = dc
    }
    
    public func vline(_ x: Int32, _ y: Int32, length: UInt32)
    {
      var cy = y
      while cy - y != length
      {
        dc.setPixel(x, cy, dc.strokeColor)
        cy = cy + 1
      }
    }
    
    public func hline(_ x: Int32, _ y: Int32, length: UInt32)
    {
      var cx = x
      while cx - x != length
      {
        dc.setPixel(cx, y, dc.strokeColor)
        cx = cx + 1
      }
    }
    
    public func rect(_ x: Int32, _ y: Int32, _ w: Int32, _ h: Int32)
    {
      hline(x, y, length: UInt32(w))
      hline(x, y + h, length: UInt32(w))
      vline(x, y, length: UInt32(h))
      vline(x + w, y, length:UInt32(h))
    }

    // wikipedia line drawing algorithm
    public func line(_ x0: Int32, _ y0: Int32, _ x1: Int32, _ y1: Int32)
    {
      let dx = abs(x1 - x0)
      let sx = Int32(x0 < x1 ? 1 : -1)
      let dy = -abs(y1 - y0)
      let sy = Int32(y0 < y1 ? 1 : -1)
      var err = dx + dy;  /* error value e_xy */
      var xc = x0
      var yc = y0
      while (true)   /* loop */
      {
        dc.setPixel(xc, yc, dc.strokeColor)
        if xc == x1 && yc == y1
        {
          break
        }
        let e2 = 2 * err
        if e2 >= dy /* e_xy+e_x > 0 */
        {
          err = err +  dy
          xc  = xc + sx
        }
        if e2 <= dx /* e_xy+e_y < 0 */
        {
          err = err + dx
          yc = yc + sy
        }
      } //while
    }
    
  }
}
