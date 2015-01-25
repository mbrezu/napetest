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
package me.mbrezu.napetest;
import me.mbrezu.haxisms.Json;
import nape.geom.Vec2;

class DualShip
{
	var shipLeft: PlayerShip;
	var shipRight: PlayerShip;
	var w: Float;
	var h: Float;
	
	public var battery(default, null): Float;

	public function new(w: Float, h: Float, shipLeft: PlayerShip, shipRight: PlayerShip) 
	{
		this.w = w;
		this.h = h;
		this.shipLeft = shipLeft;
		this.shipRight = shipRight;
		this.shipLeft.dualShip = this;
		this.shipRight.dualShip = this;
		this.battery = 30;
	}
	
	private function dist() {
		return Math.abs(shipLeft.body.position.x - shipRight.body.position.x);
	}
	
	public function update(deltaTime: Float) {
		var oldDist = this.dist();
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
		var newDist = this.dist();
		if (newDist < oldDist) {
			var diff = oldDist / newDist;
			trace(diff);
			var amount = 0.1 * diff * diff;
			chargeBattery(amount);
		}
	}
	
	public function chargeBattery(amount: Float) {
		battery += amount;
		if (battery > 30) {
			battery = 30;
		}
		if (battery < 0) {
			battery = 0;
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
	
	public function toJson(): JsonValue {
		return Js.arr([ shipLeft.toJson(), shipRight.toJson() ]);
	}
	
}