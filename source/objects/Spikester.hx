package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import states.PlayState;
import util.GSprite;

/**
 * ...
 * @author ...
 */
class Spikester extends GSprite
{

	public function new(_p:FlxPoint, _d:Int) 
	{
		super();
		setPosition(_p.x, _p.y);
		loadGraphic("assets/images/spikester.png", true, 16, 16);
		switch(_d)
		{
			case 0:
				facing = FlxObject.UP;
			case 1:
				facing = FlxObject.DOWN;
			case 2:
				facing = FlxObject.LEFT;
			case 3:
				facing = FlxObject.RIGHT;
		}
		
		maxVelocity.set(120, 120);
		
		PlayState.i.objects.add(this);
		
		go();
	}
	
	override public function update(elapsed:Float):Void 
	{
		switch(facing)
		{
			case FlxObject.UP:
				animation.frameIndex = 0;
			case FlxObject.DOWN:
				animation.frameIndex = 1;
			case FlxObject.LEFT:
				animation.frameIndex = 2;
			case FlxObject.RIGHT:
				animation.frameIndex = 3;
		}
		
		if (justTouched(FlxObject.ANY))
			hit();
		
		super.update(elapsed);
		
		FlxG.collide(PlayState.i.level, this);
		FlxG.overlap(PlayState.i.goblins, this, kill_goblin);
	}
	
	function kill_goblin(_g:Goblin, _s:Spikester):Void
	{
		_g.kill();
	}
	
	function hit():Void
	{
		FlxG.camera.shake(0.01, 0.1);
		
		acceleration.set();
		switch(facing)
		{
			case FlxObject.UP:
				facing = FlxObject.RIGHT;
			case FlxObject.DOWN:
				facing = FlxObject.LEFT;
			case FlxObject.LEFT:
				facing = FlxObject.UP;
			case FlxObject.RIGHT:
				facing = FlxObject.DOWN;
		}
		
		new FlxTimer().start(1, go);
	}
	
	function go(?t:FlxTimer):Void
	{
		switch(facing)
		{
			case FlxObject.UP:
				acceleration.y = -50;
			case FlxObject.DOWN:
				acceleration.y = 50;
			case FlxObject.LEFT:
				acceleration.x = -50;
			case FlxObject.RIGHT:
				acceleration.x = 50;
		}
	}
	
}