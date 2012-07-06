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
 
package seisaku.lib.display.ui
{	
	import flash.display.Sprite;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Simple progress bar.
	 */
	public class ProgressBar extends HideableSprite implements IThread
	{	
		protected var _width:Number;
		protected var _height:Number;
		protected var _leftColour:Number;
		protected var _leftAlpha:Number;
		protected var _rightColour:Number;
		protected var _rightAlpha:Number;
		protected var _leftSide:Sprite;
		protected var _rightSide:Sprite;
		protected var _progress:Number;
		protected var _thread:Thread;
		protected var _easing:Number;
		
		/**
		 * @param p_width Overall width of the progress bar.
		 * @param p_height Overall height of the progress bar.
		 * @param p_leftColour Colour of the left-hand side of the bar.
		 * @param p_rightColour Colour of the right-hand side of the bar.
		 * @param p_leftAlpha Alpha of the left-hand side of the bar.
		 * @param p_rightAlpha Alpha of the right-hand side of the bar.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function ProgressBar(p_width:Number,p_height:Number,p_leftColour:Number,p_rightColour:Number,p_leftAlpha:Number=1,p_rightAlpha:Number=1,p_startHidden:Boolean=false)
		{
			_width = p_width;
			_height = p_height;
			_leftColour = p_leftColour;
			_leftAlpha = p_leftAlpha;
			_rightColour = p_rightColour;
			_rightAlpha = p_rightAlpha;
			
			_progress = 0;
			_easing = 0.2;
			
			_thread = new Thread(this);
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_leftSide = new Sprite();
			_leftSide.alpha = _leftAlpha;
			_leftSide.graphics.beginFill(_leftColour,1);
			_leftSide.graphics.drawRect(0,0,_width,_height);
			_leftSide.graphics.endFill();
			_leftSide.scaleX = 0;
			_holder.addChild(_leftSide);
			
			_rightSide = new Sprite();
			_rightSide.alpha = _rightAlpha;
			_rightSide.graphics.beginFill(_rightColour,1);
			_rightSide.graphics.drawRect(0,0,_width,_height);
			_rightSide.graphics.endFill();
			_holder.addChild(_rightSide);
		}
		
		/**
		 * Public run method for thread.
		 */
		public function run():void
		{
			_leftSide.scaleX = MathUtils.approach(_leftSide.scaleX,_progress,_easing);
			
			if ( MathUtils.inRange(_leftSide.scaleX,_progress-0.0000001,_progress+0.0000001))
			{
				_leftSide.scaleX = _progress;
				_thread.stop();
			}
			
			_rightSide.scaleX = 1-_leftSide.scaleX;
			_rightSide.x = _leftSide.width;
		}
		
		/**
		 * Snap the progress to a particular positon as a value from 0 to 1. Progress bar will
		 * snap/jump to new progress value with no easing.
		 */
		public function snapToProgress(p_value:Number):void
		{
			_progress = MathUtils.limit(p_value,0,1);
			
			_leftSide.scaleX = _progress;
			
			_rightSide.scaleX = 1-_leftSide.scaleX;
			_rightSide.x = _leftSide.width;
		}
		
		/**
		 * Set the current progress as a value from 0 to 1. Progress bar will ease (if a suitable
		 * easing coefficient has been set) to the new position.
		 */
		public function setProgress(p_value:Number):void
		{
			_progress = MathUtils.limit(p_value,0,1);
			
			_thread.start();
		}
		
		/**
		 * Return the current progress represented by the bar as a value from 0 to 1. This
		 * value is not affected by any easing applied to the bar's motion.
		 */
		public function getProgress():Number
		{	
			return _progress;
		}
		
		/**
		 * Set the easing of the progress bar animation. A value of 1 will give no easing,
		 * while a value close to 0 will give heavy easing.
		 */
		public function setEasing(p_value:Number):void
		{	
			_easing = p_value;
		}
		
		/**
		 * Return the progress with respect to any easing animation currently
		 * applied to bar movement as a value from 0 to 1.
		 */
		public function getEasedProgress():Number
		{	
			return _leftSide.scaleX;
		}
		
		/**
		 * Return the current progress of the bar as a value ranging from 0 to the
		 * original bar width in pixels (as supplied to the constructor). This value
		 * will be affected by any easing applied to the ProgressBar motion.
		 * 
		 * @return Eased progress in pixels.
		 */
		public function getPixelProgress():Number
		{	
			return _leftSide.width;
		}
		
		/**
		 * Return the original width of the overall progress bar as passed into the
		 * constructor.
		 */
		public function getOrigWidth():Number
		{
			return _width;
		}
		
		/**
		 * Return a reference to the right side shape.
		 * 
		 * @return Right side shape.
		 */
		public function getRightSide():Sprite
		{
			return _rightSide;
		}
		
		/**
		 * Return a reference to the left side shape.
		 * 
		 * @return Left side shape.
		 */
		public function getLeftSide():Sprite
		{
			return _leftSide;
		}
	}
}