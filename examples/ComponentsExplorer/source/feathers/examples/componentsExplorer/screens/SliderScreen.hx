package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.controls.Slider;
import feathers.examples.componentsExplorer.data.SliderSettings;
import feathers.skins.IStyleProvider;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]//[Event(name="showSettings",type="starling.events.Event")]

@:keep class SliderScreen extends PanelScreen
{
	inline public static var SHOW_SETTINGS:String = "showSettings";

	public static var globalStyleProvider:IStyleProvider;

	public function new()
	{
		super();
	}

	public var settings:SliderSettings;

	private var _horizontalSlider:Slider;
	private var _verticalSlider:Slider;
	private var _backButton:Button;
	private var _settingsButton:Button;

	override private function get_defaultStyleProvider():IStyleProvider
	{
		return SliderScreen.globalStyleProvider;
	}
	
	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this._horizontalSlider = new Slider();
		this._horizontalSlider.direction = Slider.DIRECTION_HORIZONTAL;
		this._horizontalSlider.minimum = 0;
		this._horizontalSlider.maximum = 100;
		this._horizontalSlider.value = 50;
		this._horizontalSlider.step = this.settings.step;
		this._horizontalSlider.page = this.settings.page;
		this._horizontalSlider.liveDragging = this.settings.liveDragging;
		this._horizontalSlider.addEventListener(Event.CHANGE, horizontalSlider_changeHandler);
		this.addChild(this._horizontalSlider);

		this._verticalSlider = new Slider();
		this._verticalSlider.direction = Slider.DIRECTION_VERTICAL;
		this._verticalSlider.minimum = 0;
		this._verticalSlider.maximum = 100;
		this._verticalSlider.value = 50;
		this._verticalSlider.step = this.settings.step;
		this._verticalSlider.page = this.settings.page;
		this._verticalSlider.liveDragging = this.settings.liveDragging;
		this._verticalSlider.addEventListener(Event.CHANGE, horizontalSlider_changeHandler);
		this.addChild(this._verticalSlider);

		this.headerProperties.setProperty("title", "Slider");

		if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
		{
			this._backButton = new Button();
			this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			this._backButton.label = "Back";
			this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

			this.headerProperties.setProperty("leftItems", 
			[
				this._backButton
			]);

			this.backButtonHandler = this.onBackButton;
		}

		this._settingsButton = new Button();
		this._settingsButton.label = "Settings";
		this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

		this.headerProperties.setProperty("rightItems", 
		[
			this._settingsButton
		]);
	}
	
	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}
	
	private function horizontalSlider_changeHandler(event:Event):Void
	{
		trace("slider change:" + this._horizontalSlider.value);
	}
	
	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function settingsButton_triggeredHandler(event:Event):Void
	{
		this.dispatchEventWith(SHOW_SETTINGS);
	}
}