//
//  Graf+Font.swift
//  
//
//  Created by psksvp on 20/5/20.
//

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
