package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import util.GSprite;

/**
 * ...
 * @author ...
 */
class Explosions extends FlxTypedGroup<Explosion>
{

	public function new() 
	{
		super();
		for (i in 0...16)
			add(new Explosion());
	}
	
	public function fire(_p:FlxPoint):Void
	{
		if (getFirstAvailable() != null)
			getFirstAvailable().fire(_p);
	}
	
}

class Explosion extends GSprite
{
	
	public function new()
	{
		super();
		exists = false;
		loadGraphic("assets/images/explosion.png", true, 32, 32);
		animation.add("play", [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7, 8], 30, false);
		make_and_center_hitbox(0, 0);
	}
	
	public function fire(_p:FlxPoint):Void
	{
		setPosition(_p.x, _p.y);
		angle = Math.random() * 360;
		animation.play("play");
		exists = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished)
			kill();
		super.update(elapsed);
	}
	
}