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
package me.mbrezu.napetest.view;
import me.mbrezu.haxisms.Json.JsonValue;
import openfl.display.Graphics;

class Bullet {
	public var x: Float;
	public var y: Float;
	public var radius: Float;
	
	public function new(js: JsonValue) {
		var o = js.obj;
		x = o.get("x").float;
		y = o.get("y").float;
		radius = o.get("radius").float;
	}
}

class Ship {
	public var x: Float;
	public var y: Float;
	public var isEnemy: Bool;
	
	public function new(js: JsonValue, isEnemy: Bool) {
		this.isEnemy = isEnemy;
		var o = js.obj;
		x = o.get("x").float;
		y = o.get("y").float;
	}
}

class Data
{	
	public var bullets: Array<Bullet>;
	public var ships: Array<Ship>;

	public function new(js: JsonValue) 
	{
		bullets = new Array<Bullet>();
		ships = new Array<Ship>();
		Lambda.iter(js.obj.get("bullets").arr, function(jsBullet) { bullets.push(new Bullet(jsBullet)); } );
		Lambda.iter(js.obj.get("enemies").arr, function(jsEnemy) { ships.push(new Ship(jsEnemy, true)); } );
		Lambda.iter(js.obj.get("player").arr, function(jsPlayer) { ships.push(new Ship(jsPlayer, false)); } );
		//trace("***", bullets.length, ships.length);
	}
	
	public function draw(g: Graphics) {
		g.lineStyle(1, 0);
		for (bullet in bullets) {
			g.beginFill(0xaabb33, 0.5);
			g.drawCircle(bullet.x, bullet.y, bullet.radius);
			g.endFill();
		}
		for (ship in ships) {			
			g.beginFill(if (ship.isEnemy) 0xaa3344 else 0x44bb33, 0.5);
			g.drawRect(ship.x - 40, ship.y - 40, 80, 80);
			g.endFill();
		}
	}
	
}