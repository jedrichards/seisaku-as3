/*
 * Seisaku-Lib AS3
 *
 * Project home: https://github.com/jedrichards/seisakulib
 * Website: http://www.seisaku.co.uk
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
	 * Custom event class for ExternalHideableSprite events.
	 */
	public class HideableExternalAssetEvent extends Event
	{
		/**
		 * This event is dispatched when there's been a problem loading the external content.
		 */
		public static const LOAD_ERROR:String = "hideableExternalAssetLoadError";
		
		/**
		 * This event is dispatched while the external content is downloading.
		 */
		public static const LOAD_PROGRESS:String = "hideableExternalAssetLoadProgress";
		
		/**
		 * This event is dispatched when the external content is fully loaded.
		 */
		public static const FULLY_LOADED:String = "hideableExternalAssetFullyLoaded";
		
		/**
		 * This event is dispatched when the content (for example a SWF) has initialised
		 * and is ready for interaction but has possibly not fully downloaded.
		 */
		public static const CONTENT_INIT:String = "hideableExternalAssetContentInit";
		
		public var progress:Number;
		
		public function HideableExternalAssetEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{
			super(p_type,p_bubbles,p_cancelable);
		}
		
		override public function clone():Event
		{
			var event:HideableExternalAssetEvent = new HideableExternalAssetEvent(type,bubbles,cancelable);
			
			event.progress = progress;
			
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("ExternalHideableSpriteEvent","type","bubbles","cancelable","eventPhase");
		}
	}
}