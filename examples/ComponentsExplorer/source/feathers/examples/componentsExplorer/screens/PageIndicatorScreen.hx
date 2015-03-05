package feathers.examples.componentsExplorer.screens;
import feathers.controls.Button;
import feathers.controls.PageIndicator;
import feathers.controls.PanelScreen;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

@:keep class PageIndicatorScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	private var _backButton:Button;
	private var _pageIndicator:PageIndicator;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._pageIndicator = new PageIndicator();
		this._pageIndicator.pageCount = 5;
		this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
		var pageIndicatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
		pageIndicatorLayoutData.left = 0;
		pageIndicatorLayoutData.right = 0;
		pageIndicatorLayoutData.verticalCenter = 0;
		this._pageIndicator.layoutData = pageIndicatorLayoutData;
		this.addChild(this._pageIndicator);

		this.headerProperties.setProperty("title", "Page Indicator");

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
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function pageIndicator_changeHandler(event:Event):Void
	{
		trace("page indicator change:", this._pageIndicator.selectedIndex);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}
}
