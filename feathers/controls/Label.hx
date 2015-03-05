/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls;
import feathers.core.FeathersControl;
import feathers.core.ITextBaselineControl;
import feathers.core.ITextRenderer;
import feathers.core.PropertyProxy;
import feathers.skins.IStyleProvider;

import openfl.geom.Point;

import starling.display.DisplayObject;

/**
 * Displays text.
 *
 * @see http://wiki.starling-framework.org/feathers/label
 * @see http://wiki.starling-framework.org/feathers/text-renderers
 */
class Label extends FeathersControl implements ITextBaselineControl
{
	/**
	 * @private
	 */
	private static var HELPER_POINT:Point = new Point();

	/**
	 * An alternate name to use with <code>Label</code> to allow a theme to
	 * give it a larger style meant for headings. If a theme does not provide
	 * a skin for the heading style, the theme will automatically fall back
	 * to using the default label skin.
	 *
	 * <p>An alternate name should always be added to a component's
	 * <code>styleNameList</code> before the component is added to the stage for
	 * the first time. If it is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the heading style is applied to a label:</p>
	 *
	 * <listing version="3.0">
	 * var label:Label = new Label();
	 * label.text = "Very Important Heading";
	 * label.styleNameList.add( Label.ALTERNATE_NAME_HEADING );
	 * this.addChild( label );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_NAME_HEADING:String = "feathers-heading-label";

	/**
	 * An alternate name to use with <code>Label</code> to allow a theme to
	 * give it a smaller style meant for less-important details. If a theme
	 * does not provide a skin for the detail style, the theme will
	 * automatically fall back to using the default label skin.
	 *
	 * <p>An alternate name should always be added to a component's
	 * <code>styleNameList</code> before the component is added to the stage for
	 * the first time. If it is added later, it will be ignored.</p>
	 *
	 * <p>In the following example, the detail style is applied to a label:</p>
	 *
	 * <listing version="3.0">
	 * var label:Label = new Label();
	 * label.text = "Less important, detailed text";
	 * label.styleNameList.add( Label.ALTERNATE_NAME_DETAIL );
	 * this.addChild( label );</listing>
	 *
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	inline public static var ALTERNATE_NAME_DETAIL:String = "feathers-detail-label";

	/**
	 * The default <code>IStyleProvider</code> for all <code>Label</code>
	 * components.
	 *
	 * @default null
	 * @see feathers.core.FeathersControl#styleProvider
	 */
	public static var globalStyleProvider:IStyleProvider;

	/**
	 * Constructor.
	 */
	public function new()
	{
		super();
		this.isQuickHitAreaEnabled = true;
	}

	/**
	 * The text renderer.
	 *
	 * @see #createTextRenderer()
	 * @see #textRendererFactory
	 */
	private var textRenderer:ITextRenderer;

	/**
	 * @private
	 */
	override private function get_defaultStyleProvider():IStyleProvider
	{
		return Label.globalStyleProvider;
	}

	/**
	 * @private
	 */
	private var _text:String = null;

	/**
	 * The text displayed by the label.
	 *
	 * <p>In the following example, the label's text is updated:</p>
	 *
	 * <listing version="3.0">
	 * label.text = "Hello World";</listing>
	 *
	 * @default null
	 */
	public var text(get, set):String;
	public function get_text():String
	{
		return this._text;
	}

	/**
	 * @private
	 */
	public function set_text(value:String):String
	{
		if(this._text == value)
		{
			return get_text();
		}
		this._text = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		return get_text();
	}

	/**
	 * @private
	 */
	private var _wordWrap:Bool = false;

	/**
	 * Determines if the text wraps to the next line when it reaches the
	 * width of the component.
	 *
	 * <p>In the following example, the label's text is wrapped:</p>
	 *
	 * <listing version="3.0">
	 * label.wordWrap = true;</listing>
	 *
	 * @default false
	 */
	public var wordWrap(get, set):Bool;
	public function get_wordWrap():Bool
	{
		return this._wordWrap;
	}

	/**
	 * @private
	 */
	public function set_wordWrap(value:Bool):Bool
	{
		if(this._wordWrap == value)
		{
			return get_wordWrap();
		}
		this._wordWrap = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_wordWrap();
	}

	/**
	 * The baseline measurement of the text, in pixels.
	 */
	public var baseline(get, never):Float;
	public function get_baseline():Float
	{
		if(this.textRenderer == null)
		{
			return 0;
		}
		return this.textRenderer.y + this.textRenderer.baseline;
	}

	/**
	 * @private
	 */
	private var _textRendererFactory:Void->ITextRenderer;

	/**
	 * A function used to instantiate the label's text renderer
	 * sub-component. By default, the label will use the global text
	 * renderer factory, <code>FeathersControl.defaultTextRendererFactory()</code>,
	 * to create the text renderer. The text renderer must be an instance of
	 * <code>ITextRenderer</code>. This factory can be used to change
	 * properties on the text renderer when it is first created. For
	 * instance, if you are skinning Feathers components without a theme,
	 * you might use this factory to style the text renderer.
	 *
	 * <p>The factory should have the following function signature:</p>
	 * <pre>function():ITextRenderer</pre>
	 *
	 * <p>In the following example, a custom text renderer factory is passed
	 * to the label:</p>
	 *
	 * <listing version="3.0">
	 * label.textRendererFactory = function():ITextRenderer
	 * {
	 *     return new TextFieldTextRenderer();
	 * }</listing>
	 *
	 * @default null
	 *
	 * @see feathers.core.ITextRenderer
	 * @see feathers.core.FeathersControl#defaultTextRendererFactory
	 */
	public var textRendererFactory(get, set):Void->ITextRenderer;
	public function get_textRendererFactory():Void->ITextRenderer
	{
		return this._textRendererFactory;
	}

	/**
	 * @private
	 */
	public function set_textRendererFactory(value:Void->ITextRenderer):Void->ITextRenderer
	{
		if(this._textRendererFactory == value)
		{
			return get_textRendererFactory();
		}
		this._textRendererFactory = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);
		return get_textRendererFactory();
	}

	/**
	 * @private
	 */
	private var _textRendererProperties:PropertyProxy;

	/**
	 * A set of key/value pairs to be passed down to the text renderer. The
	 * text renderer is an <code>ITextRenderer</code> instance. The
	 * available properties depend on which <code>ITextRenderer</code>
	 * implementation is returned by <code>textRendererFactory</code>. The
	 * most common implementations are <code>BitmapFontTextRenderer</code>
	 * and <code>TextFieldTextRenderer</code>.
	 *
	 * <p>If the subcomponent has its own subcomponents, their properties
	 * can be set too, using attribute <code>&#64;</code> notation. For example,
	 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
	 * which is in a <code>List</code>, you can use the following syntax:</p>
	 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
	 *
	 * <p>Setting properties in a <code>textRendererFactory</code> function
	 * instead of using <code>textRendererProperties</code> will result in
	 * better performance.</p>
	 *
	 * <p>In the following example, the label's text renderer's properties
	 * are updated (this example assumes that the label text renderer is a
	 * <code>TextFieldTextRenderer</code>):</p>
	 *
	 * <listing version="3.0">
	 * label.textRendererProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
	 * label.textRendererProperties.embedFonts = true;</listing>
	 *
	 * @default null
	 *
	 * @see #textRendererFactory
	 * @see feathers.core.ITextRenderer
	 * @see feathers.controls.text.BitmapFontTextRenderer
	 * @see feathers.controls.text.TextFieldTextRenderer
	 */
	public var textRendererProperties(get, set):PropertyProxy;
	public function get_textRendererProperties():PropertyProxy
	{
		if(this._textRendererProperties == null)
		{
			this._textRendererProperties = new PropertyProxy(textRendererProperties_onChange);
		}
		return this._textRendererProperties;
	}

	/**
	 * @private
	 */
	public function set_textRendererProperties(value:PropertyProxy):PropertyProxy
	{
		if(this._textRendererProperties == value)
		{
			return get_textRendererProperties();
		}
		if(value != null && !Std.is(value, PropertyProxy))
		{
			value = PropertyProxy.fromObject(value);
		}
		if(this._textRendererProperties != null)
		{
			this._textRendererProperties.removeOnChangeCallback(textRendererProperties_onChange);
		}
		this._textRendererProperties = value;
		if(this._textRendererProperties != null)
		{
			this._textRendererProperties.addOnChangeCallback(textRendererProperties_onChange);
		}
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
		return get_textRendererProperties();
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var dataInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		var stylesInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STYLES);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var stateInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
		var textRendererInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_TEXT_RENDERER);

		if(textRendererInvalid)
		{
			this.createTextRenderer();
		}

		if(textRendererInvalid || dataInvalid || stateInvalid)
		{
			this.refreshTextRendererData();
		}

		if(textRendererInvalid || stateInvalid)
		{
			this.refreshEnabled();
		}

		if(textRendererInvalid || stylesInvalid || stateInvalid)
		{
			this.refreshTextRendererStyles();
		}

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layout();
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
		this.textRenderer.minWidth = this._minWidth;
		this.textRenderer.maxWidth = this._maxWidth;
		this.textRenderer.width = this.explicitWidth;
		this.textRenderer.minHeight = this._minHeight;
		this.textRenderer.maxHeight = this._maxHeight;
		this.textRenderer.height = this.explicitHeight;
		this.textRenderer.measureText(HELPER_POINT);
		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			if(this._text != null)
			{
				newWidth = HELPER_POINT.x;
			}
			else
			{
				newWidth = 0;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			if(this._text != null)
			{
				newHeight = HELPER_POINT.y;
			}
			else
			{
				newHeight = 0;
			}
		}

		return this.setSizeInternal(newWidth, newHeight, false);
	}

	/**
	 * Creates and adds the <code>textRenderer</code> sub-component and
	 * removes the old instance, if one exists.
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 *
	 * @see #textRenderer
	 * @see #textRendererFactory
	 */
	private function createTextRenderer():Void
	{
		if(this.textRenderer != null)
		{
			this.removeChild(cast(this.textRenderer, DisplayObject), true);
			this.textRenderer = null;
		}

		var factory:Void->ITextRenderer = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
		this.textRenderer = factory();
		this.addChild(cast(this.textRenderer, DisplayObject));
	}

	/**
	 * @private
	 */
	private function refreshEnabled():Void
	{
		this.textRenderer.isEnabled = this._isEnabled;
	}

	/**
	 * @private
	 */
	private function refreshTextRendererData():Void
	{
		this.textRenderer.text = this._text;
		this.textRenderer.visible = this._text != null && this._text.length > 0;
	}

	/**
	 * @private
	 */
	private function refreshTextRendererStyles():Void
	{
		this.textRenderer.wordWrap = this._wordWrap;
		for(propertyName in Reflect.fields(this._textRendererProperties.storage))
		{
			var propertyValue:Dynamic = Reflect.field(this._textRendererProperties.storage, propertyName);
			Reflect.setProperty(this.textRenderer, propertyName, propertyValue);
		}
	}

	/**
	 * @private
	 */
	private function layout():Void
	{
		this.textRenderer.width = this.actualWidth;
		this.textRenderer.height = this.actualHeight;
		this.textRenderer.validate();
	}

	/**
	 * @private
	 */
	private function textRendererProperties_onChange(proxy:PropertyProxy, propertyName:String):Void
	{
		this.invalidate(FeathersControl.INVALIDATION_FLAG_STYLES);
	}
}
