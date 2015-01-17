package;

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
	
	public function new () {
		
		super ();
		
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		
		var gravity = new Vec2(0, 0);
		var space = new Space(gravity);

		var cbBullet = new CbType();
		var cbCeiling = new CbType();
		var cbTarget = new CbType();
		var ceilingBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbBullet, cbCeiling, function(ih) {
			space.bodies.remove(cast(ih.int1, Body));
		});
		space.listeners.add(ceilingBulletListener);
		var targetBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbBullet, cbTarget, function(ih) {
			//trace(Type.typeof(ih.int1), ih.int1.isBody());
			//trace(Type.typeof(ih.int2), ih.int2.isShape());
			space.bodies.remove(cast(ih.int1, Body));
			space.bodies.remove(cast(ih.int2, Shape).body);
		});
		space.listeners.add(targetBulletListener);
		
		var shipGroup = new InteractionGroup(true);				

		var ship = new Body(BodyType.KINEMATIC, new Vec2(w / 2, h - 40));
		var shipShape = new Polygon(Polygon.regular(40, 40, 5, -Math.PI / 2));
		shipShape.group = shipGroup;
		ship.shapes.add(shipShape);
		space.bodies.add(ship);	
		
		var ceiling = new Body(BodyType.STATIC, new Vec2(w / 2, 10));
		var ceilingShape = new Polygon(Polygon.rect( -w / 2, -5, w, 10));
		ceilingShape.material = Material.wood();
		ceiling.shapes.add(ceilingShape);
		ceiling.cbTypes.add(cbCeiling);
		space.bodies.add(ceiling);
				
		var tm = new TimeManager();
		var newTargetCd = new Cooldown(2).hot();
		var r = new Random();
		
		var leftPressed = false;
		var rightPressed = false;
		var firePressed = false;
		#if !windows
		var leftKeyCode = 112;
		var rightKeyCode = 113;
		var fireKeyCode = 32;
		#else 
		var leftKeyCode = 80;
		var rightKeyCode = 81;
		var fireKeyCode = 32;
		#end
		
		stage.addEventListener(Event.ENTER_FRAME, function(e)  {
			var deltaTime = tm.getDeltaTime();
			if (deltaTime <= 0) {
				return;
			}
			if (leftPressed) {
				ship.position.x -= 10;
			}
			if (rightPressed) {
				ship.position.x += 10;
			}
			space.step(deltaTime);
			if (ship.position.x < 40) {
				ship.velocity.set(new Vec2(0, 0));
				ship.position.set(new Vec2(40, ship.position.y));
			}
			if (ship.position.x > w - 40) {
				ship.velocity.set(new Vec2(0, 0));
				ship.position.set(new Vec2(w - 40, ship.position.y));
			}
			newTargetCd.update(deltaTime);
			if (newTargetCd.isCool()) {
				newTargetCd.hot();
				var target = new Body(BodyType.DYNAMIC, new Vec2(0, r.float(50, h - 150)));
				var targetShape = new Polygon(Polygon.rect( -30, -30, 60, 60));
				targetShape.material = Material.wood();
				targetShape.cbTypes.add(cbTarget);
				target.shapes.add(targetShape);
				space.bodies.add(target);
				target.applyImpulse(new Vec2(200, 0));
			}
			graphics.clear();
			DebugView.drawOn(graphics, space);
		});
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function (evt) {
			if (evt.keyCode == leftKeyCode) {
				leftPressed = true;
			} else if (evt.keyCode == rightKeyCode) {
				rightPressed = true;
			} else if (evt.keyCode == fireKeyCode) {
				firePressed = true;
			}
		});
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function (evt) {
			var oldFirePressed = firePressed;			
			if (evt.keyCode == leftKeyCode) {
				leftPressed = false;
			} else if (evt.keyCode == rightKeyCode) {
				rightPressed = false;
			} else if (evt.keyCode == fireKeyCode) {
				firePressed = false;
			}
			if (oldFirePressed && !firePressed) {
				var bullet = new Body(BodyType.DYNAMIC, new Vec2(ship.position.x, ship.position.y - 40));
				var bulletShape = new Circle(5);
				//var bulletShape = new Polygon(Polygon.rect( -5, -5, 10, 10));
				bullet.shapes.add(bulletShape);
				bulletShape.group = shipGroup;
				bulletShape.material = Material.wood();
				space.bodies.add(bullet);
				bullet.applyImpulse(new Vec2(0, -40));
				bullet.cbTypes.add(cbBullet);				
			}
		});
	}	
}