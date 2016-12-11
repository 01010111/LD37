package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxSort;
import objects.Explosions;
import objects.Goblin;
import objects.Gold;
import objects.Poofs;
import objects.Roomba;
import objects.Schwings;
import objects.Spikester;
import objects.Switch;
import objects.Trash;
import util.Levels;
import zerolib.ZMath;
import zerolib.ZSpotLight;

class PlayState extends FlxState
{
	public static var i:PlayState;
	
	public var level:FlxTilemap;
	public var ground:FlxTilemap;
	public var goblins:FlxTypedGroup<Goblin>;
	public var roomba:Roomba;
	public var schwings:Schwings;
	public var poofs:Poofs;
	public var objects:FlxSpriteGroup;
	public var spotlight:ZSpotLight;
	public var gold:FlxTypedGroup<Gold>;
	public var trash:FlxTypedGroup<Trash>;
	public var explosions:Explosions;
	public var blood_sprite:FlxSprite;
	public var trash_counter:Int = 0;
	public var floor_stuff:FlxGroup;
	
	override public function create():Void
	{
		bgColor = 0xff1d2b53;
		i = this;
		
		super.create();
		
		objects = new FlxSpriteGroup();
		
		init_objects();
		add_objects();
		
		FlxG.camera.follow(roomba, FlxCameraFollowStyle.TOPDOWN, 0.1);
		FlxG.camera.setScrollBoundsRect(-FlxG.width, -FlxG.height, level.width + FlxG.width * 2, level.height + FlxG.height * 2, true);
	}
	
	function init_objects():Void
	{
		var loader = new CustomOgmo("assets/data/2.oel");
		level = new FlxTilemap();
		level = loader.loadTilemap("assets/images/tiles.png", 16, 16, "Tiles");
		level.auto = FlxTilemapAutoTiling.ALT;
		
		ground = new FlxTilemap();
		var _ga:Array<Array<Int>> = new Array();
		for (r in 0...level.heightInTiles)
		{
			var _gr:Array<Int> = new Array();
			for (i in 0...level.widthInTiles)
			{
				var n = Math.random() > 0.95 ? ZMath.randomRangeInt(1, 8) : 0;
				_gr.push(n);
			}
			_ga.push(_gr);
		}
		ground.loadMapFrom2DArray(_ga, "assets/images/ground_tiles.png", 16, 16, null, 0, 0);
		
		trash = new FlxTypedGroup();
		gold = new FlxTypedGroup();
		spotlight = new ZSpotLight(0xff5d5bd3);
		goblins = new FlxTypedGroup();
		poofs = new Poofs();
		explosions = new Explosions();
		schwings = new Schwings();
		floor_stuff = new FlxGroup();
		loader.loadEntities(placeObjects, "Objects");
		spotlight.add_light_target(roomba, 128);
		blood_sprite = new FlxSprite();
		blood_sprite.makeGraphic(Math.floor(level.width), Math.floor(level.height), 0x00ffffff);
		
		for (i in 0...64)
		{
			var _t = new Trash(FlxPoint.get(), trash_counter % 8);
			trash_counter++;
			while (level.overlaps(_t))
				_t.setPosition(Math.random() * level.width, Math.random() * level.height);
		}
	}
	
	function placeObjects(_entity_name:String, _entity_data:Xml):Void
	{
		var _p:FlxPoint = FlxPoint.get(Std.parseInt(_entity_data.get("x")), Std.parseInt(_entity_data.get("y")));
		if (_entity_name == "roomba") 
			roomba = new Roomba(_p);
		if (_entity_name == "goblin")
			var _g = new Goblin(_p, Std.parseInt(_entity_data.get("type")));
		if (_entity_name == "gold")
			var _g = new Gold(_p, ZMath.randomRangeInt(0, 3));
		/*if (_entity_name == "brandy")
			var _t = new Trash(_p, trash_counter % 8);*/
		if (_entity_name == "spikester")
			var _s = new Spikester(_p, Std.parseInt(_entity_data.get("direction")));
		if (_entity_name == "switch")
		{
			var nodes:Array<FlxPoint> = new Array();
			for (n in _entity_data.elements())
			{
				var p = FlxPoint.get(Std.parseInt(n.get("x")), Std.parseInt(n.get("y")));
				nodes.push(p);
			}
			var _s = new Switch(_p, nodes);
		}
		trash_counter++;
	}
	
	function add_objects():Void
	{
		add(ground);
		add(blood_sprite);
		add(floor_stuff);
		add(level);
		add(trash);
		add(gold);
		add(objects);
		add(explosions);
		add(schwings);
		var o = new FlxSprite(0, 0, "assets/images/overlay.png");
		o.scrollFactor.set();
		add(o);
		spotlight.add_to_state();
	}
	
	override public function update(elapsed:Float):Void
	{
		objects.sort(FlxSort.byY, FlxSort.ASCENDING);
		
		super.update(elapsed);
		
		FlxG.collide(level, roomba);
		FlxG.collide(level, goblins);
		FlxG.collide(level, gold);
		FlxG.collide(level, trash);
		FlxG.collide(trash, trash);
		FlxG.collide(goblins, trash);
		FlxG.collide(goblins, goblins);
		FlxG.overlap(roomba, gold, get_gold);
		FlxG.overlap(roomba, trash, get_trash);
		FlxG.overlap(roomba, goblins, kill_roomba);
		
		#if debug
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
		#end
	}
	
	function get_gold(_r:Roomba, _g:Gold):Void
	{
		_g.kill();
	}
	
	function get_trash(_r:Roomba, _t:Trash):Void
	{
		_r.trash++;
		_t.kill();
	}
	
	function kill_roomba(_r:Roomba, _g:Goblin):Void
	{
		FlxG.camera.shake(0.01, 0.2);
		_r.kill();
	}
	
}

class CustomOgmo extends FlxOgmoLoader
{
	
	override public function loadTilemap(TileGraphic:Dynamic, TileWidth:Int = 16, TileHeight:Int = 16, TileLayer:String = "tiles"):FlxTilemap 
	{
		var tileMap:FlxTilemap = new FlxTilemap();
		tileMap.loadMapFromCSV(_fastXml.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight, FlxTilemapAutoTiling.ALT, 0, 0, 0);
		return tileMap;
	}
	
}