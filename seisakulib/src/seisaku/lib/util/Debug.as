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

package seisaku.lib.util
{	
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	
	/**
	 * Static Debug class. Calls to the log method can be traced or sent to the debug
	 * console via a LocalConnection. The debug levels allow different levels of debug
	 * information to be coloured and filtered before display in the debug console.
	 */
	public class Debug
	{	
		public static const L0_INFORMATIONAL:uint = 0;
		public static const L1_EVENT:uint = 1;
		public static const L2_WARNING:uint = 2;
		public static const L3_CRITICAL:uint = 3;
		public static const L4_SYSTEM:uint = 4;
		public static const CONNECTION_ID:String = "_SEISAKU_DEBUG";
		
		public static var logToConsole:Boolean;
		public static var logToIDE:Boolean;
		
		private static var _conn:LocalConnection;
		private static var _connected:Boolean;
		private static var _init:Boolean;
		
		/**
		 * Initialise the Debug class.
		 * 
		 * @param p_logToConsole Whether to log output to the external debug console.
		 * @param p_logToIDE Whether to log output to the IDE console.
		 */
		public static function init(p_logToConsole:Boolean=true,p_logToIDE:Boolean=true):void
		{	
			if ( _init )
			{
				return;
			}
			
			logToConsole = p_logToConsole;
			logToIDE = p_logToIDE;
			
			_init = true;
			_connected = true;
			
			_conn = new LocalConnection();
			_conn.addEventListener(StatusEvent.STATUS,_status0,false,0,true);
			
			var dateArray:Array = new Date().toString().split(" ");
			
			log("[Seisaku-lib AS3 "+Version.getVersionString()+" debug session started at "+dateArray[3]+"]",L4_SYSTEM);
		}
		
		/**
		 * Log a debug statement.
		 * 
		 * @param p_item Object or string to be logged.
		 * @param p_level Console debug level, essentially allows for colouring and filtering of debug output, defaults to LEVEL_DEBUG (0).
		 * @param p_introspect Recursively loop through sub-objects for printing out a representation of their contents.
		 * @param p_initTabs Initial amount of tabs to indent introspection results.
		 */
		public static function log(p_item:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{	
			if ( !_init )
			{
				init();
			}
			
			if ( p_introspect ) 
			{
				p_item = ObjectUtils.introspect(p_item,p_initTabs);
			}
			
			if ( logToConsole && _connected )
			{
				_conn.send(CONNECTION_ID,"onUpdate",p_item,p_level);
			}
			
			if ( logToIDE )
			{
				trace(p_item);
			}
		}
		
		private static function _status0(p_event:StatusEvent):void
		{
			if ( p_event.level != "status" )
			{
				_connected = false;
			}
			
			_conn.removeEventListener(StatusEvent.STATUS,_status0);
			
			_conn.addEventListener(StatusEvent.STATUS,_status1,false,0,true);
		}
		
		private static function _status1(p_event:StatusEvent):void
		{
		}
	}
}