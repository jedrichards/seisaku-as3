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
 
package seisaku.lib.display.ui
{
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.display.draw.DrawArc;
	import seisaku.lib.display.draw.DrawWedge;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Simple progress circle.
	 */
	public class ProgressCircle2 extends HideableSprite implements IThread
	{
		protected var _radius:Number;
		protected var _width:Number;
		protected var _circleColour:uint;
		protected var _circleAlpha:Number;
		protected var _thread:Thread;
		protected var _progress:Number;
		protected var _easedProgress:Number;
		protected var _easing:Number;
		protected var _capsStyle:String;
		
		protected var _arc:Sprite;
		
		/**
		 * @param p_radius Total radius of circle.
		 * @param p_width Width of circle progress stroke.
		 * @param p_circleColour Colour of circle progress stroke.
		 * @param p_circleAlpha Alpha of circle progress stroke.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function ProgressCircle2(p_radius:Number,p_width:Number,p_circleColour:uint,p_circleAlpha:Number,p_capsStyle:String,p_startHidden:Boolean=false)
		{
			_radius = p_radius;
			_width = p_width;
			_circleColour = p_circleColour;
			_circleAlpha = p_circleAlpha;
			_capsStyle = p_capsStyle;
			
			_thread = new Thread(this);
			_progress = 0;
			_easing = 0.2;
			_easedProgress = 0;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_arc = new Sprite();
			_arc.rotation = -90;
			addChildToHolder(_arc);
		}
		
		protected function renderProgressShape(p_value:Number):void
		{
			_arc.graphics.clear();
			_arc.graphics.lineStyle(_width,_circleColour,_circleAlpha,false,LineScaleMode.NORMAL,_capsStyle);
			
			DrawArc.draw(_arc,_radius,0,_radius,360*p_value,0);
		}
		
		/**
		 * Public run method for thread.
		 */
		public function run():void
		{
			_easedProgress = MathUtils.approach(_easedProgress,_progress,_easing);
			
			renderProgressShape(_easedProgress);
			
			if ( MathUtils.inRange(_easedProgress,_progress-0.0000001,_progress+0.0000001))
			{
				_easedProgress = _progress;
				
				_thread.stop();
			}
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		override public function dispose():void
		{
			_thread.stop();
			_thread = null;
			
			_holder.removeChild(_arc);
			_arc = null;
			
			super.dispose();
		}
		
		/**
		 * Snap the progress to a particular positon as a value from 0 to 1. Progress circle will
		 * snap/jump to new progress value with no easing.
		 */
		public function snapToProgress(p_value:Number):void
		{
			_progress = _easedProgress = MathUtils.limit(p_value,0,1);
			
			renderProgressShape(_progress);
		}
		
		/**
		 * Set the current progress as a value from 0 to 1. Progress circle will ease (if a suitable
		 * easing coefficient has been set) to the new position.
		 */
		public function setProgress(p_value:Number):void
		{			
			_progress = MathUtils.limit(p_value,0,1);
			
			_thread.start();
		}
		
		public function setRadius(p_value:Number):void
		{
			_radius = p_value;
		}
		
		/**
		 * Return the current progress represented by the circle as a value from 0 to 1. This
		 * value is not affected by any easing applied to the circle's motion.
		 */
		public function getProgress():Number
		{	
			return _progress;
		}
		
		/**
		 * Set the easing of the progress circle animation. A value of 1 will give no easing,
		 * while a value close to 0 will give increasingly heavy easing.
		 */
		public function setEasing(p_value:Number):void
		{	
			_easing = MathUtils.limit(p_value,0,1);
		}
		
		/**
		 * Return the progress with respect to any easing animation currently
		 * applied to circle movement as a value from 0 to 1.
		 */
		public function getEasedProgress():Number
		{	
			return _easedProgress;
		}
	}
}