package objects;
import states.PlayState;
import util.GSprite;
import zerolib.ZMath;

/**
 * ...
 * @author ...
 */
class Sucked extends GSprite
{

	public function new() 
	{
		super();
		drag.set(200, 200);
	}
	
	override public function update(elapsed:Float):Void 
	{
		var d = ZMath.distance(getMidpoint(), PlayState.i.roomba.getMidpoint());
		if (d < PlayState.i.roomba.suck_power && PlayState.i.roomba.exists)
		{
			var _a = ZMath.velocityFromAngle(ZMath.angleBetween(getMidpoint(), PlayState.i.roomba.getMidpoint()), Math.pow(PlayState.i.roomba.suck_power - d, 2));
			acceleration.copyFrom(_a);
		}
		else acceleration.set();
		super.update(elapsed);
	}
	
}