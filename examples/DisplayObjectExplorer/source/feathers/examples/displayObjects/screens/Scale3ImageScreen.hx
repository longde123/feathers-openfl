package feathers.examples.displayObjects.screens;
import feathers.controls.Button;
import feathers.controls.Header;
import feathers.controls.Screen;
import feathers.core.FeathersControl;
import feathers.display.Scale3Image;
import feathers.examples.displayObjects.themes.DisplayObjectExplorerTheme;
import feathers.skins.IStyleProvider;
import feathers.textures.Scale3Textures;
import openfl.Assets;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

class Scale3ImageScreen extends Screen
{
	//[Embed(source="/../assets/images/scale3.png")]
	//inline private static var SCALE_3_TEXTURE:Class<Dynamic>;
	inline private static var SCALE_3_TEXTURE_FILE_NAME = "assets/images/scale3.png";

	public static var globalStyleProvider:IStyleProvider;

	public function new()
	{
		super();
	}

	private var _header:Header;
	private var _image:Scale3Image;
	private var _rightButton:Button;
	private var _bottomButton:Button;

	private var _minDisplayObjectWidth:Float;
	private var _minDisplayObjectHeight:Float;
	private var _maxDisplayObjectWidth:Float;
	private var _maxDisplayObjectHeight:Float;
	private var _startX:Float;
	private var _startY:Float;
	private var _startWidth:Float;
	private var _startHeight:Float;
	private var _rightTouchPointID:Int = -1;
	private var _bottomTouchPointID:Int = -1;

	private var _texture:Texture;

	private var _padding:Float = 0;

	public var padding(get, set):Float;
	public function get_padding():Float
	{
		return this._padding;
	}

	public function set_padding(value:Float):Float
	{
		if(this._padding == value)
		{
			return get_padding();
		}
		this._padding = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		return get_padding();
	}

	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Scale3ImageScreen.globalStyleProvider;
	}

	override public function dispose():Void
	{
		if(this._texture != null)
		{
			this._texture.dispose();
			this._texture = null;
		}
		super.dispose();
	}

	override private function initialize():Void
	{
		this._header = new Header();
		this._header.title = "Scale 3 Image";
		this.addChild(this._header);

		this._texture = Texture.fromBitmapData(Assets.getBitmapData(SCALE_3_TEXTURE_FILE_NAME), false);
		var textures:Scale3Textures = new Scale3Textures(this._texture, 60, 80, Scale3Textures.DIRECTION_HORIZONTAL);
		this._image = new Scale3Image(textures);
		this._image.width /= 2;
		this._image.height /= 2;
		this._minDisplayObjectWidth = this._image.width;
		this._minDisplayObjectHeight = this._image.height;
		this.addChild(this._image);

		this._rightButton = new Button();
		this._rightButton.styleNameList.add(DisplayObjectExplorerTheme.THEME_NAME_RIGHT_GRIP);
		this._rightButton.addEventListener(TouchEvent.TOUCH, rightButton_touchHandler);
		this.addChild(this._rightButton);

		this._bottomButton = new Button();
		this._bottomButton.styleNameList.add(DisplayObjectExplorerTheme.THEME_NAME_BOTTOM_GRIP);
		this._bottomButton.addEventListener(TouchEvent.TOUCH, bottomButton_touchHandler);
		this.addChild(this._bottomButton);
	}

	override private function draw():Void
	{
		this._header.width = this.actualWidth;
		this._header.validate();

		this._image.x = this._padding;
		this._image.y = this._header.height + this._padding;

		this._rightButton.validate();
		this._bottomButton.validate();

		this._maxDisplayObjectWidth = this.actualWidth - this._rightButton.width - this._image.x;
		this._maxDisplayObjectHeight = this.actualHeight - this._bottomButton.height - this._image.y;

		this._image.width = Math.max(this._minDisplayObjectWidth, Math.min(this._maxDisplayObjectWidth, this._image.width));
		this._image.height = Math.max(this._minDisplayObjectHeight, Math.min(this._maxDisplayObjectHeight, this._image.height));

		this.layoutButtons();
	}

	private function layoutButtons():Void
	{
		this._rightButton.x = this._image.x + this._image.width;
		this._rightButton.y = this._image.y + (this._image.height - this._rightButton.height) / 2;

		this._bottomButton.x = this._image.x + (this._image.width - this._bottomButton.width) / 2;
		this._bottomButton.y = this._image.y + this._image.height;
	}

	private function rightButton_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(this._rightButton);
		if(touch == null || (this._rightTouchPointID >= 0 && touch.id != this._rightTouchPointID))
		{
			return;
		}

		if(touch.phase == TouchPhase.BEGAN)
		{
			this._rightTouchPointID = touch.id;
			this._startX = touch.globalX;
			this._startWidth = this._image.width;
		}
		else if(touch.phase == TouchPhase.MOVED)
		{
			this._image.width = Math.min(this._maxDisplayObjectWidth, Math.max(Math.max(this._image.height, this._minDisplayObjectWidth), this._startWidth + touch.globalX - this._startX));
			this.layoutButtons();
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			this._rightTouchPointID = -1;
		}
	}

	private function bottomButton_touchHandler(event:TouchEvent):Void
	{
		var touch:Touch = event.getTouch(this._bottomButton);
		if(touch == null || (this._bottomTouchPointID >= 0 && touch.id != this._bottomTouchPointID))
		{
			return;
		}

		if(touch.phase == TouchPhase.BEGAN)
		{
			this._bottomTouchPointID = touch.id;
			this._startY = touch.globalY;
			this._startHeight = this._image.height;
		}
		else if(touch.phase == TouchPhase.MOVED)
		{
			this._image.height = Math.min(Math.min(this._image.width,  this._maxDisplayObjectHeight), Math.max(this._minDisplayObjectHeight, this._startHeight + touch.globalY - this._startY));
			this.layoutButtons();
		}
		else if(touch.phase == TouchPhase.ENDED)
		{
			this._bottomTouchPointID = -1;
		}
	}
}
