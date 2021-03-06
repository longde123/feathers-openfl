package;
import feathers.examples.transitionsExplorer.Main;
import openfl.errors.Error;
import starling.utils.Max;

import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.filesystem.File;
#if flash
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
#end
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.utils.ByteArray;

import starling.core.Starling;

#if 0
[SWF(width="960",height="640",frameRate="60",backgroundColor="#4a4137")]
#end
class TransitionsExplorer extends Sprite
{
	public function new()
	{
		super();
		if(this.stage != null)
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
		}
		this.mouseEnabled = this.mouseChildren = false;
		#if 0
		this.showLaunchImage();
		this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		#end
		loaderInfo_completeHandler(new Event(Event.COMPLETE));
	}

	private var _starling:Starling;
	private var _launchImage:Loader;

	#if 0
	private function showLaunchImage():Void
	{
		var filePath:String;
		var isPortraitOnly:Bool = false;
		if(Capabilities.manufacturer.indexOf("iOS") >= 0)
		{
			if(Capabilities.screenResolutionX == 1242 && Capabilities.screenResolutionY == 2208)
			{
				//iphone 6 plus
				filePath = "Default-414w-736h-Landscape@3x.png";
			}
			else if(Capabilities.screenResolutionX == 1536 && Capabilities.screenResolutionY == 2048)
			{
				//ipad retina
				filePath = "Default-Landscape@2x.png";
			}
			else if(Capabilities.screenResolutionX == 768 && Capabilities.screenResolutionY == 1024)
			{
				//ipad classic
				filePath = "Default-Landscape.png";
			}
			else if(Capabilities.screenResolutionX == 750)
			{
				//iphone 6
				isPortraitOnly = true;
				filePath = "Default-375w-667h@2x.png";
			}
			else if(Capabilities.screenResolutionX == 640)
			{
				//iphone retina
				isPortraitOnly = true;
				if(Capabilities.screenResolutionY == 1136)
				{
					filePath = "Default-568h@2x.png";
				}
				else
				{
					filePath = "Default@2x.png";
				}
			}
			else if(Capabilities.screenResolutionX == 320)
			{
				//iphone classic
				isPortraitOnly = true;
				filePath = "Default.png";
			}
		}

		if(filePath != null)
		{
			var file:File = File.applicationDirectory.resolvePath(filePath);
			if(file.exists)
			{
				var bytes:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.readBytes(bytes, 0, stream.bytesAvailable);
				stream.close();
				this._launchImage = new Loader();
				this._launchImage.loadBytes(bytes);
				if(isPortraitOnly)
				{
					this._launchImage.rotation = -90;
					this._launchImage.y = Capabilities.screenResolutionX;
				}
				this.addChild(this._launchImage);
			}
		}
	}
	#end

	private function loaderInfo_completeHandler(event:Event):Void
	{
		Starling.multitouchEnabled = true;
		this._starling = new Starling(Main, this.stage, null, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
		this._starling.supportHighResolutions = true;
		this._starling.start();
		if(this._launchImage != null)
		{
			this._starling.addEventListener("rootCreated", starling_rootCreatedHandler);
		}

		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, Max.INT_MAX_VALUE, true);
		this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
	}

	private function starling_rootCreatedHandler(event:Dynamic):Void
	{
		if(this._launchImage != null)
		{
			this.removeChild(this._launchImage);
			this._launchImage.unloadAndStop(true);
			this._launchImage = null;
		}
	}

	private function stage_resizeHandler(event:Event):Void
	{
		this._starling.stage.stageWidth = this.stage.stageWidth;
		this._starling.stage.stageHeight = this.stage.stageHeight;

		var viewPort:Rectangle = this._starling.viewPort;
		viewPort.width = this.stage.stageWidth;
		viewPort.height = this.stage.stageHeight;
		try
		{
			this._starling.viewPort = viewPort;
		}
		catch(error:Error) {}
	}

	private function stage_deactivateHandler(event:Event):Void
	{
		this._starling.stop(true);
		this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
	}

	private function stage_activateHandler(event:Event):Void
	{
		this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
		this._starling.start();
	}

}