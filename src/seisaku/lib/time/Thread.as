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
	import seisaku.lib.time.IThread;
	
	/**
	 * Java-style thread class. The run method of the thread's target will be called
	 * every frame while the thread is running. Note that an actively running thread
	 * means that a reference to the thread target is held in the ThreadManager
	 * stopping the target from being garbage collected.
	 */
	public class Thread
	{	
		private var _target:IThread;
		private var _isRunning:Boolean;
		
		/**
		 * @param p_thread Thread target.
		 * @param p_bStart Start the thread running immediately.
		 */
		public function Thread(p_thread:IThread,p_start:Boolean=false)
		{	
			_target = p_thread;
			_isRunning = false;
			
			if ( p_start )
			{
				start();
			}
		}
		
		/**
		 * Start/re-start the thread.
		 */
		public function start():void
		{	
			if ( _isRunning )
			{
				return;
			}
			
			_isRunning = true;
			
			ThreadManager.attach(_target);
		}
		
		/**
		 * Stop (not destroy) the thread.
		 */
		public function stop():void
		{	
			if ( !_isRunning )
			{
				return;
			}
			
			_isRunning = false;
			
			ThreadManager.detach(_target);
		}
		
		public function getIsRunning():Boolean
		{
			return _isRunning;
		}
	}
}