package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var song:FlxSound;
	private var lastBeat:Float;
	private var _box:FlxSprite;
	private var _widthQuart:Float;
	private var _totalBeats:Float = 0;
	private var _totalBars:Float = 0;
	
	
	private var _player:FlxSprite;
	
	private var _tip:FlxText;
	
	private var _position:Int = 0;
	
	private var _scoreText:FlxText;
	private var _score:Float = 0;
	
	private var _creds:FlxText;
	
	var randomInt:Int;
	var _oldInt:Int = 0;
	
	override public function create():Void
	{
		_widthQuart = FlxG.width / 4;
		
		song = new FlxSound();
		song.loadEmbedded("assets/music/729966_Grid-Builder.mp3", true);
		add(song);
		song.play();
		
		lastBeat = 0;
		
		_box = new FlxSprite(FlxG.width, 0);
		_box.makeGraphic(Std.int(_widthQuart), Std.int(_widthQuart));
		add(_box);
		
		_tip = new FlxText(0, 0, 0, "Controls: A S D F \nPress them from left to right\nStay in the larger box", 20);
		_tip.alignment = FlxTextAlign.CENTER;
		_tip.autoSize = false;
		_tip.screenCenter();
		add(_tip);
		
		
		_player = new FlxSprite(0, 140);
		_player.makeGraphic(Std.int(_widthQuart * 0.5), Std.int(_widthQuart * 0.5));
		add(_player);
		
		_scoreText = new FlxText(0, 40, 0, "Score: 0", 25);
		_scoreText.screenCenter(X);
		add(_scoreText);
		
		_creds = new FlxText(5, FlxG.height - 70, 0, "A game by NinjaMuffin99 \nMusic: Alice Mako - Grid Builder", 25);
		add(_creds);
		_creds.y = FlxG.height;
		FlxTween.tween(_creds, {y: _creds.y - 70}, Conductor.crochet * 0.004, {ease:FlxEase.quartOut});
		
		//FlxG.sound.playMusic("assets/music/729966_Grid-Builder.mp3");
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		
		
		FlxG.watch.add(song, "time");
		FlxG.watch.add(this, "lastBeat");
		FlxG.watch.add(Conductor, "crochet");
		FlxG.watch.add(this, "_totalBeats");
		FlxG.watch.add(this, "_totalBars");
		
		Conductor.songPosition = song.time;
		//Every beat
		if (Conductor.songPosition > lastBeat + Conductor.crochet)
		{
			randomInt = FlxG.random.int(0, 3, [_oldInt]);
			_oldInt = randomInt;
			
			lastBeat += Conductor.crochet;
			if (_totalBars >= 3.75)
			{
				_box.color = FlxG.random.color(FlxColor.BLUE, FlxColor.RED);
				
				_box.setPosition(randomInt * _widthQuart, 100);
			}
			
			_totalBeats += 1;
			_totalBars = _totalBeats / 4;
		}
		
		if (_totalBars >= 2 && _totalBars <= 3.75)
		{
			_tip.visible = true;
			_tip.y += 0.1;
		}
		else
		{
			_tip.visible = false;
		}
		
		
		controls();
		
		if (_position == randomInt && _totalBars >= 3.75)
		{
			_score += FlxG.elapsed;
			_score = FlxMath.roundDecimal(_score, 2);
		}
		
		_scoreText.text = "Score: " + _score;
		
		super.update(elapsed);
	}
	
	private function controls():Void
	{
		//controls are hold four buttons down and somethign
		var _bt1:Bool;
		var _bt2:Bool;
		var _bt3:Bool;
		var _bt4:Bool;
		
		
		_bt1 = FlxG.keys.pressed.A;
		_bt2 = FlxG.keys.pressed.S;
		_bt3 = FlxG.keys.pressed.D;
		_bt4 = FlxG.keys.pressed.F;
		
		
		
		if (_bt1)
		{
			_position = 0;
		}
		if (_bt1 && _bt2)
		{
			_position = 1;
		}
		if (_bt1 && _bt2 && _bt3)
		{
			_position = 2;
		}
		if (_bt1 && _bt2 && _bt3 && _bt4)
		{
			_position = 3;
		}
		
		_player.x = (_widthQuart * _position) + ((_box.width - _player.width) / 2);
		
		
		FlxG.watch.add(this, "_position");
	}
}