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
	 * Custom event class for XMLService events.
	 */
	public class XMLServiceEvent extends Event
	{
		public var error:String;
		
		/**
		 * This event is dispatched when the data service has fully loaded in the XML,
		 * any parsing has been completed and the instance is ready to be queried.
		 */
		public static const READY:String = "xmlServiceReady";
		
		/**
		 * This event is dispatched when there has been a problem loading the XML.
		 */
		public static const LOAD_ERROR:String = "xmlServiceLoadError";
		
		/**
		 * This event is dispatched when there's been a problem parsing the XML.
		 */
		public static const PARSE_ERROR:String = "xmlServiceParseError";
		
		public function XMLServiceEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{
			super(p_type,p_bubbles,p_cancelable);
		}
		
		override public function clone():Event
		{
			var event:XMLServiceEvent = new XMLServiceEvent(type,bubbles,cancelable);
			
			event.error = error;
			
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("XMLServiceEvent","type","bubbles","cancelable","eventPhase");
		}
	}
}