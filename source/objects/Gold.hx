package objects;
import flixel.math.FlxPoint;
import states.PlayState;
import util.GSprite;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Gold extends Sucked
{

	public function new(_p:FlxPoint, _s:Int) 
	{
		super();
		setPosition(_p.x + ZMath.randomRange(0, 8), _p.y + ZMath.randomRange(0.8));
		loadGraphic("assets/images/gold.png", true, 8, 8);
		animation.frameIndex = Math.floor(ZMath.clamp(_s, 0, 3));
		//PlayState.i.spotlight.add_light_target(this, 20);
		PlayState.i.gold.add(this);
	}
	
}