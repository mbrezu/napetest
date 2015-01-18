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
import me.mbrezu.haxisms.Time.Cooldown;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.geom.Vec2;

class EnemyShip
{
	public var body(default, null): Body;
	private var context: GameState;
	private var fireCd: Cooldown;

	public function new(x: Float, y: Float, speedX: Float, speedY: Float, context: GameState)
	{
		this.context = context;
		body = new Body(BodyType.DYNAMIC, new Vec2(x, y));
		var shape = new Polygon(Polygon.rect( -30, -30, 60, 60));
		shape.material = Material.wood();
		shape.cbTypes.add(context.cbTarget);
		body.shapes.add(shape);
		body.group = context.enemyGroup;
		context.space.bodies.add(body);
		body.applyImpulse(new Vec2(speedX, speedY));
		body.userData.ship = this;
		fireCd = new Cooldown(1).hot();
	}	
	
	public function update(deltaTime: Float) {
		fireCd.update(deltaTime);
		if (fireCd.isCool()) {
			fireCd.hot();
			//trace("bomb");
			var bullet = new Body(BodyType.DYNAMIC, new Vec2(body.position.x, body.position.y + 40));
			var bulletShape = new Circle(3);
			bullet.shapes.add(bulletShape);
			bulletShape.group = context.enemyGroup;
			bulletShape.material = Material.wood();
			context.space.bodies.add(bullet);
			bullet.applyImpulse(new Vec2(0, 5));
			bullet.cbTypes.add(context.cbEnemyBullet);
			context.addBullet(new Bullet(bullet, 3));
		}
	}
	
	public function toJson(): JsonValue {
		var map = new Map<String, JsonValue>();
		map["x"] = Js.float(Std.int(body.position.x));
		map["y"] = Js.float(Std.int(body.position.y));
		return Js.obj(map);
	}	
}