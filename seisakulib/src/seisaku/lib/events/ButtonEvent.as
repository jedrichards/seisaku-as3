/*
 * Seisaku-Lib AS3
 *
 * Hosting: code.google.com/p/seisaku-lib
 * Portfolio: www.seisaku.co.uk
 * Contact: jed@seisaku.co.uk
 *	
 * Copyright (c) 2009 Seisaku Limited/Jed Richards
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package seisaku.lib.events
{
	import flash.events.Event;
	
	/**
	 * Custom event class for Button events.
	 */
	public class ButtonEvent extends Event
	{
		/**
		 * AS2-style "drag over" event. Dispatched when the mouse is dragged over a button with the
		 * mouse button down.
		 */
		public static const AS2_DRAG_OVER:String = "buttonAS2DragOver";
		
		/**
		 * AS2-style "drag out" event. Dispatched when the mouse is dragged off a button with the
		 * mouse button down.
		 */
		public static const AS2_DRAG_OUT:String = "buttonAS2DragOut";
		
		/**
		 * AS2-style "release outside" event. Dispatched when the mouse button is released outside
		 * a button, having previously been depressed while inside the button.
		 */
		public static const AS2_RELEASE_OUTSIDE:String = "buttonAS2ReleaseOutside";
		
		/**
		 * This event is dispatched when the button is clicked.
		 */
		public static const CLICK:String = "buttonClick";
		
		/**
		 * This event is dispatched when the button is double-clicked.
		 */
		public static const DOUBLE_CLICK:String = "buttonDoubleClick";
		
		/**
		 * This event is dispatched when the button is pressed.
		 */
		public static const MOUSE_DOWN:String = "buttonMouseDown";
		
		/**
		 * This event is dispatched when the button is released.
		 */
		public static const MOUSE_UP:String = "buttonMouseUp";
		
		/**
		 * This event is dispatched when the mouse rolls off the button.
		 */
		public static const ROLL_OUT:String = "buttonRollOut";
		
		/**
		 * This event is dispatched when the mouse rolls over the button.
		 */
		public static const ROLL_OVER:String = "buttonRollOver";
		
		/**
		 * This event is dispatched constantly while the mouse is moving across the button.
		 */
		public static const MOUSE_MOVE:String = "buttonMouseMove";
		
		public var id:Number;
		
		public function ButtonEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{
			super(p_type,p_bubbles,p_cancelable);
		}
		
		override public function clone():Event
		{
			var event:ButtonEvent = new ButtonEvent(type,bubbles,cancelable);
			
			event.id = id;
			
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("button","type","bubbles","cancelable","eventPhase","id","payLoad");
		}
	}
}