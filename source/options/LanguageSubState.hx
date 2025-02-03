package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class LanguageSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Language';
		rpcTitle = 'Language Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Select a language: ',
		    "选择一个你看得懂的语言：",
			'changeLanguages',
			'string',
			'Chinese',
			['Chinese', 'English']);
		addOption(option);

		var option:Option = new Option('In development',
		    '没别的，语言选项还在开发，你支持我们吗？',
			'niceShit',
			'bool',
			false);
		addOption(option);

		super();
	}
}
