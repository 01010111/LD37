package util;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class GSprite extends FlxSprite
{

	function make_and_center_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height * 0.5 - _height * 0.5);
		setSize(_width, _height);
	}
	
	function make_anchored_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height - _height);
		setSize(_width, _height);
	}
	
	function set_facing_flip_horizontal(_sprite_facing_right:Bool = true):Void
	{
		setFacingFlip(FlxObject.LEFT, _sprite_facing_right, false);
		setFacingFlip(FlxObject.RIGHT, !_sprite_facing_right, false);
	}
	
}