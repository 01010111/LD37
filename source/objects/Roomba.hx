package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.PlayState;
import util.GSprite;
import util.Palettes;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Roomba extends GSprite
{
	
	var angol:Float = 0;
	public var suck_power:Float = 64;
	var start:FlxPoint;
	public var trash:Int = 0;
	
	public function new(_p:FlxPoint) 
	{
		start = _p;
		super(_p.x + 2, _p.y + 4);
		loadGraphic("assets/images/roomba.png", true, 15, 14);
		make_anchored_hitbox(13, 10);
		drag.set(400, 400);
		maxVelocity.set(60, 60);
		elasticity = 0.8;
		PlayState.i.objects.add(this);
	}
	
	var angle_change:Int = 0;
	var angle_delta:Float = 0;
	var timer:Int;
	
	override public function update(elapsed:Float):Void 
	{
		angol = ZMath.toRelativeAngle(angol);
		
		angle_change = 0;
		if (FlxG.keys.pressed.LEFT)
			angle_change--;
		if (FlxG.keys.pressed.RIGHT)
			angle_change++;
		
		if (angle_change == 0)
			angle_delta = 0;
		else 
			angle_delta = ZMath.clamp(angle_delta += angle_change, -6, 6);
		
		angol += angle_delta;
		
		animation.frameIndex = Math.floor(ZMath.clamp(angol / (360 / 14), 0, 13));
		
		super.update(elapsed);
		
		/*if (wasTouching==FlxObject.UP)
			angol += velocity.x > 0 ? 5 : -5;
		if (wasTouching==FlxObject.DOWN)
			angol += velocity.x > 0 ? -5 : 5;
		if (wasTouching==FlxObject.LEFT)
			angol += velocity.y < 0 ? 5 : -5;
		if (wasTouching==FlxObject.RIGHT)
			angol += velocity.y < 0 ? -5 : 5;*/
		
		var _a = FlxPoint.get();
		if (FlxG.keys.pressed.UP)
			_a = ZMath.velocityFromAngle(angol, 800);
		if (FlxG.keys.pressed.DOWN)
			_a = ZMath.velocityFromAngle(angol + 180, 800);
		
		if (FlxG.keys.anyPressed([FlxKey.UP, FlxKey.DOWN]))
		{
			if (timer == 0)
			{
				PlayState.i.poofs.fire(ZMath.placeOnCircle(getMidpoint(), angol + 180, 8), ZMath.randomRangeInt(3, 6), Palettes.elec_poofs[ZMath.randomRangeInt(0, 1)]);
				timer = ZMath.randomRangeInt(6, 16);
			}
			else
				timer--;
		}
		
		acceleration.set(_a.x, _a.y);
	}
	
	override public function kill():Void 
	{
		for (i in 0...5)
		{
			var _p = FlxPoint.get(getMidpoint().x + ZMath.randomRange( -10, 10), getMidpoint().y + ZMath.randomRange( -10, 10));
			new FlxTimer().start(i * 0.15).onComplete = function(t:FlxTimer):Void
			{
				FlxG.camera.shake(0.1 / (i + 1), 0.1);
				PlayState.i.explosions.fire(_p);
			}
		}
		for (i in 0...trash)
		{
			var m = getMidpoint();
			new FlxTimer().start(i * 0.05).onComplete = function(t:FlxTimer):Void
			{
				var t = new Trash(m, i % 8);
				var v = ZMath.velocityFromAngle(Math.random() * 360, ZMath.randomRange(50, 150));
				t.velocity.set(v.x, v.y);
			}
		}
		super.kill();
		
		new FlxTimer().start(3).onComplete = function(t:FlxTimer):Void
		{
			reset(start.x, start.y);
			trash = 0;
			scale.set();
			FlxTween.tween(scale, {x:1, y:1}, 0.5, {ease:FlxEase.backOut});
		}
	}
	
}