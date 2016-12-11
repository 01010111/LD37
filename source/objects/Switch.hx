package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import states.PlayState;
import util.GSprite;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Switch extends GSprite
{
	
	var spikes:FlxTypedGroup<Spike>;
	var activated:Bool = false;
	
	public function new(_p:FlxPoint, _n:Array<FlxPoint>)
	{
		super();
		setPosition(_p.x + 2, _p.y + 2);
		loadGraphic("assets/images/switch.png", true, 16, 16);
		make_and_center_hitbox(12, 12);
		PlayState.i.floor_stuff.add(this);
		spikes = new FlxTypedGroup();
		for (p in _n)
		{
			var s = new Spike(p);
			spikes.add(s);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		activated = FlxG.overlap(this, PlayState.i.roomba);
		
		for (s in spikes)
			s.activated = activated;
		
		if (activated)
		{
			animation.frameIndex = 1;
		}
		else
		{
			animation.frameIndex = 0;
		}
	}
	
}

class Spike extends GSprite
{
	
	public var activated:Bool = false;
	
	public function new(_p:FlxPoint)
	{
		super();
		setPosition(_p.x, _p.y);
		loadGraphic("assets/images/spikes.png", true, 16, 16);
		immovable = true;
		PlayState.i.floor_stuff.add(this);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (activated)
		{
			animation.frameIndex = 1;
			FlxG.overlap(this, PlayState.i.goblins, kill_goblin);
			FlxG.overlap(this, PlayState.i.roomba, kill_goblin);
			FlxG.overlap(this, PlayState.i.trash, move_trash);
		}
		else
		{
			animation.frameIndex = 0;
		}
	}
	
	function kill_goblin(_g:FlxSprite, _s:FlxObject):Void
	{
		_s.kill();
	}
	
	function move_trash(_t:FlxSprite, _s:FlxObject):Void
	{
		var v = ZMath.velocityFromAngle(ZMath.angleBetween(getMidpoint(), _t.getMidpoint()), 80);
		_s.velocity.set(v.x, v.y);
	}
	
}