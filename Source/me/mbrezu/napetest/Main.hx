package me.mbrezu.napetest ;

import haxe.ds.Vector;
import me.mbrezu.haxisms.Random;
import me.mbrezu.haxisms.Time.Cooldown;
import me.mbrezu.haxisms.Time.TimeManager;
import me.mbrezu.nape.DebugView;
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
	private var context: PhysContext;
	private var ship: PlayerShip;
	
	public function new () {
		
		super ();
		
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		
		context = new PhysContext(w, h);
		
		ship = new PlayerShip(w / 2, h - 40, context);
			
		tm = new TimeManager();
		newTargetCd = new Cooldown(2).hot();
		r = new Random();
				
		stage.addEventListener(Event.ENTER_FRAME, function(e)  {
			gameLoop();
		});
		
		keys = new KeyboardState();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function (evt) {
			keys.handleKeyDown(evt);
		});
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function (evt) {
			var oldFirePressed = keys.firePressed;			
			keys.handleKeyUp(evt);
			if (oldFirePressed && !keys.firePressed) {
				ship.fire();
			}
		});
	}	
	
	private function gameLoop() {
		var deltaTime = tm.getDeltaTime();
		if (deltaTime <= 0) {
			return;
		}
		ship.update(keys);
		newTargetCd.update(deltaTime);
		if (newTargetCd.isCool()) {
			newTargetCd.hot();
			new EnemyShip(60, r.float(50, context.h - 150), r.float(100, 1000), 0, context);
		}
		context.space.step(deltaTime);
		graphics.clear();
		DebugView.drawOn(graphics, context.space);
	}
}