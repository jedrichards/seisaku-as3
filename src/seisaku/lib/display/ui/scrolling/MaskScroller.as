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
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Mask and scroll a movieclip via a simple vector mask. Scroll position easing supported.
	 */
	public class MaskScroller implements IThread,IScroller
	{	
		private var _target:DisplayObject;
		private var _mask:Shape;
		private var _viewportMetrics:Rectangle;
		private var _scrollPosition:Number;
		private var _easing:Number;
		private var _thread:Thread;
		private var _lastYDelta:Number;
		private var _minY:Number;
		private var _maxY:Number;
		
		/**
		 * @param p_target DisplayObject to scroll.
		 * @param p_viewportMetrics Rectangle instance defining size and position of scroll mask.
		 */
		public function MaskScroller(p_target:DisplayObject,p_viewportMetrics:Rectangle=null)
		{	
			_target = p_target;
			
			if ( _target.parent == null )
			{
				throw(new Error("Scroll target DisplayObject must have a parent property"));
			}
			
			_viewportMetrics = p_viewportMetrics;
			
			if ( _viewportMetrics == null )
			{
				_viewportMetrics = _target.getBounds(_target.parent);
			}
			
			_scrollPosition = 0;
			_easing = 1;
			_minY = _target.y-(_target.height-_viewportMetrics.height);
			_maxY = _target.y;
			
			_thread = new Thread(this);
			
			_mask = new Shape();
			_mask.x = _viewportMetrics.x;
			_mask.y = _viewportMetrics.y;
			_mask.graphics.beginFill(0xff0000,1);
			_mask.graphics.drawRect(0,0,_viewportMetrics.width,_viewportMetrics.height);
			_mask.graphics.endFill();
			
			_target.parent.addChild(_mask);
			_target.mask = _mask;
		}
		
		/**
		 * Set the scroll postion as a value between 0 and 1.
		 * 
		 * @param p_value Scroll position.
		 */
		public function setPosition(p_value:Number):void
		{	
			_scrollPosition = MathUtils.limit(p_value,0,1);
			
			_thread.start();
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
			return _viewportMetrics.height/_target.height;
		}
		
		/**
		 * Set the degree of easing for the scrolling movement as a value from 0 to 1. A value
		 * of 1 will result in no easing at all, whereas 0 represents infinite easing.
		 * 
		 * @param p_value Easing coefficient.
		 */
		public function setEasing(p_value:Number):void
		{	
			_easing = p_value;
		}
		
		/**
		 * Permanently remove the mask, and ready the instance for nulling
		 * prior to garabge collection.
		 */
		public function destroy():void
		{	
			_thread.stop();
			_thread = null;
			
			_target.mask = null;
			_target.y = _maxY;
			_target.parent.removeChild(_mask);
			
			_viewportMetrics = null;
			
			_mask = null;
		}
		
		/**
		 * Public run method for the thread.
		 */
		public function run():void
		{	
			var yDelta:Number = (MathUtils.interpolate(_scrollPosition,_maxY,_minY)-_target.y)*_easing;
			
			_target.y += yDelta;
			
			if ( yDelta == _lastYDelta ) {
				
				_thread.stop();
				_target.y = MathUtils.interpolate(_scrollPosition,_maxY,_minY);
			}
			
			_lastYDelta = yDelta;
		}
	}
}