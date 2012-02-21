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
	
	/**
	 * Scroller interface. Allows polymorphism between scroller classes and the actual
	 * scrollbar UIs/controls.
	 * 
	 * @see seisaku.lib.display.scrolling.ScrollRectScroller
	 * @see seisaku.lib.display.scrolling.MaskScroller
	 * @see seisaku.lib.display.scrolling.TextScroller
	 */
	public interface IScroller
	{	
		/**
		 * Set the scroll postion as a value between 0 and 1.
		 * 
		 * @param p_value Scroll position.
		 */
		function setPosition(p_n:Number):void;
		
		/**
		 * Get the scroll postion as a value between 0 and 1.
		 * 
		 * @return Scroll position.
		 */
		function getPosition():Number;
		
		/**
		 * Permanently remove the mask, and ready the instance for nulling
		 * prior to garabge collection.
		 */
		function destroy():void;
		
		/**
		 * Return the ratio of the content height to the height of the viewport, as a value
		 * from 0 to 1. Can be useful for setting the relative sizes of a scroll bar handle
		 * to its track, for example.
		 * 
		 * @return Viewport to content height ratio.
		 */
		function getViewportToContentRatio():Number;
	}
}