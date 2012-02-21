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
 
package seisaku.lib.display.ui.scrolling
{
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Dynamically mask a TextField and scroll it based on text lines rather than pixels.
	 */
	public class TextScroller extends EventDispatcher implements IScroller
	{			
		private var _target:TextField;
		private var _viewportHeight:Number;
		private var _scrollPosition:Number;
		private var _origHeight:Number;
		private var _origAutoSize:String;
		
		/**
		 * @param p_target TextField to scroll.
		 * @param p_viewportHeight Viewport height.
		 */
		public function TextScroller(p_target:TextField,p_viewportHeight:Number)
		{	
			_target = p_target;
			_origHeight = _target.height;
			_viewportHeight = p_viewportHeight;
			_scrollPosition = 0;
			_origAutoSize = _target.autoSize; 
			
			_target.autoSize = TextFieldAutoSize.NONE;
			_target.height = _viewportHeight;
			
			// Hack to force instant accurate reporting of scroll props:
			_target.getCharBoundaries(0);
		}
		
		/**
		 * Set the scroll postion as a value between 0 and 1.
		 * 
		 * @param p_n Scroll position.
		 */
		public function setPosition(p_value:Number):void
		{	
			_scrollPosition = MathUtils.limit(p_value,0,1);
			
			_target.scrollV = MathUtils.interpolate(_scrollPosition,1,_target.maxScrollV);
		}
		
		/**
		 * Get the scroll postion as a value between 0 and 1.
		 * 
		 * @return Scroll position.
		 */
		public function getPosition():Number
		{	
			return _scrollPosition;
		}
		
		/**
		 * Return the ratio of the content height to the height of the viewport, as a value
		 * from 0 to 1. Can be useful for setting the relative sizes of a scroll bar handle
		 * to its track, for example.
		 * 
		 * @return Viewport to content height ratio.
		 */
		public function getViewportToContentRatio():Number
		{	
			return _target.bottomScrollV/_target.numLines;
		}
		
		/**
		 * Undo changes to target textfield, and ready the instance for nulling
		 * prior to garabge collection.
		 */
		public function destroy():void
		{	
			_target.height = _origHeight;
			_target.autoSize = _origAutoSize;
			_target.getCharBoundaries(0);
			_target.scrollV = 1;
		}
		
		public function needsScroll():Boolean
		{
			return _target.maxScrollV > 1;
		}
	}
}