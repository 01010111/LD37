package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.Schwings.Schwing;
import states.PlayState;
import util.GSprite;

/**
 * ...
 * @author ...
 */
class Schwings extends FlxTypedGroup<Schwing>
{

	public function new() 
	{
		super();
		for (i in 0...16)
		{
			add(new Schwing());
		}
	}
	
	public function fire(_p:FlxPoint):Void
	{
		if (getFirstAvailable() != null)
			getFirstAvailable().fire(_p);
	}
	
}

class Schwing extends GSprite
{
	
	public function new ()
	{
		super();
		loadGraphic("assets/images/schwing.png");
		make_anchored_hitbox(1,1);
		exists = false;
	}
	
	public function fire(_p:FlxPoint):Void
	{
		alpha = 1;
		setPosition(_p.x + 1, _p.y - 10);
		scale.set(1, 0);
		FlxTween.tween(scale, {y:1}, 0.2, {ease:FlxEase.backOut});
		FlxTween.tween(this, {y:y - 2}, 0.5, {ease:FlxEase.circOut}).onComplete = function(t:FlxTween):Void
		{
			FlxTween.tween(this, {alpha:0, y:y - 6}, 0.3);
			FlxTween.tween(scale, {x:0, y:2}, 0.2, {ease:FlxEase.backIn}).onComplete = function(t:FlxTween):Void
			{
				kill();
			}
		}
		exists = true;
	}
	
}