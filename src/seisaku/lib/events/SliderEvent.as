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
	 * Custom event class for HideableSpriteButton events.
	 */
	public class SliderEvent extends Event
	{
		/**
		 * This event is fired when the slider position is updated due to a drag
		 * interaction, a track click or a call to the setPosition method.
		 */
		public static const SLIDER_UPDATED:String = "sliderUpdated";
		
		/**
		 * This event is fired every frame while the slider UI is updating, and
		 * may continue to be called once interaction has stopped due to easing.
		 */
		public static const SLIDER_UPDATING:String = "sliderUpdating";
		
		/**
		 * This event is fired once all slider movement has completed, either when
		 * interaction stops if there is no easing, or at the end of the easing animation
		 * if easing has been applied.
		 */
		public static const SLIDER_UPDATING_STOPPED:String = "sliderUpdatingStopped";
		
		/**
		 * This event is fired when the mouse is pressed down on the slider handle,
		 * i.e. when interaction begins.
		 */
		public static const HANDLE_DOWN:String = "handleDown";
		
		/**
		 * This event is fired when the mouse if lifted off the slider handle,
		 * i.e. when interaction has finished.
		 */
		public static const HANDLE_UP:String = "handleUp";
		
		/**
		 * This event is fired when a position tween completes.
		 */
		public static const TWEEN_POSITION_COMPLETE:String = "tweenPositionComplete";
		
		public function SliderEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{
			super(p_type,p_bubbles,p_cancelable);
		}
		
		override public function clone():Event
		{
			return new SliderEvent(type,bubbles,cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("SliderEvent","type","bubbles","cancelable","eventPhase");
		}
	}
}