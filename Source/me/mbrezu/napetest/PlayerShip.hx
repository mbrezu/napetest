/*
Copyright (c) 2014, Miron Brezuleanu
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
import haxe.macro.Context;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.phys.Material;

class PlayerShip
{
	public var body(default, null): Body;
	private var context: GameState;
	private var health: Int;
	
	public function new(x: Float, y: Float, context: GameState) 
	{
		body = new Body(BodyType.KINEMATIC, new Vec2(x, y));
		var shipShape = new Polygon(Polygon.regular(40, 40, 5, -Math.PI / 2));
		shipShape.group = context.playerGroup;
		body.shapes.add(shipShape);
		context.space.bodies.add(body);	
		body.cbTypes.add(context.cbPlayer);
		this.context = context;
		health = 5;
		body.userData.ship = this;
	}
	
	public function hit() {
		if (health > 0) {
			health --;
		}
		if (health == 0) {
			trace("game over");
			context.gameOver();
		}
	}
	
	public function fire() {
		var bullet = new Body(BodyType.DYNAMIC, new Vec2(body.position.x, body.position.y - 40));
		var bulletShape = new Circle(5);
		bullet.shapes.add(bulletShape);
		bulletShape.group = context.playerGroup;
		bulletShape.material = Material.wood();
		context.space.bodies.add(bullet);
		bullet.applyImpulse(new Vec2(0, -40));
		bullet.cbTypes.add(context.cbPlayerBullet);				
	}
	
	public function update(keys: KeyboardState) {
		if (keys.leftPressed) {
			body.position.x -= 10;
		}
		if (keys.rightPressed) {
			body.position.x += 10;
		}
		if (body.position.x < 40) {
			body.velocity.set(new Vec2(0, 0));
			body.position.set(new Vec2(40, body.position.y));
		}
		if (body.position.x > context.w - 40) {
			body.velocity.set(new Vec2(0, 0));
			body.position.set(new Vec2(context.w - 40, body.position.y));
		}
	}
	
}