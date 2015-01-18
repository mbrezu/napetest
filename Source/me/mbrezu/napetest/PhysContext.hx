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
	public var cbCeiling(default, null): CbType;
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
		cbCeiling = new CbType();
		cbTarget = new CbType();
		
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
		
		var ceiling = new Body(BodyType.STATIC, new Vec2(w / 2, 10));
		var ceilingShape = new Polygon(Polygon.rect( -w / 2, -5, w, 10));
		ceilingShape.material = Material.wood();
		ceiling.shapes.add(ceilingShape);
		ceiling.cbTypes.add(cbCeiling);
		space.bodies.add(ceiling);
	}
	
}