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
import flixel.util.FlxTimer;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import openfl.Lib;
import WeekData;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;
    public static var saveCurSelected:Int = 0;

	private static var lastDifficultyName:String = '';

	var menuItems:FlxTypedGroup<FlxSprite>;
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var camOther:FlxCamera;
	private var camAchievement:FlxCamera;

	var loadedWeeks:Array<WeekData> = [];
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		//'donate',
		'options'
	];

	var optionShitX:Array<Int> = [
		0,
		50,
		//0,
		//0,
		900,
		//0,
		950
	];

	var optionShitY:Array<Int> = [
		0,
		380,
		//0,
		//0,
		270,
		//0,
		600
	];
	var optionShitSize:Array<Float> = [
		0.4,
		0.2,
		//0,
		//0,
		0.4,
		//0,
		0.2
	];

	#if MODS_ALLOWED
	var customOption:String;
	var	customOptionLink:String;
	#end

	var curDifficulty:Int = 0;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var optionTween:Array<FlxTween> = [];
	var cameraTween:Array<FlxTween> = [];

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();
		#if desktop
		// Updating Discord Rich Presence

		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		//camera.zoom = 1.85;

		WeekData.reloadWeekFiles(true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		

		bg.scrollFactor.set(0, 0);

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

		var scale:Float = 0.6;
		//if(optionShit.length > 6) {
			//scale = 6 / optionShit.length;
		//}
		var curoffset:Float = 100;

		for (i in 0...optionShit.length)
		{
			
			var menuItem:FlxSprite = new FlxSprite(optionShitX[i], optionShitY[i]);
			menuItem.scale.x = optionShitSize[i];
			menuItem.scale.y = optionShitSize[i];
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 14);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			
			if (menuItem.ID == curSelected){
			menuItem.animation.play('selected');
			menuItem.updateHitbox();
			}
		}

		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			loadedWeeks.push(weekFile);
			WeekData.setDirectoryFromWeek(weekFile);
		}

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		
		//for (i in 0...optionShit.length)
		//{
			//var option:FlxSprite = menuItems.members[i];
			
			//if (optionShit.length % 2 == 0){
			    //option.y = 360 + (i - optionShit.length / 1) * 110+150;
			    //option.y += 20;
			//}else{
			    //option.y = 360 + (i - (optionShit.length / 1 + 0.5)) * 135+150;
			//}
				//optionTween[i] = FlxTween.tween(option, {x: 100}, 0.7 + 0.08 * i , {
					//ease: FlxEase.backInOut
			    //});
		//}

		//FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(0 , FlxG.height - 44, 0, "Salty Engine demo", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(0, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		// NG.core.calls.event.logEvent('swag').send();

		checkChoose();
        
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
        
		#if !mobile
		FlxG.mouse.visible = true;
	    //#else
	    //FlxG.mouse.visible = false;
	    #end
        
		super.create();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModMenuItemsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var menuitemsFile:String = null;
		if(folder != null && folder.trim().length > 0) menuitemsFile = Paths.mods(folder + '/data/menuitems.txt');
		else menuitemsFile = Paths.mods('data/menuitems.txt');

		if (FileSystem.exists(menuitemsFile))
		{
			var firstarray:Array<String> = File.getContent(menuitemsFile).split('\n');
			if (firstarray[0].length > 0) {
				var arr:Array<String> = firstarray[0].split('||');
				//if(arr.length == 1) arr.push(folder);
				optionShit.push(arr[0]);
				customOption = arr[0];
				customOptionLink = arr[1];
			}
		}
		modsAdded.push(folder);
	}
	#end


	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var canClick:Bool = true;
	var canBeat:Bool = true;
	var usingMouse:Bool = true;
	var selectedWeek:Bool = false;
	
	var endCheck:Bool = false;

	override function update(elapsed:Float)
	{
	

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.mouse.justPressed) usingMouse = true;
		
        if(!endCheck){
		
		
		if (controls.UI_UP_P)
			{
				usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));				
				curSelected--;
				checkChoose();
			}

			if (controls.UI_DOWN_P)
			{
			    usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected++;
				checkChoose();
			}
			
			    
			if (controls.ACCEPT) {
			    usingMouse = false;

			    menuItems.forEach(function(spr:FlxSprite)
		        {
		            if (curSelected == spr.ID){
        				if (spr.animation.curAnim.name == 'selected') {
        				    canClick = false;
        				    checkChoose();
        				    selectSomething();
            			} else {
            			    FlxG.sound.play(Paths.sound('scrollMenu'));	
            			    spr.animation.play('selected');
            			}
        			}
    			});
		    }
		    
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (usingMouse && canClick)
			{
				if (!FlxG.mouse.overlaps(spr)) {
				    if (FlxG.mouse.pressed
				    #if mobile && !FlxG.mouse.overlaps(virtualPad.buttonA) #end){
        			    spr.animation.play('idle');
    			    }
				    if (FlxG.mouse.justReleased 
				    #if mobile && !FlxG.mouse.overlaps(virtualPad.buttonA) #end){
					    spr.animation.play('idle');			        			        
			        } //work better for use virtual pad
			    }
    			if (FlxG.mouse.overlaps(spr)){
    			    if (FlxG.mouse.justPressed){
    			        if (spr.animation.curAnim.name == 'selected') selectSomething();
    			        else spr.animation.play('idle');
    			    }
					curSelected = spr.ID;
				
					if (spr.animation.curAnim.name == 'idle'){
						FlxG.sound.play(Paths.sound('scrollMenu'));	 
						spr.animation.play('selected');		
					}	
					
					menuItems.forEach(function(spr:FlxSprite){
						if (spr.ID != curSelected)
						{
							spr.animation.play('idle');
							//spr.centerOffsets();
						}
					});
    			    			    
			    }			    
			    if(saveCurSelected != curSelected) checkChoose();
			}
		});
		
			if (controls.BACK)
			{
				endCheck = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}		
					
        }

		menuItems.forEach(function(spr:FlxSprite)
		{
		    spr.updateHitbox();
		    //spr.centerOffsets();
		    //spr.centerOrigin();
		});
		
		
		
		super.update(elapsed);
	}    	

	function selectWeek()
	{	
		// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
		var songArray:Array<String> = [];
		var leWeek:Array<Dynamic> = loadedWeeks[0].songs;
		for (i in 0...leWeek.length) {
			songArray.push(leWeek[i][0]);
		}

		// Nevermind that's stupid lmao
		PlayState.storyPlaylist = songArray;
		PlayState.isStoryMode = true;
		selectedWeek = true;

		var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		});
	}
    
    function selectSomething()
	{
		endCheck = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		canClick = false;				
		
		//for (i in 0...optionShit.length)
		//{
			//var option:FlxSprite = menuItems.members[i];
			//if(optionTween[i] != null) optionTween[i].cancel();
			//if( i != curSelected)
				//optionTween[i] = FlxTween.tween(option, {x: -800}, 0.6 + 0.1 * Math.abs(curSelected - i ), {
					//ease: FlxEase.backInOut,
					//onComplete: function(twn:FlxTween)
					//{
						//option.kill();
					//}
			    //}); 
		//}
		
		if (cameraTween[0] != null) cameraTween[0].cancel();

		menuItems.forEach(function(spr:FlxSprite)
		{
			//if (curSelected == spr.ID)
			//{				
				
				//spr.animation.play('selected');
			    //var scr:Float = (optionShit.length - 4) * 0.135;
			    //if(optionShit.length < 6) scr = 0;
			    //FlxTween.tween(spr, {y: 360 - spr.height / 2}, 0.6, {
					//ease: FlxEase.backInOut
			    //});
			
			    //FlxTween.tween(spr, {x: 640 - spr.width / 2}, 0.6, {
					//ease: FlxEase.backInOut				
				//});													
			//}
		});
		
		FlxTween.tween(camGame, {angle: 0}, 0.8, { //not use for now
		        ease: FlxEase.cubeInOut,
		        onComplete: function(twn:FlxTween)
				{
			    var daChoice:String = optionShit[curSelected];

				   switch (daChoice)
					{
						case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
								//selectWeek();
							case 'freeplay':
							    MusicBeatState.switchState(new FreeplayState());
							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new options.OptionsState());
				    }
				}
		});
	}


	
	function checkChoose()
	{
	    if (curSelected >= menuItems.length)
	        curSelected = 0;
		if (curSelected < 0)
		    curSelected = menuItems.length - 1;
		    
		saveCurSelected = curSelected;
		    
	    menuItems.forEach(function(spr:FlxSprite){
	        if (spr.ID != curSelected)
			{
			    spr.animation.play('idle');
			    //spr.centerOffsets();
		    }			

            if (spr.ID == curSelected && spr.animation.curAnim.name != 'selected')
			{
			    spr.animation.play('selected');
			    //spr.centerOffsets();
		    }
		    
		    spr.updateHitbox();
        });        
	}
}