/****
* Copyright (c) 2012 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/

package dtx.single;

#if js
import dtx.DOMNode;
import js.w3c.level3.Events;
/*
JQuery has these methods.  I'll try break them down into core functionality and implementations of specific events
For now I'm only testing in Firefox / W3 conforming browsers.  Almost certainly broken in IE8 and below.

Core functionality
==================
trigger()
triggerHandler()
WORKING on() - addEventListener, basically
WORKING off() - removeEventListener, basically
WORKING one() - like on(), but runs once and removes itself


Specific Events
===============
mousedown
mouseenter
mouseleave
mousemove
mouseout
mouseover
mouseup
keydown
keypress
keyup
hover() - 
submit()
toggleClick(callBackFirstClick, callBackSecondClick)
blur() - 
change() - 
click() - 
dblclick() - 
focus()
focusIn()
focusOut()
resize - event
scroll - event
select - event
load()
unload (events)
error() - 
ready()


noBubble // not sure what this is... haxe specific by the looks of it


bind() - addEventListener() basically - Replaced by on()
unbind (events) - replaced by off
live // deprecated
die(?eventType) - remove all event handlers // deprecated
*/ 
class EventManagement
{
	/*private static var eventTypeMap = {
		'click':'MouseEvent',
		'dblclick':'MouseEvent',
		'mousedown':'MouseEvent',
		'mouseup':'MouseEvent',
		'mouseover':'MouseEvent',
		'mousemove':'MouseEvent',
		'mouseout':'MouseEvent',
		'keydown':'KeyboardEvent',
		'keypress':'KeyboardEvent',
		'keyup':'KeyboardEvent',
		'':'HTMLEvents',

	}

	/** Trigger an event, as if it has actually happened 
	public static function trigger(target:DOMNode, eventString:String):DOMNode
	{
		if (ElementManipulation.isElement(target))
		{
			var elm:DOMElement = cast target;

			var event;
			var useW3EventModel:Bool = untyped __js__('document.createEvent');
			if (useW3EventModel) 
			{
				event = untyped __js__("document.createEvent('HTMLEvents')");
				event.initEvent(eventString, true, true);
			} 
			else 
			{
				event = untyped __js__("document.createEventObject()");
				event.eventType = "on" + eventString;
			}

			event.eventName = eventString;
			event.memo = memo || { };

			if (useW3EventModel)
			{
				elm.dispatchEvent(event);
			}
			else
			{
				untyped __js__("elm.fireEvent(event.eventType, event)");
			}
		}

		return target;
	}*/

	/** Trigger the handler for the event, but don't emulate the event itself */
	public static function triggerHandler(target:DOMNode, event:String):DOMNode
	{
		return target;
	}

	/** add an event listener */
	public static function on(target:DOMNode, eventType:String, listener:Event->Void):DOMNode
	{
		var elm:DOMElement = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		elm.addEventListener(eventType, listener, false);

		return target;
	}

	public static function off(target:DOMNode, eventType:String, listener:Event->Void):DOMNode
	{
		var elm:DOMElement = cast target;

		// eventType, listener, useCapture.  For info on useCapture, see http://blog.seankoole.com/addeventlistener-explaining-usecapture
		// will not work on IE8 or below.  Can't be bothered adding at the moment.
		// This code may also be an alternative: https://developer.mozilla.org/en/DOM/element.removeEventListener#section_4
		elm.removeEventListener(eventType, listener, false);
		
		return target;
	}

	/** Attach an event but only let it run once */
	public static function one(target:DOMNode, eventType:String, listener:Event->Void):DOMNode
	{
		var fn:Event->Void = null;
		fn = function (e:Event)
		{
			listener(e);
			target.removeEventListener(eventType, fn, false);
		}
		target.addEventListener(eventType, fn, false);
		return target;
	}

	public static inline function mousedown(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mousedown", listener);
	}

	public static inline function mouseenter(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseleave(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mousemove(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mousemove", listener);
	}

	public static inline function mouseout(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mouseout", listener);
	}

	public static inline function mouseover(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mouseover", listener);
	}

	public static inline function mouseup(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "mouseup", listener);
	}

	public static inline function keydown(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "keydown", listener);
	}

	public static inline function keypress(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "keypress", listener);
	}

	public static inline function keyup(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "keyup", listener);
	}

	public static function hover(target:DOMNode, listener1:Event->Void, ?listener2:Event->Void = null):DOMNode
	{
		mouseenter(target, listener1);

		if (listener2 == null)
		{
			// no 2nd listener, that means run the first again
			mouseleave(target, listener1);
		}
		else
		{
			// there is a second listener, so run that when the mouse leaves the hover-area
			mouseleave(target, listener2);
		}
		return target;
	}

	public static inline function submit(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "submit", listener);
	}

	public static function toggleClick(target:DOMNode, listenerFirstClick:Event->Void, listenerSecondClick:Event->Void):DOMNode
	{
		// Wrap the first click function to run once, then remove itself and add the second click function
		var fn1:Event->Void = null;
		var fn2:Event->Void = null;
		
		fn1 = function (e:Event)
		{
			listenerFirstClick(e);
			target.removeEventListener("click", fn1, false);
			target.addEventListener("click", fn2, false);
		}

		// Wrap the second click function to run once, then remove itself and add the first click function
		fn2 = function (e:Event)
		{
			listenerSecondClick(e);
			target.removeEventListener("click", fn2, false);
			target.addEventListener("click", fn1, false);
		}

		// Add the first one to begin with
		target.addEventListener("click", fn1, false);

		return target;
	}

	public static inline function blur(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "blur", listener);
	}

	public static inline function change(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "change", listener);
	}

	public static inline function click(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "click", listener);
	}

	public static inline function dblclick(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "dblclick", listener);
	}

	public static inline function focus(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "focus", listener);
	}

	public static inline function focusIn(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "focusIn", listener);
	}

	public static inline function focusOut(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "focusOut", listener);
	}

	public static inline function resize(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "resize", listener);
	}

	public static inline function scroll(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "scroll", listener);
	}

	public static inline function select(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "select", listener);
	}

	public static inline function load(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "load", listener);
	}

	public static inline function unload(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "unload", listener);
	}

	public static inline function error(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "error", listener);
	}

	public static inline function ready(target:DOMNode, listener:Event->Void):DOMNode
	{
		return on(target, "ready", listener);
	}

}
#end