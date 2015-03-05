/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses;
import feathers.controls.LayoutGroup;
import feathers.core.IValidating;
import openfl.errors.ArgumentError;
import feathers.core.FeathersControl;

import starling.display.DisplayObject;

/**
 * @private
 * Used internally by ScrollContainer. Not meant to be used on its own.
 */
class LayoutViewPort extends LayoutGroup implements IViewPort
{
	public function new()
	{
		super();
	}

	private var _minVisibleWidth:Float = 0;

	public var minVisibleWidth(get, set):Float;
	public function get_minVisibleWidth():Float
	{
		return this._minVisibleWidth;
	}

	public function set_minVisibleWidth(value:Float):Float
	{
		if(this._minVisibleWidth == value)
		{
			return this._minVisibleWidth;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleWidth cannot be NaN");
		}
		this._minVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._minVisibleWidth;
	}

	private var _maxVisibleWidth:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleWidth(get, set):Float;
	public function get_maxVisibleWidth():Float
	{
		return this._maxVisibleWidth;
	}

	public function set_maxVisibleWidth(value:Float):Float
	{
		if(this._maxVisibleWidth == value)
		{
			return this._maxVisibleWidth;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleWidth cannot be NaN");
		}
		this._maxVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._maxVisibleWidth;
	}

	private var _actualVisibleWidth:Float = 0;

	private var _explicitVisibleWidth:Float = Math.NaN;

	public var visibleWidth(get, set):Float;
	public function get_visibleWidth():Float
	{
		if(this._explicitVisibleWidth != this._explicitVisibleWidth) //isNaN
		{
			return this._actualVisibleWidth;
		}
		return this._explicitVisibleWidth;
	}

	public function set_visibleWidth(value:Float):Float
	{
		if(this._explicitVisibleWidth == value ||
			(value != value && this._explicitVisibleWidth != this._explicitVisibleWidth)) //isNaN
		{
			return get_visibleWidth();
		}
		this._explicitVisibleWidth = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_visibleWidth();
	}

	private var _minVisibleHeight:Float = 0;

	public var minVisibleHeight(get, set):Float;
	public function get_minVisibleHeight():Float
	{
		return this._minVisibleHeight;
	}

	public function set_minVisibleHeight(value:Float):Float
	{
		if(this._minVisibleHeight == value)
		{
			return this._minVisibleHeight;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("minVisibleHeight cannot be NaN");
		}
		this._minVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._minVisibleHeight;
	}

	private var _maxVisibleHeight:Float = Math.POSITIVE_INFINITY;

	public var maxVisibleHeight(get, set):Float;
	public function get_maxVisibleHeight():Float
	{
		return this._maxVisibleHeight;
	}

	public function set_maxVisibleHeight(value:Float):Float
	{
		if(this._maxVisibleHeight == value)
		{
			return this._maxVisibleHeight;
		}
		if(value != value) //isNaN
		{
			throw new ArgumentError("maxVisibleHeight cannot be NaN");
		}
		this._maxVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return this._maxVisibleHeight;
	}

	private var _actualVisibleHeight:Float = 0;

	private var _explicitVisibleHeight:Float = Math.NaN;

	public var visibleHeight(get, set):Float;
	public function get_visibleHeight():Float
	{
		if(this._explicitVisibleHeight != this._explicitVisibleHeight) //isNaN
		{
			return this._actualVisibleHeight;
		}
		return this._explicitVisibleHeight;
	}

	public function set_visibleHeight(value:Float):Float
	{
		if(this._explicitVisibleHeight == value ||
			(value != value && this._explicitVisibleHeight != this._explicitVisibleHeight)) //isNaN
		{
			return get_visibleHeight();
		}
		this._explicitVisibleHeight = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SIZE);
		return get_visibleHeight();
	}

	private var _contentX:Float = 0;

	public var contentX(get, set):Float;
	public function get_contentX():Float
	{
		return this._contentX;
	}
	
	public function set_contentX(unused:Float):Float
	{
		return this._contentX;
	}

	private var _contentY:Float = 0;

	public var contentY(get, never):Float;
	public function get_contentY():Float
	{
		return this._contentY;
	}

	public var horizontalScrollStep(get, set):Float;
	public function get_horizontalScrollStep():Float
	{
		if(this.actualWidth < this.actualHeight)
		{
			return this.actualWidth / 10;
		}
		return this.actualHeight / 10;
	}
	
	public function set_horizontalScrollStep(unused:Float):Float
	{
		return get_horizontalScrollStep();
	}

	public var verticalScrollStep(get, never):Float;
	public function get_verticalScrollStep():Float
	{
		if(this.actualWidth < this.actualHeight)
		{
			return this.actualWidth / 10;
		}
		return this.actualHeight / 10;
	}

	private var _horizontalScrollPosition:Float = 0;

	public var horizontalScrollPosition(get, set):Float;
	public function get_horizontalScrollPosition():Float
	{
		return this._horizontalScrollPosition;
	}

	public function set_horizontalScrollPosition(value:Float):Float
	{
		if(this._horizontalScrollPosition == value)
		{
			return this._horizontalScrollPosition;
		}
		this._horizontalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return this._horizontalScrollPosition;
	}

	private var _verticalScrollPosition:Float = 0;

	public var verticalScrollPosition(get, set):Float;
	public function get_verticalScrollPosition():Float
	{
		return this._verticalScrollPosition;
	}

	public function set_verticalScrollPosition(value:Float):Float
	{
		if(this._verticalScrollPosition == value)
		{
			return this._verticalScrollPosition;
		}
		this._verticalScrollPosition = value;
		this.invalidate(FeathersControl.INVALIDATION_FLAG_SCROLL);
		return this._verticalScrollPosition;
	}

	override public function dispose():Void
	{
		this.layout = null;
		super.dispose();
	}

	override private function draw():Void
	{
		var layoutInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_LAYOUT);
		var sizeInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE);
		var scrollInvalid:Bool = this.isInvalid(FeathersControl.INVALIDATION_FLAG_SCROLL);

		super.draw();

		if(scrollInvalid || sizeInvalid || layoutInvalid)
		{
			if(this._layout != null)
			{
				this._contentX = this._layoutResult.contentX;
				this._contentY = this._layoutResult.contentY;
				this._actualVisibleWidth = this._layoutResult.viewPortWidth;
				this._actualVisibleHeight = this._layoutResult.viewPortHeight;
			}
		}
	}

	override private function refreshViewPortBounds():Void
	{
		this.viewPortBounds.x = 0;
		this.viewPortBounds.y = 0;
		this.viewPortBounds.scrollX = this._horizontalScrollPosition;
		this.viewPortBounds.scrollY = this._verticalScrollPosition;
		this.viewPortBounds.explicitWidth = this._explicitVisibleWidth;
		this.viewPortBounds.explicitHeight = this._explicitVisibleHeight;
		this.viewPortBounds.minWidth = this._minVisibleWidth;
		this.viewPortBounds.minHeight = this._minVisibleHeight;
		this.viewPortBounds.maxWidth = this._maxVisibleWidth;
		this.viewPortBounds.maxHeight = this._maxVisibleHeight;
	}

	override private function handleManualLayout():Void
	{
		var minX:Float = 0;
		var minY:Float = 0;
		var explicitViewPortWidth:Float = this.viewPortBounds.explicitWidth;
		var maxX:Float = explicitViewPortWidth;
		if(maxX != maxX) //isNaN
		{
			maxX = 0;
		}
		var explicitViewPortHeight:Float = this.viewPortBounds.explicitHeight;
		var maxY:Float = explicitViewPortHeight;
		if(maxY != maxY) //isNaN
		{
			maxY = 0;
		}
		this._ignoreChildChanges = true;
		var itemCount:Int = this.items.length;
		for(i in 0 ... itemCount)
		{
			var item:DisplayObject = this.items[i];
			if(Std.is(item, IValidating))
			{
				cast(item, IValidating).validate();
			}
			var itemX:Float = item.x;
			var itemY:Float = item.y;
			var itemMaxX:Float = itemX + item.width;
			var itemMaxY:Float = itemY + item.height;
			if(itemX == itemX && //!isNaN
				itemX < minX)
			{
				minX = itemX;
			}
			if(itemY == itemY && //!isNaN
				itemY < minY)
			{
				minY = itemY;
			}
			if(itemMaxX == itemMaxX && //!isNaN
				itemMaxX > maxX)
			{
				maxX = itemMaxX;
			}
			if(itemMaxY == itemMaxY && //!isNaN
				itemMaxY > maxY)
			{
				maxY = itemMaxY;
			}
		}
		this._contentX = minX;
		this._contentY = minY;
		var minWidth:Float = this.viewPortBounds.minWidth;
		var maxWidth:Float = this.viewPortBounds.maxWidth;
		var minHeight:Float = this.viewPortBounds.minHeight;
		var maxHeight:Float = this.viewPortBounds.maxHeight;
		var calculatedWidth:Float = maxX - minX;
		if(calculatedWidth < minWidth)
		{
			calculatedWidth = minWidth;
		}
		else if(calculatedWidth > maxWidth)
		{
			calculatedWidth = maxWidth;
		}
		var calculatedHeight:Float = maxY - minY;
		if(calculatedHeight < minHeight)
		{
			calculatedHeight = minHeight;
		}
		else if(calculatedHeight > maxHeight)
		{
			calculatedHeight = maxHeight;
		}
		this._ignoreChildChanges = false;
		if(explicitViewPortWidth != explicitViewPortWidth) //isNaN
		{
			this._actualVisibleWidth = calculatedWidth;
		}
		else
		{
			this._actualVisibleWidth = explicitViewPortWidth;
		}
		if(explicitViewPortHeight != explicitViewPortHeight) //isNaN
		{
			this._actualVisibleHeight = calculatedHeight;
		}
		else
		{
			this._actualVisibleHeight = explicitViewPortHeight;
		}
		this._layoutResult.contentX = 0;
		this._layoutResult.contentY = 0;
		this._layoutResult.contentWidth = calculatedWidth;
		this._layoutResult.contentHeight = calculatedHeight;
		this._layoutResult.viewPortWidth = this._actualVisibleWidth;
		this._layoutResult.viewPortHeight = this._actualVisibleHeight;
	}
}
