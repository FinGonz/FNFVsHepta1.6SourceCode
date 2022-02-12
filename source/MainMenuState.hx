package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var vsHeptaVersion:String = '1.6.1';
	public static var psychEngineVersion:String = 'Custom Build'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var tipText:FlxText;
    var tipfuck:String = "";       
	var tipBackground:FlxSprite;
	var tipTextMargin:Float = 10;
	var tipTextScrolling:Bool = false;
	public static var firstStart:Bool = true;
	var menuItem:FlxSprite;
	public static var finishedFunnyMove:Bool = false;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
	    #if ACHIEVEMENTS_ALLOWED
		'awards',
		#end
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	public var camZooming:Bool = false;
	private var char1:Character = null;
	private var char2:Character = null;
	private var char3:Character = null;
	private var char4:Character = null;
	private var characterLore:Character = null;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		WeekData.setDirectoryFromWeek();
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		camGame.zoom = 1.5;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 112 - (Math.max(optionShit.length, 4) - 4) * 80;
			menuItem = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.x -= -90;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.alpha = 100;
			menuItem.updateHitbox();
			if (firstStart)
				FlxTween.tween(camGame,{zoom: 1.0},2.0 ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				camGame.zoom = 1.0;
		}

	firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);

		char1 = new Character(600, -275, 'hepta', true);
		add(char1);
		char1.visible = false;

		char2 = new Character(460, -125, 'cb', true);
		char2.flipX = true;
		add(char2);
		char2.visible = false;

		char3 = new Character(500, 70, 'guest666', true);
		add(char3);
		char3.visible = false;

		char4 = new Character(500, 270, 'izzat-playable', true);
		add(char4);
		char4.visible = false;

		characterLore = new Character(500, 300, 'rookie', true);
		characterLore.scale.set(1.5, 1.5);
		add(characterLore);
		characterLore.visible = false;

		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Vs Hepta v" + vsHeptaVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine " + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		switch(FlxG.random.int(2, 10)) //thank you grafex engine
					{
					case 1:
						tipfuck = "Also try Funky Friday!";
					case 2:
						tipfuck = "This took a long time to make...";
					case 3:
						tipfuck = "Not LUA lol";
					case 4:
						tipfuck = "yes i would like some cone popsicles";
					case 5:
						tipfuck = "Screen Shaking in Heptagonistic!";
					case 6:
						tipfuck = "shoot shoot swing swing";
					case 7:
						tipfuck = "Dont do ##### kids";
					case 8:
						tipfuck = "oders are stinky";
					case 9:
						tipfuck = "Heptagonistic ain't hard, it's just skill issue.";
					case 10:
						tipfuck = "?????????????";
					if (FlxG.save.data.spamFound) {
						tipfuck = "wow you found secret song";
					}
					}

		tipBackground = new FlxSprite();
		tipBackground.scrollFactor.set();
		tipBackground.alpha = 0.7;
		add(tipBackground);

        tipText = new FlxText(0, 0, 0, tipfuck);
		tipText.scrollFactor.set();
		tipText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT);
		tipText.updateHitbox();

        add(tipText);

		tipBackground.makeGraphic(FlxG.width, Std.int((tipTextMargin * 2) + tipText.height), FlxColor.BLACK);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
		tipTextStartScrolling();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.F11)
			{
			   FlxG.fullscreen = !FlxG.fullscreen;
			}
	
			if (tipTextScrolling)
			{
				tipText.x -= elapsed * 130;
				if (tipText.x < -tipText.width)
				{
					switch(FlxG.random.int(2, 10)) //thank you grafex engine
					{
					case 1:
						tipfuck = "Also try Funky Friday!";
					case 2:
						tipfuck = "This took a long time to make...";
					case 3:
						tipfuck = "Not LUA lol";
					case 4:
						tipfuck = "yes i would like some cone popsicles";
					case 5:
						tipfuck = "Screen Shaking in Heptagonistic!";
					case 6:
						tipfuck = "shoot shoot swing swing";
					case 7:
						tipfuck = "Dont do ##### kids";
					case 8:
						tipfuck = "oders are stinky";
					case 9:
						tipfuck = "Heptagonistic ain't hard, it's just skill issue.";
					case 10:
						if (FlxG.save.data.spamFound) {
							tipfuck = "wow you found secret song";
						} else {
						tipfuck = "?????????????";
						}
					}
				 
					tipTextScrolling = false;
					tipTextStartScrolling();
				}
			}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if(optionShit[curSelected] == 'story_mode')
			{
				char1.dance();
				char1.updateHitbox();
				char1.visible = true;
			}
			else
			{
				char1.visible = false;
			}
		
		if(optionShit[curSelected] == 'freeplay')
			{
				char2.dance();
				char2.updateHitbox();
				char2.visible = true;
			}
			else
			{
				char2.visible = false;
			}
		
		if(optionShit[curSelected] == 'awards')
			{
				char3.dance();
				char3.updateHitbox();
				char3.visible = true;
			}
			else
			{
				char3.visible = false;
			}
		
		if(optionShit[curSelected] == 'credits')
			{
				char4.dance();
				char4.updateHitbox();
				char4.visible = true;
			}
			else
			{
				char4.visible = false;
			}

			if(optionShit[curSelected] == 'options')
				{
					characterLore.dance();
					characterLore.updateHitbox();
					characterLore.visible = true;
				}
				else
				{
					characterLore.visible = false;
				}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
								{
									FlxTween.tween(spr, {alpha: 0}, 0.4, {
										ease: FlxEase.quadOut,
										
									});
									FlxTween.tween(spr, {x : 1500}, 0.4, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											spr.kill();
										}
									});					
								}
							else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
										FlxTween.tween(menuItem, {x: 1500}, 2.0, {ease: FlxEase.expoInOut});
								}
							});
						}
					});
				}	
				FlxTween.tween(camGame, {zoom: 1.5}, 2.0, {ease: FlxEase.expoInOut});
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function tipTextStartScrolling()
		{
			tipText.x = tipTextMargin;
			tipText.y = -tipText.height;
	
			new FlxTimer().start(1.0, function(timer:FlxTimer)
			{
				FlxTween.tween(tipText, {y: tipTextMargin}, 0.3);
				new FlxTimer().start(4.5, function(timer:FlxTimer)
				{
					tipTextScrolling = true;
				});
			});
		}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
