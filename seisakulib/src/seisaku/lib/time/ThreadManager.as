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
 
package seisaku.lib.time
{	 
	import flash.events.Event;
	
	/**
	 * Thread manager. Used internally by Thread instances.
	 */
	public class ThreadManager
	{	
		private static var _threads:Array;
		private static var _numThreads:Number;
		private static var _isInit:Boolean;
		
		private static function _init():void
		{	
			_isInit = true;
			_threads = new Array();
			
			FrameDispatcher.addEventListener(_run);
		}
		
		private static function _run(p_event:Event):void
		{	
			var i:uint = _numThreads;
			
			while( --i > -1 )
			{
				IThread(_threads[i]).run();
			}
		}
		
		public static function attach(p_thread:IThread):void
		{	
			if ( !_isInit )
			{
				_init();
			}
			
			_threads.push(p_thread);
			
			_numThreads = _threads.length;
		}
		
		public static function detach(p_thread:IThread):void
		{	
			if ( !_isInit )
			{
				return;
			}
			
			var i:uint = _threads.length;
			
			while( --i >= 0 )
			{
				if ( _threads[i] == p_thread )
				{
					_threads.splice(i,1);
					
					_numThreads = _threads.length;
					
					return;
				}
			}
		}
	}
}