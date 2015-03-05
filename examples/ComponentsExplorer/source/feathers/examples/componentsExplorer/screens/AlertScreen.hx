package feathers.examples.componentsExplorer.screens;
import feathers.controls.Alert;
import feathers.controls.Button;
import feathers.controls.PanelScreen;
import feathers.data.ListCollection;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;

@:keep class AlertScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	private var _backButton:Button;
	private var _showAlertButton:Button;

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._showAlertButton = new Button();
		this._showAlertButton.label = "Show Alert";
		this._showAlertButton.addEventListener(Event.TRIGGERED, showAlertButton_triggeredHandler);
		var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
		buttonGroupLayoutData.horizontalCenter = 0;
		buttonGroupLayoutData.verticalCenter = 0;
		this._showAlertButton.layoutData = buttonGroupLayoutData;
		this.addChild(this._showAlertButton);

		this.headerProperties.setProperty("title", "Alert");

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

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function showAlertButton_triggeredHandler(event:Event):Void
	{
		var alert:Alert = Alert.show("I just wanted you to know that I have a very important message to share with you.", "Alert", new ListCollection(
		[
			{ label: "OK" },
			{ label: "Cancel" }
		]));
		alert.addEventListener(Event.CLOSE, alert_closeHandler);
	}

	private function alert_closeHandler(event:Event, data:Dynamic):Void
	{
		if(data != null)
		{
			trace("alert closed with button:" + data.label);
		}
		else
		{
			trace("alert closed without button");
		}
	}
}
