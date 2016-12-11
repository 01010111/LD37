package objects;
import flixel.math.FlxPoint;
import states.PlayState;
import util.Palettes;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Trash extends Sucked
{
	
	var timer:Int;
	
	public function new(_p:FlxPoint, _s:Int) 
	{
		super();
		setPosition(_p.x + ZMath.randomRange(0, 4), _p.y + ZMath.randomRange(0, 4));
		loadGraphic("assets/images/brandy.png", true, 12, 12);
		make_and_center_hitbox(2, 2);
		animation.frameIndex = Math.floor(ZMath.clamp(_s, 0, 8));
		PlayState.i.trash.add(this);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (Math.abs(velocity.x) > 20 && Math.abs(velocity.y) > 20)
		{
			if (timer == 0)
			{
				PlayState.i.poofs.fire(getMidpoint(), ZMath.randomRangeInt(1, 5), Palettes.dirt_poofs[ZMath.randomRangeInt(0, 5)]);
				timer = ZMath.randomRangeInt(10, 20);
			}
			else
				timer--;
		}
		
		angle += velocity.x * 0.2;
		super.update(elapsed);
	}
	
}