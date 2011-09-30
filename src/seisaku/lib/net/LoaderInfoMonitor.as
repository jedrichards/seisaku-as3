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
 
package seisaku.lib.net
{	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	
	import seisaku.lib.events.LoaderInfoMonitorEvent;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	
	/**
	 * Monitors a LoaderInfo instance and dispatches events during load progress. Useful for
	 * monitoring the load progress of the main SWF.
	 */
	public class LoaderInfoMonitor extends EventDispatcher implements IThread
	{	
		private var _thread:Thread;
		private var _progress:Number;
		private var _loaderInfo:LoaderInfo;
		
		/**
		 * @param p_loaderInfo Reference to the LoaderInfo instance to audit load progress from.
		 */
		public function LoaderInfoMonitor(p_loaderInfo:LoaderInfo)
		{	
			_loaderInfo = p_loaderInfo;
			
			_progress = 0;
			_thread = new Thread(this);
		}
		
		/**
		 * Begin auditing the load progress of the supplied LoaderInfo object.
		 */
		public function start():void
		{	
			_thread.start();
		}
		
		/**
		 * Get the current load progress.
		 * 
		 * @return Load progress as a number between 0 and 1.
		 */
		public function getProgress():Number
		{	
			return _progress;
		}
		
		/**
		 * Public run method for the thread.
		 */
		public function run():void
		{	
			var progress:Number = _loaderInfo.bytesLoaded/_loaderInfo.bytesTotal; 
			
			if ( progress != _progress )
			{
				var progressEvent:LoaderInfoMonitorEvent = new LoaderInfoMonitorEvent(LoaderInfoMonitorEvent.PROGRESS);
				
				progressEvent.progress = progress;
				
				dispatchEvent(progressEvent);
			}
			
			_progress = progress;

			if ( _progress == 1 )
			{
				_thread.stop();
				
				var completeEvent:LoaderInfoMonitorEvent = new LoaderInfoMonitorEvent(LoaderInfoMonitorEvent.COMPLETE);
				
				completeEvent.progress = 1;
				
				dispatchEvent(completeEvent);
			}
		}
	}
}