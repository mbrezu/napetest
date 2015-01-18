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
	private var context: PhysContext;
	
	public function new(x: Float, y: Float, context: PhysContext) 
	{
		body = new Body(BodyType.KINEMATIC, new Vec2(x, y));
		var shipShape = new Polygon(Polygon.regular(40, 40, 5, -Math.PI / 2));
		shipShape.group = context.playerGroup;
		body.shapes.add(shipShape);
		context.space.bodies.add(body);		
		this.context = context;
	}
	
	public function fire() {
		var bullet = new Body(BodyType.DYNAMIC, new Vec2(body.position.x, body.position.y - 40));
		var bulletShape = new Circle(5);
		bullet.shapes.add(bulletShape);
		bulletShape.group = context.playerGroup;
		bulletShape.material = Material.wood();
		context.space.bodies.add(bullet);
		bullet.applyImpulse(new Vec2(0, -40));
		bullet.cbTypes.add(context.cbBullet);				
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