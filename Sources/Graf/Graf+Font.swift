//
//  Graf+Font.swift
//  
//
//  Created by psksvp on 20/5/20.
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
  public struct  Font
  {
    public enum Slant
    {
      case normal
      case italic
      case oblique
      
      func toCairo() -> cairo_font_slant_t
      {
        let lookup = [Slant.normal : CAIRO_FONT_SLANT_NORMAL,
                      Slant.italic : CAIRO_FONT_SLANT_ITALIC,
                      Slant.oblique : CAIRO_FONT_SLANT_OBLIQUE]
        
        if let r = lookup[self]
        {
          return r
        }
        else
        {
          Log.error("Code should never reached here")
          return CAIRO_FONT_SLANT_NORMAL
        }
      }
    }
    
    public enum Weight
    {
      case normal
      case bold
      
      func toCairo() -> cairo_font_weight_t
      {
        switch self
        {
          case .normal : return CAIRO_FONT_WEIGHT_NORMAL
          case .bold   : return CAIRO_FONT_WEIGHT_BOLD
        }
      }
    }
    
    let name: String
    let size: UInt32
    let slant: Slant
    let weight: Weight
    
    public init(name: String, size: UInt32, slant: Slant = .normal,
                                            weight: Weight = .normal)
    {
      self.name = name
      self.size = size
      self.slant = slant
      self.weight = weight
    }
    
    func setToCairoContext(_ c: Cairo.Context)
    {
      cairo_set_font_size(c.cr, Double(self.size))
      cairo_select_font_face(c.cr, self.name, self.slant.toCairo(),
                                              self.weight.toCairo())
    }
  }
}
