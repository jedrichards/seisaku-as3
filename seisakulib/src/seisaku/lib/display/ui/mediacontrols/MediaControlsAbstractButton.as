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
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import seisaku.lib.display.ui.Button;
	import seisaku.lib.util.DisplayObjectUtils;
	
	/**
	 * Abstract base class for a media controls button. Supports toggling between two
	 * different icon states.
	 */
	public class MediaControlsAbstractButton extends Button
	{
		protected var _background:Shape;
		protected var _iconA:Shape;
		protected var _iconB:Shape;
		protected var _glowShape:Shape;
		
		public function MediaControlsAbstractButton(p_startHidden:Boolean=false)
		{
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_background = _getBackground();
			_background.alpha = 0.25;
			_holder.addChild(_background);
			
			_glowShape = _getBackground();
			_glowShape.filters = [new GlowFilter(0x000000,0.7,4,5,1.15,2,false,true)];
			_holder.addChild(_glowShape);
			
			_iconA = _getIconA();
			_holder.addChild(_iconA);
			DisplayObjectUtils.centerInParent(_iconA,false);
			
			_iconB = _getIconB();
			_iconB.visible = false;
			_holder.addChild(_iconB);
			DisplayObjectUtils.centerInParent(_iconB,false);
			
			createHitSprite(0,0,20,20);
		}
		
		protected function _getBackground():Shape
		{
			var s:Shape = new Shape();
			
			DisplayObjectUtils.drawRoundedRect(s.graphics,new Rectangle(0,0,20,20),6,6,0xffffff,1);
			
			return s;
		}
		
		protected function _getIconA():Shape
		{
			return new Shape();
		}
		
		protected function _getIconB():Shape
		{
			return new Shape();
		}
		
		protected function _getIconFilters():Array
		{
			//return [new GlowFilter(0xffffff,0.65,4,4,1,2)];
			return null;
		}
		
		public function showAltIcon(p_value:Boolean):void
		{
			_iconA.visible = !p_value;
			
			_iconB.visible = p_value;
		}
		
		public function toggleAltIcon():void
		{
			showAltIcon(!_iconB.visible);
		}
		
		override protected function _rollOver(p_event:MouseEvent):void
		{
			super._rollOver(p_event);
			
			TweenLite.to(_background,0.25,{ease:Linear.easeNone,alpha:0.75});
		}
		
		override protected function _rollOut(p_event:MouseEvent):void
		{
			super._rollOut(p_event);
			
			TweenLite.to(_background,0.25,{ease:Linear.easeNone,alpha:0.25});
		}
	}
}