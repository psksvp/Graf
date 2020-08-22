//
//  Edge.swift
//  
//
//  Created by psksvp on 4/5/20.
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

#if os(macOS)
import simd
#else
import SGLMath
#endif


extension Graf
{
  public class Edge
  {
    public let p1:Vector3e
    public let p2:Vector3e
  
    public var length: Double
    {
      #if os(macOS)
      return simd_distance(p1, p2)
      #else
      return distance(p1, p2)
      #endif
    }
  
    public var normal: (Vector3e, Vector3e)
    {
      let d = p2 - p1
      return (Vector3e(-d.y, d.x, 1.0), Vector3e(d.y, -d.x, 1.0))
    }
  
    public init(_ p:Vector3e, _ q:Vector3e)
    {
      p1 = p
      p2 = q
    }
    
    public func reflectRay(vector v: Vector3e) -> (Vector3e, Vector3e)
    {
      #if os(macOS)
      func reflect(_ incident: Vector3e, _ normal: Vector3e) -> Vector3e
      {
       
        return simd_reflect(simd_normalize(incident),
                            simd_normalize(normal))
      }
      let (n1, n2) = self.normal
      return (reflect(v, n1), reflect(v, n2))
      #else
      let (n1, n2) = self.normal
      let r1 = reflect(normalize(v), normalize(n1))
      let r2 = reflect(normalize(v), normalize(n2))
      return (r1, r2)
      #endif
    }
    
    public func asLine() -> Polygon
    {
      return Graf.line(p1, p2)
    }
  } // class Edge
} // extension Graf
