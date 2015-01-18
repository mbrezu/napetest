package me.mbrezu.napetest;
import nape.callbacks.CbType;
import nape.callbacks.CbEvent;
import nape.dynamics.InteractionGroup;
import nape.geom.Vec2;
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

class PhysContext
{
	public var space(default, null): Space;
	public var playerGroup(default, null): InteractionGroup;
	public var enemyGroup(default, null): InteractionGroup;
	public var cbBullet(default, null): CbType;
	public var cbWall(default, null): CbType;
	public var cbTarget(default, null): CbType;	
	public var w(default, null): Float;
	public var h(default, null): Float;
	
	public function new(w: Float, h: Float) 
	{
		this.w = w;
		this.h = h;
		space = new Space(new Vec2(0, 0));
		playerGroup = new InteractionGroup(true);
		enemyGroup = new InteractionGroup(true);
		
		cbBullet = new CbType();
		cbWall = new CbType();
		cbTarget = new CbType();
		
		var wallBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, cbBullet, cbWall, function(ih) {
			//trace("ole!", ih.int1);
			space.bodies.remove(cast(ih.int1, Body));
		});
		space.listeners.add(wallBulletListener);
		
		var wallTargetListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, cbTarget, cbWall, function(ih) {
			//trace("ole! target", ih.int1);
			space.bodies.remove(cast(ih.int1, Shape).body);
		});
		space.listeners.add(wallTargetListener);
		
		var targetBulletListener = new  InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, cbBullet, cbTarget, function(ih) {
			//trace(Type.typeof(ih.int1), ih.int1.isBody());
			//trace(Type.typeof(ih.int2), ih.int2.isShape());
			space.bodies.remove(cast(ih.int1, Body));
			space.bodies.remove(cast(ih.int2, Shape).body);
		});
		space.listeners.add(targetBulletListener);
		
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
	
}