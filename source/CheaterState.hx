package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import PlayState; //copied from playstate
/**
 * ...
 * // took this from pompom sorry sorry sorr s
 */
class CheaterState extends FlxState
{
	private var debugKeysChart:Array<FlxKey>;
	var keysPressed:Array<Bool> = [];
	
	public function new(goodEnding:Bool = true) 
	{
		super();
		
	}
	
	override public function create():Void 
	{
		super.create();

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("CHEATER FUCK YOU", StringTools.replace(PlayState.SONG.song, '-', ' '));
		#end

		var end:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('CHEATER'));
		add(end);
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed(debugKeysChart) || FlxG.keys.justPressed.F1) {
			PlayState.SONG = Song.loadFromJson("heptas-spam-challenge", "heptas-spam-challenge");
			FlxG.switchState(new PlayState());
		}
		
	}
	
}