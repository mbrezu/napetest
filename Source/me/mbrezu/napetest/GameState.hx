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
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.dynamics.InteractionGroup;
import nape.geom.Vec2;
import nape.phys.Interactor;
import nape.space.Space;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import nape.phys.Material;

class GameState
{
	public var space(default, null): Space;
	public var playerGroup(default, null): InteractionGroup;
	public var enemyGroup(default, null): InteractionGroup;
	public var cbPlayerBullet(default, null): CbType;
	public var cbEnemyBullet(default, null): CbType;
	public var cbWall(default, null): CbType;
	public var cbTarget(default, null): CbType;	
	public var cbPlayer(default, null): CbType;	
	public var w(default, null): Float;
	public var h(default, null): Float;
	public var gameIsOver(default, null): Bool;
	
	private var enemies: Array<EnemyShip>;
	
	public function new(w: Float, h: Float) 
	{
		this.w = w;
		this.h = h;
		gameIsOver = false;
		space = new Space(new Vec2(0, 0));
		playerGroup = new InteractionGroup(true);
		enemyGroup = new InteractionGroup(true);
		enemies = new Array<EnemyShip>();
		
		cbPlayerBullet = new CbType();
		cbEnemyBullet = new CbType();
		cbWall = new CbType();
		cbTarget = new CbType();
		cbPlayer = new CbType();
		
		var wallBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, cbPlayerBullet, cbWall, function(ih) {
			//trace("ole!", ih.int1);
			space.bodies.remove(getBody(ih.int1));
		});
		space.listeners.add(wallBulletListener);
		
		var wallBulletListener2 = new  InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, cbEnemyBullet, cbWall, function(ih) {
			//trace("ole!", ih.int1);
			space.bodies.remove(getBody(ih.int1));
		});
		space.listeners.add(wallBulletListener2);
		
		var wallTargetListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, cbTarget, cbWall, function(ih) {
			//trace("ole! target", ih.int1);
			removeEnemy(getBody(ih.int1));
		});
		space.listeners.add(wallTargetListener);
		
		var targetBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbPlayerBullet, cbTarget, function(ih) {
			//trace(Type.typeof(ih.int1), ih.int1.isBody());
			//trace(Type.typeof(ih.int2), ih.int2.isShape());
			space.bodies.remove(getBody(ih.int1));
			removeEnemy(getBody(ih.int2));
		});
		space.listeners.add(targetBulletListener);
		
		var bulletBulletListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbEnemyBullet, cbPlayerBullet, function(ih) {
			space.bodies.remove(getBody(ih.int1));
			space.bodies.remove(getBody(ih.int2));
		});
		space.listeners.add(bulletBulletListener);
		
		var playerBulletListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbEnemyBullet, cbPlayer, function(ih) {
			space.bodies.remove(getBody(ih.int1));
			getBody(ih.int2).userData.ship.hit();
			trace("ouch");
		});
		space.listeners.add(playerBulletListener);
		
		addWall(new Vec2(w / 2, 5), Polygon.rect( -w / 2, -5, w, 10));
		addWall(new Vec2(w - 5, h / 2), Polygon.rect( -5, -h / 2, 10, h));
		addWall(new Vec2(5, h / 2), Polygon.rect( -5, -h / 2, 10, h));
		addWall(new Vec2(w / 2, h - 5), Polygon.rect( -w / 2, -5, w, 10));
	}

	private function addWall(center: Vec2, shape: Array<Vec2>) {
		var wallBody = new Body(BodyType.STATIC, center);
		var shape = new Polygon(shape);
		shape.material = Material.wood();
		shape.sensorEnabled = true;
		wallBody.shapes.add(shape);
		wallBody.cbTypes.add(cbWall);
		space.bodies.add(wallBody);		
	}

	public function addEnemyShip(es: EnemyShip) {
		enemies.push(es);
	}

	public function update(deltaTime: Float) {
		for (enemy in enemies) {
			enemy.update(deltaTime);
		}
	}

	private function removeEnemy(enemyBody: Body) {
		space.bodies.remove(enemyBody);
		trace(enemies.length);
		enemies.remove(cast(enemyBody.userData.ship, EnemyShip));
		trace(enemies.length);
	}
	
	private function getBody(int: Interactor) {
		if (int.isBody()) {
			return int.castBody;
		} else if (int.isShape()) {
			return int.castShape.body;
		} else {
			throw "ouch";
		}
	}
	
	public function gameOver() {
		trace("game over!");
		gameIsOver = true;
	}

}