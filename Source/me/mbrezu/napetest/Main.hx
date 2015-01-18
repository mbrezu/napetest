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
package me.mbrezu.napetest ;

import haxe.ds.Vector;
import me.mbrezu.haxisms.Random;
import me.mbrezu.haxisms.Time.Cooldown;
import me.mbrezu.haxisms.Time.TimeManager;
import me.mbrezu.nape.DebugView;
import me.mbrezu.napetest.view.Data;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.dynamics.InteractionGroup;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import openfl.display.Sprite;
import nape.geom.Vec2;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class Main extends Sprite {
	
	private var tm: TimeManager;
	private var newTargetCd: Cooldown;
	private var r: Random;
	private var keys: KeyboardState;
	private var context: GameState;
	private var ship: DualShip;
	
	public function new () {
		
		super ();
		
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		
		context = new GameState(w, h);
		
		keys = new KeyboardState();
		
		ship = new DualShip(
			w, h, 
			new PlayerShip(w / 3, h - 40, context, keys.keySet1),
			new PlayerShip(w / 3 * 2, h - 40, context, keys.keySet2));
			
		context.dualShip = ship;
			
		tm = new TimeManager();
		newTargetCd = new Cooldown(1).hot();
		r = new Random();
				
		stage.addEventListener(Event.ENTER_FRAME, function(e)  {
			gameLoop();
		});
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function (evt) {
			keys.handleKeyDown(evt);
		});
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function (evt) {
			ship.preKeyUp();
			keys.handleKeyUp(evt);
			ship.postKeyUp();
		});
	}	
	
	private function gameLoop() {
		var deltaTime = tm.getDeltaTime();
		if (deltaTime <= 0) {
			return;
		}
		//if (context.gameIsOver) {
			//return;
		//}
		ship.update(deltaTime);
		newTargetCd.update(deltaTime);
		if (newTargetCd.isCool()) {
			newTargetCd.hot();			
			context.addEnemyShip(new EnemyShip(60, r.float(50, context.h - 150), r.float(100, 1000), 0, context));
		}
		context.update(deltaTime);
		context.space.step(deltaTime);
		graphics.clear();
		var data = new Data(context.toJson());
		data.draw(graphics);
		//DebugView.drawOn(graphics, context.space);
	}
}