//
//  Graf+Fill.swift
//  
//
//  Created by psksvp on 9/5/20.
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

extension Graf
{
  public class Fill
  {
    let cPattern: Cairo.Pattern
    
    public init(_ c: Graf.Color)
    {
      cPattern = Cairo.Pattern(c)
    }
    
    private init(_ s: Cairo.Surface)
    {
      cPattern = Cairo.Pattern(s)
    }
    
    public init(_ s: Graf.Image)
    {
      cPattern = Cairo.Pattern(s.surface)
    }
    
    public init(_ x0: Double,
                _ y0: Double,
                _ x1: Double,
                _ y1: Double)
    {
      cPattern = Cairo.Pattern(x0, y1, x1, y1)
    }
    
    public class func color(_ c: Graf.Color) -> Fill
    {
      return Fill(c)
    }
    
    public class func image(_ f: String) -> Fill
    {
      return Fill(Cairo.PNGSurface(f))
    }
    
    public class func color(_ r: Double,
                            _ g: Double,
                            _ b: Double,
                            _ a: Double = 1.0) -> Fill
    {
      return color(Graf.Color(r, g, b, a))
    }
    
    public static var colorBlack = Fill.color(0, 0, 0)
    public static var colorWhite = Fill.color(1, 1, 1)
    public static var colorRed = Fill.color(1, 0, 0)
    public static var colorGreen = Fill.color(0, 1, 0)
    public static var colorBlue = Fill.color(0, 0, 1)
    
    public class func linearGradient(_ x0: Double,
                                     _ y0: Double,
                                     _ x1: Double,
                                     _ y1: Double,
                                     stopColors: [Color]) -> Fill
    {
      let f = Fill(x0, y0, x1, y1)
      var offset: Double = 0
      let interval = 1.0 / Double(stopColors.count)
      for c in stopColors
      {
        cairo_pattern_add_color_stop_rgba(f.cPattern.cpattern,
                                          offset,
                                          c.redChannel,
                                          c.greenChannel,
                                          c.blueChannel,
                                          c.alphaChannel)
        offset = offset + interval
      }
      return f
    }
    
  }
}
