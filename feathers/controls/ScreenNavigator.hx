/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.IValidating;
import feathers.events.FeathersEventType;
import feathers.skins.IStyleProvider;

import openfl.errors.IllegalOperationError;
import openfl.geom.Rectangle;
import openfl.utils.getDefinitionByName;

import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.ResizeEvent;

/**
 * Dispatched when the active screen changes.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.CHANGE
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the current screen is removed and there is no active
 * screen.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.CLEAR
 *///[Event(name="clear",type="starling.events.Event")]

/**
 * Dispatched when the transition between screens begins.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_START
 *///[Event(name="transitionStart",type="starling.events.Event")]

/**
 * Dispatched when the transition between screens has completed.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType feathers.events.FeathersEventType.TRANSITION_COMPLETE
 *///[Event(name="transitionComplete",type="starling.events.Event")]

/**
 * A "view stack"-like container that supports navigation between screens
 * (any display object) through events.
 *
 * <p>The following example creates a screen navigator, adds a screen and
 * displays it:</p>
 *
 * <listing version="3.0">
 * var navigator:ScreenNavigator = new ScreenNavigator();
 * navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen );
 * this.addChild( navigator );
 *
 * navigator.showScreen( "mainMenu" );</listing>
 *
 * @see http://wiki.starling-framework.org/feathers/screen-navigator
 * @see http://wiki.starling-framework.org/feathers/transitions
 * @see feathers.controls.ScreenNavigatorItem
 */
class ScreenNavigator extends FeathersControl
{
	/**
	 * @private
	 */
	private static var SIGNAL_TYPE:Class<Dynamic>;

	/**
	 * The screen navigator will auto size itself to fill the entire stage.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_STAGE:String = "stage";

	/**
	 * The screen navigator will auto size itself to fit its content.
	 *
	 * @see #autoSizeMode
	 */
	inline public static var AUTO_SIZE_MODE_CONTENT:String = "content";

	/**
	 * The default <code>IStyleProvider</code> for all <code>ScreenNavigator</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * The default transition function.
	 */
	private static function defaultTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Dynamic):Void
	{
		//in short, do nothing
		completeCallback();
	}

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		if(!SIGNAL_TYPE)
		{
			try
			{
				SIGNAL_TYPE = Class(getDefinitionByName("org.osopenfl.signals.ISignal"));
			}
			catch(error:Error)
			{
				//signals not being used
			}
		}
		this.addEventListener(Event.ADDED_TO_STAGE, screenNavigator_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, screenNavigator_removedFromStageHandler);
	}

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return ScreenNavigator.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _activeScreenID:String;

	/**
	 * The string identifier for the currently active screen.
	 */
	public var activeScreenID(get, set):String;
	public function get_activeScreenID():String
	{
		return this._activeScreenID;
	}

	/**
	 * @private
	 */
	private var _activeScreen:DisplayObject;

	/**
	 * A reference to the currently active screen.
	 */
	public var activeScreen(get, set):DisplayObject;
	public function get_activeScreen():DisplayObject
	{
		return this._activeScreen;
	}

	/**
	 * @private
	 */
	private var _clipContent:Bool = false;

	/**
	 * Determines if the navigator's content should be clipped to the width
	 * and height.
	 *
	 * <p>In the following example, clipping is enabled:</p>
	 *
	 * <listing version="3.0">
	 * navigator.clipContent = true;</listing>
	 *
	 * @default false
	 */
	public var clipContent(get, set):Bool;
	public function get_clipContent():Bool
	{
		return this._clipContent;
	}

	/**
	 * @private
	 */
	public function set_clipContent(value:Bool):Bool
	{
		if(this._clipContent == value)
		{
			return;
		}
		this._clipContent = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}

	/**
	 * A function that is called when the <code>ScreenNavigator</code> is
	 * changing screens that is intended to display a transition effect and
	 * to notify the <code>ScreenNavigator</code> when the effect is
	 * finished.
	 *
	 * <p>The function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Dynamic):Void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. It takes zero arguments and
	 * returns nothing. In other words, it has the following signature:</p>
	 *
	 * <pre>function():Void</pre>
	 *
	 * <p>In the future, it may be possible for a transition to cancel
	 * itself. If this happens, the <code>completeCallback</code> may begin
	 * accepting arguments, but they will have default values and existing
	 * uses of <code>completeCallback</code> should continue to work.</p>
	 *
	 * @see #showScreen()
	 * @see #clearScreen()
	 * @see http://wiki.starling-framework.org/feathers/transitions
	 */
	public var transition:Dynamic = defaultTransition;

	/**
	 * @private
	 */
	private var _screens:Dynamic = {};

	/**
	 * @private
	 */
	private var _screenEvents:Dynamic = {};

	/**
	 * @private
	 */
	private var _transitionIsActive:Bool = false;

	/**
	 * @private
	 */
	private var _previousScreenInTransitionID:String;

	/**
	 * @private
	 */
	private var _previousScreenInTransition:DisplayObject;

	/**
	 * @private
	 */
	private var _nextScreenID:String = null;

	/**
	 * @private
	 */
	private var _clearAfterTransition:Bool = false;

	/**
	 * @private
	 */
	private var _autoSizeMode:String = AUTO_SIZE_MODE_STAGE;

	[Inspectable(type="String",enumeration="stage,content")]
	/**
	 * Determines how the screen navigator will set its own size when its
	 * dimensions (width and height) aren't set explicitly.
	 *
	 * <p>In the following example, the screen navigator will be sized to
	 * match its content:</p>
	 *
	 * <listing version="3.0">
	 * navigator.autoSizeMode = ScreenNavigator.AUTO_SIZE_MODE_CONTENT;</listing>
	 *
	 * @default ScreenNavigator.AUTO_SIZE_MODE_STAGE
	 *
	 * @see #AUTO_SIZE_MODE_STAGE
	 * @see #AUTO_SIZE_MODE_CONTENT
	 */
	public var autoSizeMode(get, set):String;
	public function get_autoSizeMode():String
	{
		return this._autoSizeMode;
	}

	/**
	 * @private
	 */
	public function set_autoSizeMode(value:String):String
	{
		if(this._autoSizeMode == value)
		{
			return;
		}
		this._autoSizeMode = value;
		if(this._activeScreen)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
			{
				this._activeScreen.addEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
			}
			else
			{
				this._activeScreen.removeEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
			}
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * Displays a screen and returns a reference to it. If a previous
	 * transition is running, the new screen will be queued, and no
	 * reference will be returned.
	 */
	public function showScreen(id:String):DisplayObject
	{
		if(!this._screens.hasOwnProperty(id))
		{
			throw new IllegalOperationError("Screen with id '" + id + "' cannot be shown because it has not been defined.");
		}

		if(this._transitionIsActive)
		{
			this._nextScreenID = id;
			this._clearAfterTransition = false;
			return null;
		}

		if(this._activeScreenID == id)
		{
			return this._activeScreen;
		}

		this._previousScreenInTransition = this._activeScreen;
		this._previousScreenInTransitionID = this._activeScreenID;
		if(this._activeScreen)
		{
			this.clearScreenInternal(false);
		}
		
		this._transitionIsActive = true;

		var item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[id]);
		this._activeScreen = item.getScreen();
		if(Std.is(this._activeScreen, IScreen))
		{
			var screen:IScreen = IScreen(this._activeScreen);
			screen.screenID = id;
			screen.owner = this;
		}
		this._activeScreenID = id;

		var events:Dynamic = item.events;
		var savedScreenEvents:Dynamic = {};
		for (eventName in events)
		{
			var signal:Dynamic = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as SIGNAL_TYPE) : null;
			var eventAction:Dynamic = events[eventName];
			if(Std.is(eventAction, Function))
			{
				if(signal)
				{
					signal.addcast(eventAction, Function);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, eventAction as Function);
				}
			}
			else if(Std.is(eventAction, String))
			{
				if(signal)
				{
					var eventListener:Dynamic = this.createScreenSignalListener(eventAction as String, signal);
					signal.add(eventListener);
				}
				else
				{
					eventListener = this.createScreenEventListenercast(eventAction, String);
					this._activeScreen.addEventListener(eventName, eventListener);
				}
				savedScreenEvents[eventName] = eventListener;
			}
			else
			{
				throw new TypeError("Unknown event action defined for screen:", eventAction.toString());
			}
		}

		this._screenEvents[id] = savedScreenEvents;

		if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
		{
			this._activeScreen.addEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
		}
		this.addChild(this._activeScreen);

		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
		if(this._validationQueue && !this._validationQueue.isValidating)
		{
			//force a COMPLETE validation of everything
			//but only if we're not already doing that...
			this._validationQueue.advanceTime(0);
		}

		this.dispatchEventWith(FeathersEventType.TRANSITION_START);
		this.transition(this._previousScreenInTransition, this._activeScreen, transitionComplete);

		this.dispatchEventWith(Event.CHANGE);
		return this._activeScreen;
	}

	/**
	 * Removes the current screen, leaving the <code>ScreenNavigator</code>
	 * empty.
	 */
	public function clearScreen():Void
	{
		if(this._transitionIsActive)
		{
			this._nextScreenID = null;
			this._clearAfterTransition = true;
			return;
		}

		this.clearScreenInternal(true);
		this.dispatchEventWith(FeathersEventType.CLEAR);
	}

	/**
	 * @private
	 */
	private function clearScreenInternal(displayTransition:Bool):Void
	{
		if(!this._activeScreen)
		{
			//no screen visible.
			return;
		}

		var item:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[this._activeScreenID]);
		var events:Dynamic = item.events;
		var savedScreenEvents:Dynamic = this._screenEvents[this._activeScreenID];
		for (eventName in events)
		{
			var signal:Dynamic = this._activeScreen.hasOwnProperty(eventName) ? (this._activeScreen[eventName] as SIGNAL_TYPE) : null;
			var eventAction:Dynamic = events[eventName];
			if(Std.is(eventAction, Function))
			{
				if(signal)
				{
					signal.removecast(eventAction, Function);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, eventAction as Function);
				}
			}
			else if(Std.is(eventAction, String))
			{
				var eventListener:Dynamic = savedScreenEvents[eventName] as Function;
				if(signal)
				{
					signal.remove(eventListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, eventListener);
				}
			}
		}

		if(displayTransition)
		{
			this._transitionIsActive = true;
			this._previousScreenInTransition = this._activeScreen;
			this._previousScreenInTransitionID = this._activeScreenID;
		}
		this._screenEvents[this._activeScreenID] = null;
		this._activeScreen = null;
		this._activeScreenID = null;
		if(displayTransition)
		{
			this.transition(this._previousScreenInTransition, null, transitionComplete);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SELECTED);
	}

	/**
	 * Registers a new screen by its identifier.
	 */
	public function addScreen(id:String, item:ScreenNavigatorItem):Void
	{
		if(this._screens.hasOwnProperty(id))
		{
			throw new IllegalOperationError("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
		}

		this._screens[id] = item;
	}

	/**
	 * Removes an existing screen using its identifier.
	 */
	public function removeScreen(id:String):Void
	{
		if(!this._screens.hasOwnProperty(id))
		{
			throw new IllegalOperationError("Screen '" + id + "' cannot be removed because it has not been added.");
		}
		if(this._activeScreenID == id)
		{
			this.clearScreen();
		}
		delete this._screens[id];
	}

	/**
	 * Removes all screens.
	 */
	public function removeAllScreens():Void
	{
		this.clearScreen();
		for (id in this._screens)
		{
			delete this._screens[id];
		}
	}

	/**
	 * Determines if the specified screen identifier has been added.
	 */
	public function hasScreen(id:String):Bool
	{
		return this._screens.hasOwnProperty(id);
	}

	/**
	 * Returns the <code>ScreenNavigatorItem</code> instance with the
	 * specified identifier.
	 */
	public function getScreen(id:String):ScreenNavigatorItem
	{
		if(this._screens.hasOwnProperty(id))
		{
			return ScreenNavigatorItem(this._screens[id]);
		}
		return null;
	}

	/**
	 * Returns a list of the screen identifiers that have been added.
	 */
	public function getScreenIDs(result:Array<String> = null):Array<String>
	{
		if(!result)
		{
			result = new Array();
		}

		for (id in this._screens)
		{
			result.push(id);
		}
		return result;
	}

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		this.clearScreenInternal(false);
		super.dispose();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var selectionInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SELECTED);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		if(sizeInvalid || selectionInvalid)
		{
			if(this._activeScreen)
			{
				if(this._activeScreen.width != this.actualWidth)
				{
					this._activeScreen.width = this.actualWidth;
				}
				if(this._activeScreen.height != this.actualHeight)
				{
					this._activeScreen.height = this.actualHeight;
				}
			}
		}

		if(stylesInvalid || sizeInvalid)
		{
			if(this._clipContent)
			{
				var clipRect:Rectangle = this.clipRect;
				if(!clipRect)
				{
					clipRect = new Rectangle();
				}
				clipRect.width = this.actualWidth;
				clipRect.height = this.actualHeight;
				this.clipRect = clipRect;
			}
			else
			{
				this.clipRect = null;
			}
		}
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		if((this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage) &&
			this._activeScreen is IValidating)
		{
			IValidating(this._activeScreen).validate();
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
			{
				newWidth = this._activeScreen ? this._activeScreen.width : 0;
			}
			else
			{
				newWidth = this.stage.stageWidth;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT || !this.stage)
			{
				newHeight = this._activeScreen ? this._activeScreen.height : 0;
			}
			else
			{
				newHeight = this.stage.stageHeight;
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * @private
	 */
	private function transitionComplete():Void
	{
		this._transitionIsActive = false;
		this.dispatchEventWith(FeathersEventType.TRANSITION_COMPLETE);
		if(this._previousScreenInTransition)
		{
			var item:ScreenNavigatorItem = this._screens[this._previousScreenInTransitionID];
			var canBeDisposed:Bool = !(Std.is(item.screen, DisplayObject));
			if(Std.is(this._previousScreenInTransition, IScreen))
			{
				var screen:IScreen = IScreen(this._previousScreenInTransition);
				screen.screenID = null;
				screen.owner = null;
			}
			this._previousScreenInTransition.removeEventListener(FeathersEventType.RESIZE, activeScreen_resizeHandler);
			this.removeChild(this._previousScreenInTransition, canBeDisposed);
			this._previousScreenInTransition = null;
			this._previousScreenInTransitionID = null;
		}

		if(this._clearAfterTransition)
		{
			this.clearScreen();
		}
		else if(this._nextScreenID)
		{
			this.showScreen(this._nextScreenID);
		}

		this._nextScreenID = null;
		this._clearAfterTransition = false;
	}

	/**
	 * @private
	 */
	private function createScreenEventListener(screenID:String):Dynamic
	{
		var self:ScreenNavigator = this;
		var eventListener:Dynamic = function(event:Event):Void
		{
			self.showScreen(screenID);
		};

		return eventListener;
	}

	/**
	 * @private
	 */
	private function createScreenSignalListener(screenID:String, signal:Dynamic):Dynamic
	{
		var self:ScreenNavigator = this;
		if(signal.valueClasses.length == 1)
		{
			//shortcut to avoid the allocation of the rest array
			var signalListener:Dynamic = function(arg0:Dynamic):Void
			{
				self.showScreen(screenID);
			};
		}
		else
		{
			signalListener = function(...rest:Array):Void
			{
				self.showScreen(screenID);
			};
		}

		return signalListener;
	}

	/**
	 * @private
	 */
	private function screenNavigator_addedToStageHandler(event:Event):Void
	{
		this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function screenNavigator_removedFromStageHandler(event:Event):Void
	{
		this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
	}

	/**
	 * @private
	 */
	private function activeScreen_resizeHandler(event:Event):Void
	{
		if(this._isValidating || this._autoSizeMode != AUTO_SIZE_MODE_CONTENT)
		{
			return;
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}

	/**
	 * @private
	 */
	private function stage_resizeHandler(event:ResizeEvent):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
	}
}

}