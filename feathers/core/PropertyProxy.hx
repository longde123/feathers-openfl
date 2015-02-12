/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import openfl.utils.Proxy;
import openfl.utils.flash_proxy;

/**
 * Detects when its own properties have changed and dispatches an event
 * to notify listeners.
 *
 * <p>Supports nested <code>PropertyProxy</code> instances using attribute
 * <code>&#64;</code> notation. Placing an <code>&#64;</code> before a property name
 * is like saying, "If this nested <code>PropertyProxy</code> doesn't exist
 * yet, create one. If it does, use the existing one."</p>
 */
dynamic class PropertyProxy extends Proxy
{
	/**
	 * Creates a <code>PropertyProxy</code> from a regular old <code>Object</code>.
	 */
	public static function fromObject(source:Dynamic, onChangeCallback:Dynamic = null):PropertyProxy
	{
		var newValue:PropertyProxy = new PropertyProxy(onChangeCallback);
		for(var propertyName:String in source)
		{
			newValue[propertyName] = source[propertyName];
		}
		return newValue;
	}

	/**
	 * Constructor.
	 */
	public function PropertyProxy(onChangeCallback:Dynamic = null)
	{
		if(onChangeCallback != null)
		{
			this._onChangeCallbacks[this._onChangeCallbacks.length] = onChangeCallback;
		}
	}

	/**
	 * @private
	 */
	private var _subProxyName:String;

	/**
	 * @private
	 */
	private var _onChangeCallbacks:Array<Function> = new Array();

	/**
	 * @private
	 */
	private var _names:Array = [];

	/**
	 * @private
	 */
	private var _storage:Dynamic = {};

	/**
	 * @private
	 */
	override flash_proxy function hasProperty(name:*):Bool
	{
		return this._storage.hasOwnProperty(name);
	}

	/**
	 * @private
	 */
	override flash_proxy function getProperty(name:*):*
	{
		if(this.flash_proxy::isAttribute(name))
		{
			var nameAsString:String = name is QName ? QName(name).localName : name.toString();
			if(!this._storage.hasOwnProperty(nameAsString))
			{
				var subProxy:PropertyProxy = new PropertyProxy(subProxy_onChange);
				subProxy._subProxyName = nameAsString;
				this._storage[nameAsString] = subProxy;
				this._names[this._names.length] = nameAsString;
				this.fireOnChangeCallback(nameAsString);
			}
			return this._storage[nameAsString];
		}
		return this._storage[name];
	}

	/**
	 * @private
	 */
	override flash_proxy function setProperty(name:*, value:*):Void
	{
		var nameAsString:String = name is QName ? QName(name).localName : name.toString();
		this._storage[nameAsString] = value;
		if(this._names.indexOf(nameAsString) < 0)
		{
			this._names[this._names.length] = nameAsString;
		}
		this.fireOnChangeCallback(nameAsString);
	}

	/**
	 * @private
	 */
	override flash_proxy function deleteProperty(name:*):Bool
	{
		var nameAsString:String = name is QName ? QName(name).localName : name.toString();
		var index:Int = this._names.indexOf(nameAsString);
		if(index == 0)
		{
			this._names.shift();
		}
		else
		{
			var lastIndex:Int = this._names.length - 1;
			if(index == lastIndex)
			{
				this._names.pop();
			}
			else
			{
				this._names.splice(index, 1);
			}
		}
		var result:Bool = delete this._storage[nameAsString];
		if(result)
		{
			this.fireOnChangeCallback(nameAsString);
		}
		return result;
	}

	/**
	 * @private
	 */
	override flash_proxy function nextNameIndex(index:Int):Int
	{
		if(index < this._names.length)
		{
			return index + 1;
		}
		return 0;
	}

	/**
	 * @private
	 */
	override flash_proxy function nextName(index:Int):String
	{
		return this._names[index - 1];
	}

	/**
	 * @private
	 */
	override flash_proxy function nextValue(index:Int):*
	{
		var name:* = this._names[index - 1];
		return this._storage[name];
	}

	/**
	 * Adds a callback to react to property changes.
	 */
	public function addOnChangeCallback(callback:Dynamic):Void
	{
		this._onChangeCallbacks[this._onChangeCallbacks.length] = callback;
	}

	/**
	 * Removes a callback.
	 */
	public function removeOnChangeCallback(callback:Dynamic):Void
	{
		var index:Int = this._onChangeCallbacks.indexOf(callback);
		if(index < 0)
		{
			return;
		}
		if(index == 0)
		{
			this._onChangeCallbacks.shift();
			return;
		}
		var lastIndex:Int = this._onChangeCallbacks.length - 1;
		if(index == lastIndex)
		{
			this._onChangeCallbacks.pop();
			return;
		}
		this._onChangeCallbacks.splice(index, 1);
	}

	/**
	 * @private
	 */
	public function toString():String
	{
		var result:String = "[object PropertyProxy";
		for(var propertyName:String in this)
		{
			result += " " + propertyName;
		}
		return result + "]"
	}

	/**
	 * @private
	 */
	private function fireOnChangeCallback(forName:String):Void
	{
		var callbackCount:Int = this._onChangeCallbacks.length;
		for(var i:Int = 0; i < callbackCount; i++)
		{
			var callback:Dynamic = this._onChangeCallbacks[i] as Function;
			callback(this, forName);
		}
	}

	/**
	 * @private
	 */
	private function subProxy_onChange(proxy:PropertyProxy, name:String):Void
	{
		this.fireOnChangeCallback(proxy._subProxyName);
	}
}
