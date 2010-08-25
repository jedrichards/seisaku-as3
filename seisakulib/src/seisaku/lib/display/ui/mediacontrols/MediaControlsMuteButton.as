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
 
package seisaku.lib.display.ui.mediacontrols
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import seisaku.lib.util.DisplayObjectUtils;
	
	/**
	 * Play/pause button for the media controls.
	 */
	public class MediaControlsMuteButton extends MediaControlsAbstractButton
	{
		public function MediaControlsMuteButton(p_startHidden:Boolean=false)
		{
			super(p_startHidden);
		}
		
		override protected function _getIconA():Shape
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			
			g.beginFill(0x000000,0.75);
			g.moveTo(0,2);
			g.lineTo(3,2);
			g.lineTo(5,0);
			g.lineTo(5,8);
			g.lineTo(3,6);
			g.lineTo(0,6);
			g.endFill();
			
			DisplayObjectUtils.drawRect(g,new Rectangle(6,1,1,1),0x000000,0.75);
			DisplayObjectUtils.drawRect(g,new Rectangle(7,2,1,4),0x000000,0.75);
			DisplayObjectUtils.drawRect(g,new Rectangle(6,6,1,1),0x000000,0.75);
			
			s.filters = _getIconFilters();
			
			return s;
		}
		
		override protected function _getIconB():Shape
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			
			g.beginFill(0x000000,0.75);
			g.moveTo(0,2);
			g.lineTo(3,2);
			g.lineTo(5,0);
			g.lineTo(5,8);
			g.lineTo(3,6);
			g.lineTo(0,6);
			g.endFill();
			
			s.filters = _getIconFilters();
			
			return s;
		}
	}
}