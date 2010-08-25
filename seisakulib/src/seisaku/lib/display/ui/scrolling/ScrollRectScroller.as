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
 
package seisaku.lib.display.ui.scrolling
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import seisaku.lib.util.MathUtils;
	
	/**
	 * DisplayObject vertical scroller using the scrollRect property. Efficient for scrolling
	 * complex vector content.
	 */
	public class ScrollRectScroller implements IScroller
	{	
		private var _target:DisplayObject;
		private var _scrollPosition:Number;
		private var _origHeight:Number;
		private var _minY:Number;
		private var _maxY:Number;
		private var _viewportWidth:Number;
		private var _viewportHeight:Number;
		
		/**
		 * @param p_target DisplayObject to scroll.
		 * @param p_viewportWidth Width of scrollRect area.
		 * @param p_viewportHeight Height of scrollRect area.
		 */
		public function ScrollRectScroller(p_target:DisplayObject,p_viewportWidth:Number,p_viewportHeight:Number)
		{
			_target = p_target;
			_viewportWidth = p_viewportWidth;
			_viewportHeight = p_viewportHeight;
			_scrollPosition = 0;
			_origHeight = _target.height
			_minY = 0;
			_maxY = _origHeight-_viewportHeight+1;
			
			_target.cacheAsBitmap = true;
			_target.scrollRect = new Rectangle(0,0,_viewportWidth,_viewportHeight);
		}
		
		/**
		 * Set the scroll postion as a value between 0 and 1.
		 * 
		 * @param p_n Scroll position.
		 */
		public function setPosition(p_value:Number):void
		{	
			_scrollPosition = MathUtils.limit(p_value,0,1);
			
			_target.scrollRect = new Rectangle(0,MathUtils.interpolate(_scrollPosition,_minY,_maxY),_viewportWidth,_viewportHeight);
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
			return _viewportHeight/_origHeight;
		}
		
		/**
		 * Permanently remove the mask, and ready the instance for nulling
		 * prior to garabge collection.
		 */
		public function destroy():void
		{	
			_target.scrollRect = null;
			_target.cacheAsBitmap = false;
		}
	}
}