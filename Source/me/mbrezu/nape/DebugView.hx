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