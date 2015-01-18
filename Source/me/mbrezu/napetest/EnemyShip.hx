package me.mbrezu.napetest;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.geom.Vec2;

class EnemyShip
{
	public var body(default, null): Body;
	private var context: PhysContext;

	public function new(x: Float, y: Float, speedX: Float, speedY: Float, context: PhysContext)
	{
		this.context = context;
		var target = new Body(BodyType.DYNAMIC, new Vec2(x, y));
		var targetShape = new Polygon(Polygon.rect( -30, -30, 60, 60));
		targetShape.material = Material.wood();
		targetShape.cbTypes.add(context.cbTarget);
		target.shapes.add(targetShape);
		target.group = context.enemyGroup;
		context.space.bodies.add(target);
		target.applyImpulse(new Vec2(speedX, speedY));
	}	
}