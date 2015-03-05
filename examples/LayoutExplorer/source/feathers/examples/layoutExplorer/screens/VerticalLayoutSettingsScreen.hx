package feathers.examples.layoutExplorer.screens;
import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.NumericStepper;
import feathers.controls.PanelScreen;
import feathers.controls.PickerList;
import feathers.data.ListCollection;
import feathers.examples.layoutExplorer.data.VerticalLayoutSettings;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.VerticalLayout;

import starling.display.DisplayObject;
import starling.events.Event;
//[Event(name="complete",type="starling.events.Event")]

@:keep class VerticalLayoutSettingsScreen extends PanelScreen
{
	public function new()
	{
		super();
	}

	public var settings:VerticalLayoutSettings;

	private var _list:List;
	private var _backButton:Button;

	private var _itemCountStepper:NumericStepper;
	private var _gapStepper:NumericStepper;
	private var _paddingTopStepper:NumericStepper;
	private var _paddingRightStepper:NumericStepper;
	private var _paddingBottomStepper:NumericStepper;
	private var _paddingLeftStepper:NumericStepper;
	private var _horizontalAlignPicker:PickerList;
	private var _verticalAlignPicker:PickerList;

	override public function dispose():Void
	{
		//icon and accessory display objects in the list's data provider
		//won't be automatically disposed because feathers cannot know if
		//they need to be used again elsewhere or not. we need to dispose
		//them manually.
		this._list.dataProvider.dispose(disposeItemAccessory);

		//never forget to call super.dispose() because you don't want to
		//create a memory leak!
		super.dispose();
	}

	override private function initialize():Void
	{
		//never forget to call super.initialize()
		super.initialize();

		this.layout = new AnchorLayout();

		this._itemCountStepper = new NumericStepper();
		this._itemCountStepper.minimum = 1;
		//the layout can certainly handle more. this value is arbitrary.
		this._itemCountStepper.maximum = 100;
		this._itemCountStepper.step = 1;
		this._itemCountStepper.value = this.settings.itemCount;
		this._itemCountStepper.addEventListener(Event.CHANGE, itemCountStepper_changeHandler);

		this._horizontalAlignPicker = new PickerList();
		this._horizontalAlignPicker.typicalItem = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
		this._horizontalAlignPicker.dataProvider = new ListCollection(
		[
			VerticalLayout.HORIZONTAL_ALIGN_LEFT,
			VerticalLayout.HORIZONTAL_ALIGN_CENTER,
			VerticalLayout.HORIZONTAL_ALIGN_RIGHT,
			VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY
		]);
		this._horizontalAlignPicker.selectedItem = this.settings.horizontalAlign;
		this._horizontalAlignPicker.addEventListener(Event.CHANGE, horizontalAlignPicker_changeHandler);

		this._verticalAlignPicker = new PickerList();
		this._verticalAlignPicker.typicalItem = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
		this._verticalAlignPicker.dataProvider = new ListCollection(
		[
			VerticalLayout.VERTICAL_ALIGN_TOP,
			VerticalLayout.VERTICAL_ALIGN_MIDDLE,
			VerticalLayout.VERTICAL_ALIGN_BOTTOM
		]);
		this._verticalAlignPicker.selectedItem = this.settings.verticalAlign;
		this._verticalAlignPicker.addEventListener(Event.CHANGE, verticalAlignPicker_changeHandler);

		this._gapStepper = new NumericStepper();
		this._gapStepper.minimum = 0;
		//these maximum values are completely arbitrary
		this._gapStepper.maximum = 100;
		this._gapStepper.step = 1;
		this._gapStepper.value = this.settings.gap;
		this._gapStepper.addEventListener(Event.CHANGE, gapStepper_changeHandler);

		this._paddingTopStepper = new NumericStepper();
		this._paddingTopStepper.minimum = 0;
		this._paddingTopStepper.maximum = 100;
		this._paddingTopStepper.step = 1;
		this._paddingTopStepper.value = this.settings.paddingTop;
		this._paddingTopStepper.addEventListener(Event.CHANGE, paddingTopStepper_changeHandler);

		this._paddingRightStepper = new NumericStepper();
		this._paddingRightStepper.minimum = 0;
		this._paddingRightStepper.maximum = 100;
		this._paddingRightStepper.step = 1;
		this._paddingRightStepper.value = this.settings.paddingRight;
		this._paddingRightStepper.addEventListener(Event.CHANGE, paddingRightStepper_changeHandler);

		this._paddingBottomStepper = new NumericStepper();
		this._paddingBottomStepper.minimum = 0;
		this._paddingBottomStepper.maximum = 100;
		this._paddingBottomStepper.step = 1;
		this._paddingBottomStepper.value = this.settings.paddingBottom;
		this._paddingBottomStepper.addEventListener(Event.CHANGE, paddingBottomStepper_changeHandler);

		this._paddingLeftStepper = new NumericStepper();
		this._paddingLeftStepper.minimum = 0;
		this._paddingLeftStepper.maximum = 100;
		this._paddingLeftStepper.step = 1;
		this._paddingLeftStepper.value = this.settings.paddingLeft;
		this._paddingLeftStepper.addEventListener(Event.CHANGE, paddingLeftStepper_changeHandler);

		this._list = new List();
		this._list.isSelectable = false;
		this._list.dataProvider = new ListCollection(
		[
			{ label: "Item Count", accessory: this._itemCountStepper },
			{ label: "horizontalAlign", accessory: this._horizontalAlignPicker },
			{ label: "verticalAlign", accessory: this._verticalAlignPicker },
			{ label: "gap", accessory: this._gapStepper },
			{ label: "paddingTop", accessory: this._paddingTopStepper },
			{ label: "paddingRight", accessory: this._paddingRightStepper },
			{ label: "paddingBottom", accessory: this._paddingBottomStepper },
			{ label: "paddingLeft", accessory: this._paddingLeftStepper },
		]);
		this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
		this.addChild(this._list);

		this._backButton = new Button();
		this._backButton.styleNameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
		this._backButton.label = "Back";
		this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

		this.headerProperties.setProperty("title", "Vertical Layout Settings");
		this.headerProperties.setProperty("leftItems",
		[
			this._backButton
		]);

		this.backButtonHandler = this.onBackButton;
	}

	private function disposeItemAccessory(item:Dynamic):Void
	{
		cast(item.accessory, DisplayObject).dispose();
	}

	private function onBackButton():Void
	{
		this.dispatchEventWith(Event.COMPLETE);
	}

	private function backButton_triggeredHandler(event:Event):Void
	{
		this.onBackButton();
	}

	private function itemCountStepper_changeHandler(event:Event):Void
	{
		this.settings.itemCount = Std.int(this._itemCountStepper.value);
	}

	private function horizontalAlignPicker_changeHandler(event:Event):Void
	{
		this.settings.horizontalAlign = cast(this._horizontalAlignPicker.selectedItem, String);
	}

	private function verticalAlignPicker_changeHandler(event:Event):Void
	{
		this.settings.verticalAlign = cast(this._verticalAlignPicker.selectedItem, String);
	}

	private function gapStepper_changeHandler(event:Event):Void
	{
		this.settings.gap = this._gapStepper.value;
	}

	private function paddingTopStepper_changeHandler(event:Event):Void
	{
		this.settings.paddingTop = this._paddingTopStepper.value;
	}

	private function paddingRightStepper_changeHandler(event:Event):Void
	{
		this.settings.paddingRight = this._paddingRightStepper.value;
	}

	private function paddingBottomStepper_changeHandler(event:Event):Void
	{
		this.settings.paddingBottom = this._paddingBottomStepper.value;
	}

	private function paddingLeftStepper_changeHandler(event:Event):Void
	{
		this.settings.paddingLeft = this._paddingLeftStepper.value;
	}
}
