//
//  Graf+Geometry.swift
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
  public class Geometry : Tranformable, Drawable
  {
    let surface: Cairo.BitmapSurface

    private var x: Double = 0
    private var y: Double = 0
    
    public var width: UInt32 {UInt32(surface.width)}
    public var height: UInt32 {UInt32(surface.height)}
    
    public var boundary: Polygon
    {
      return Graf.rect(x, y, surface.width, surface.height)
    }
    
    public var center: Vector3e
    {
      return Vector3e(x - surface.width / 2, y - surface.width / 2, 1)
    }
    
    init(_ w: UInt32, _ h: UInt32)
    {
      self.surface = Cairo.BitmapSurface(w, h)
    }
    
    @discardableResult
    public func moveTo(_ x: Double, _ y: Double) -> Tranformable
    {
      self.x = x - surface.width / 2
      self.y = y - surface.height / 2
      return self
    }
    
    @discardableResult
    public func translate(_ dx: Double, _ dy: Double) -> Tranformable
    {
      self.x = (self.x + dx)
      self.y = (self.y + dy)
      return self
    }
    
    @discardableResult
    public func rotate(_ angle: Double) -> Tranformable
    {
      surface.context.translate(surface.width / 2 , surface.height / 2)
      surface.context.rotate(angle)
      surface.context.translate(-surface.width / 2, -surface.height / 2)
      return self
    }
    
    @discardableResult
    public func scale(_ sx: Double, _ sy: Double) -> Tranformable
    {
      //surface.context.scale(sx, sy)
      Log.info("func is a dummy")
      return self
    }
    
    public func clear()
    {
      cairo_set_operator(surface.context.cr, CAIRO_OPERATOR_OUT)
      cairo_rectangle(surface.context.cr, 0, 0, Double(self.width), Double(self.height))
      cairo_set_source_rgba(surface.context.cr, 0, 0, 0, 0)
      cairo_fill(surface.context.cr)
    }
    
    public func draw(_ dc: Graf.DrawingContext, stroke: Bool = true, fill: Bool = true)
    {
      surface.paintToContext(dc.context, x, y)
    }
  }
}
