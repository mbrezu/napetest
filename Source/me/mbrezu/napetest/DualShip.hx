package me.mbrezu.napetest;
import nape.geom.Vec2;

/**
 * ...
 * @author 
 */
class DualShip
{
	var shipLeft: PlayerShip;
	var shipRight: PlayerShip;
	var w: Float;
	var h: Float;

	public function new(w: Float, h: Float, shipLeft: PlayerShip, shipRight: PlayerShip) 
	{
		this.w = w;
		this.h = h;
		this.shipLeft = shipLeft;
		this.shipRight = shipRight;
	}
	
	public function update(deltaTime: Float) {
		shipLeft.update(deltaTime);
		shipRight.update(deltaTime);
		var posLeft = shipLeft.body.position;
		var posRight = shipRight.body.position;
		var spaceLeft = posLeft.x - 40;
		var spaceRight = w - 40 - posRight.x;
		var dist = Math.abs(posRight.x - posLeft.x);
		if (dist < 80) {
			var distToRecover = 80 - dist;
			var dtrLeft = distToRecover / 2;
			var dtrRight = distToRecover / 2;
			if (dtrLeft > spaceLeft) {
				dtrRight += dtrLeft - spaceLeft;
				dtrLeft = spaceLeft;
			}
			if (dtrRight > spaceRight) {
				dtrLeft += dtrRight - spaceRight;
				dtrRight = spaceRight;
			}
			shipLeft.body.position = new Vec2(posLeft.x - dtrLeft, posLeft.y);
			shipRight.body.position = new Vec2(posRight.x + dtrRight, posRight.y);
		}
	}
	
	public function preKeyUp() {
		shipLeft.preKeyUp();
		shipRight.preKeyUp();
	}
	
	public function postKeyUp() {
		shipLeft.postKeyUp();
		shipRight.postKeyUp();
	}
	
}