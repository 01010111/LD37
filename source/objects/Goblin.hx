package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import states.PlayState;
import util.GSprite;
import util.Palettes;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Goblin extends GSprite
{
	
	var kind:Int = 0;
	var walk_to_player:Bool = false;
	var sees_player:Bool = false;
	
	var max_speed:Float;
	var smell_radius:Float;
	
	public function new(_p:FlxPoint, _k:Int) 
	{
		super(_p.x, _p.y);
		kind = _k;
		switch(_k)
		{
			case 0:
				max_speed = 40;
				smell_radius = 32;
			case 1:
				max_speed = 30;
				smell_radius = 64;
			case 2:
				max_speed = 50;
				smell_radius = 40;
			case 3:
				max_speed = 64;
				smell_radius = 24;
		}
		loadGraphic("assets/images/goblin.png", true, 16, 20);
		animation.add("idle", [0 + kind * 7]);
		animation.add("walk", [1 + kind * 7, 2 + kind * 7, 2 + kind * 7, 3 + kind * 7, 4 + kind * 7, 5 + kind * 7, 5 + kind * 7, 6 + kind * 7], Math.floor(max_speed * 0.5));
		make_anchored_hitbox(12, 12);
		set_facing_flip_horizontal(true);
		
		animation.callback = anim_callback;
		
		maxVelocity.set(max_speed, max_speed);
		elasticity = 0.2;
		PlayState.i.goblins.add(this);
		PlayState.i.objects.add(this);
	}
	
	function anim_callback(_n:String, _i:Int, _f:Int):Void
	{
		if ((_i == 1 || _i == 4) && Math.random() > 0.5)
			PlayState.i.poofs.fire(FlxPoint.get(getMidpoint().x, getMidpoint().y + height * 0.5), ZMath.randomRangeInt(1, 4), Palettes.walk_poofs[ZMath.randomRangeInt(0,2)]);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (sees_player && walk_to_player)
			chase_player();
		else
			be_lazy();
		
		if (velocity.x == 0 && velocity.y == 0)
			animation.play("idle");
		else
			animation.play("walk");
		
		if (acceleration.x > 0)
			facing = FlxObject.RIGHT;
		else if (acceleration.x < 0)
			facing = FlxObject.LEFT;
	}
	
	function chase_player():Void
	{
		var _a = ZMath.velocityFromAngle(ZMath.angleBetween(getMidpoint(), PlayState.i.roomba.getMidpoint()), 500);
		acceleration.set(_a.x, _a.y);
		
		if (ZMath.distance(getMidpoint(), PlayState.i.roomba.getMidpoint()) > smell_radius * 4)
		{
			sees_player = false;
			walk_to_player = false;
		}
	}
	
	function be_lazy():Void
	{
		acceleration.set();
		velocity.set();
		if (ZMath.distance(getMidpoint(), PlayState.i.roomba.getMidpoint()) < smell_radius && !sees_player)
		{
			sees_player = true;
			PlayState.i.schwings.fire(getMidpoint());
			new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void
			{
				walk_to_player = true;
			}
		}
	}
	
	override public function kill():Void 
	{
		PlayState.i.explosions.fire(getMidpoint());
		FlxG.camera.shake(0.01, 0.1);
		for (i in 0...8)
		{
			var s = new FlxSprite(0, 0, "assets/images/blood" + ZMath.randomRangeInt(1, 8) + ".png");
			PlayState.i.blood_sprite.stamp(s, Math.floor(getMidpoint().x - 16), Math.floor(getMidpoint().y - 16));
		}
		super.kill();
	}
	
}