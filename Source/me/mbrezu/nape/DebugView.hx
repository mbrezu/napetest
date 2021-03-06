/*
Copyright (c) 2015, Miron Brezuleanu
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package me.mbrezu.nape;
import nape.geom.Vec2List;
import nape.shape.ShapeType;
import nape.space.Space;
import openfl.display.Graphics;

/**
 * ...
 * @author 
 */
class DebugView
{

	private function new() 
	{		
	}
	
	public static function drawOn(g: Graphics, space: Space)
	{
		for (b in space.bodies) {
			for (s in b.shapes) {
				if (s.isPolygon()) {
					var poly = s.castPolygon;
					var first = true;
					g.beginFill(0xaabb33, 0.5);
					g.lineStyle(1, 0, 1);
					for (v in poly.worldVerts) {
						if (first) {
							g.moveTo(v.x, v.y);
							first = false;
						}
						else {
							g.lineTo(v.x, v.y);
						}
					}
					var v0 = poly.worldVerts.at(0);
					g.lineTo(v0.x, v0.y);
					g.endFill();
					g.moveTo(v0.x, v0.y);
					g.lineTo(b.position.x, b.position.y);
				} else if (s.isCircle()) {
					var circle = s.castCircle;
					var bounds = s.bounds;
					var cx = bounds.x + bounds.width / 2;
					var cy = bounds.y + bounds.height / 2;
					g.beginFill(0xaabb33, 0.5);
					g.lineStyle(1, 0, 1);
					g.drawCircle(cx, cy, circle.radius);
					g.endFill();
					g.moveTo(cx, cy);
					g.lineTo(cx + Math.cos(b.rotation) * circle.radius, cy + Math.sin(b.rotation) * circle.radius);
				}
			}
		}
	}
	
}