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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Static class for enter frame events.
	 */
	public class FrameDispatcher
	{	
		private static var _captiveSprite:Sprite;
		private static var _isInit:Boolean;
	
		private static function _init():void
		{			
			_isInit = true;
			
			_captiveSprite = new Sprite();
		}
		
		/**
		 * Add an event listener to the static class.
		 * 
		 * @param p_listener Method closure to add.
		 */
		public static function addEventListener(p_listener:Function):void
		{
  			if (!_isInit)
  			{
  				_init();
  			}
  			
  			_captiveSprite.addEventListener(Event.ENTER_FRAME,p_listener,false,0,true);
  		}
  		
  		/**
		 * Detach an event listener from the static class.
		 * 
		 * @param p_listener Method closure to remove.
		 */
		public static function removeEventListener(p_listener:Function):void
		{
  			if (!_isInit)
  			{
  				return;
  			}
  			
  			_captiveSprite.removeEventListener(Event.ENTER_FRAME,p_listener);
  		}
	}
}