/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core;
import flash.utils.Dictionary;

import starling.animation.IAnimatable;
import starling.core.Starling;

[ExcludeClass]
class ValidationQueue implements IAnimatable
{
	/**
	 * @private
	 */
	inline private static var STARLING_TO_VALIDATION_QUEUE:Dictionary = new Dictionary(true);

	/**
	 * Gets the validation queue for the specified Starling instance. If
	 * a validation queue does not exist for the specified Starling
	 * instance, a new one will be created.
	 */
	public static function forStarling(starling:Starling):ValidationQueue
	{
		if(!starling)
		{
			return null;
		}
		var queue:ValidationQueue = STARLING_TO_VALIDATION_QUEUE[starling];
		if(!queue)
		{
			STARLING_TO_VALIDATION_QUEUE[starling] = queue = new ValidationQueue(starling);
		}
		return queue;
	}

	/**
	 * Constructor.
	 */
	public function ValidationQueue(starling:Starling)
	{
		this._starling = starling;
	}

	private var _starling:Starling;

	private var _isValidating:Bool = false;

	/**
	 * If true, the queue is currently validating.
	 *
	 * <p>In the following example, we check if the queue is currently validating:</p>
	 *
	 * <listing version="3.0">
	 * if( queue.isValidating )
	 * {
	 *     // do something
	 * }</listing>
	 */
	public function get_isValidating():Bool
	{
		return this._isValidating;
	}

	private var _delayedQueue:Array<IValidating> = new Array();
	private var _queue:Array<IValidating> = new Array();

	/**
	 * Disposes the validation queue.
	 */
	public function dispose():Void
	{
		if(this._starling)
		{
			this._starling.juggler.remove(this);
			this._starling = null;
		}
	}

	/**
	 * Adds a validating component to the queue.
	 */
	public function addControl(control:IValidating, delayIfValidating:Bool):Void
	{
		//if the juggler was purged, we need to add the queue back in.
		if(!this._starling.juggler.contains(this))
		{
			this._starling.juggler.add(this);
		}
		var currentQueue:Array<IValidating> = (this._isValidating && delayIfValidating) ? this._delayedQueue : this._queue;
		if(currentQueue.indexOf(control) >= 0)
		{
			//already queued
			return;
		}
		var queueLength:Int = currentQueue.length;
		if(this._isValidating && currentQueue == this._queue)
		{
			//special case: we need to keep it sorted
			var depth:Int = control.depth;

			//we're traversing the queue backwards because it's
			//significantly more likely that we're going to push than that
			//we're going to splice, so there's no point to iterating over
			//the whole queue
			for(var i:Int = queueLength - 1; i >= 0; i--)
			{
				var otherControl:IValidating = IValidating(currentQueue[i]);
				var otherDepth:Int = otherControl.depth;
				//we can skip the overhead of calling queueSortFunction and
				//of looking up the value we've already stored in the depth
				//local variable.
				if(depth >= otherDepth)
				{
					break;
				}
			}
			//add one because we're going after the last item we checked
			//if we made it through all of them, i will be -1, and we want 0
			i++;
			if(i == queueLength)
			{
				currentQueue[queueLength] = control;
			}
			else
			{
				currentQueue.splice(i, 0, control);
			}
		}
		else
		{
			currentQueue[queueLength] = control;
		}
	}

	/**
	 * @private
	 */
	public function advanceTime(time:Float):Void
	{
		if(this._isValidating)
		{
			return;
		}
		var queueLength:Int = this._queue.length;
		if(queueLength == 0)
		{
			return;
		}
		this._isValidating = true;
		this._queue = this._queue.sort(queueSortFunction);
		while(this._queue.length > 0) //rechecking length after the shift
		{
			var item:IValidating = this._queue.shift();
			item.validate();
		}
		var temp:Array<IValidating> = this._queue;
		this._queue = this._delayedQueue;
		this._delayedQueue = temp;
		this._isValidating = false;
	}

	/**
	 * @private
	 */
	private function queueSortFunction(first:IValidating, second:IValidating):Int
	{
		var difference:Int = second.depth - first.depth;
		if(difference > 0)
		{
			return -1;
		}
		else if(difference < 0)
		{
			return 1;
		}
		return 0;
	}
}
