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
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.display.draw.DrawWedge;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	
	/**
	 * Simple configurable buffer circle animation.
	 */
	public class BufferCircle extends HideableSprite implements IThread
	{
		protected var _radius:Number;
		protected var _arc:Number;
		protected var _width:Number;
		protected var _colour:uint;
		protected var _alpha:Number;
		protected var _speed:Number;
		protected var _thread:Thread;
		protected var _subHolder:Sprite;
		protected var _alphaMask:Sprite;
		protected var _wedge:Shape;
		protected var _subHolderMask:Shape;
		protected var _autoStartStop:Boolean;
		
		/**
		 * @param p_radius Radius of the circle.
		 * @param p_width Width of the stroke.
		 * @param p_arc Percentage of the circumference covered by the stroke, as a value between 0 and 1.
		 * @param p_colour Colour of stroke.
		 * @param p_alpha Alpha of stroke.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function BufferCircle(p_radius:Number,p_width:Number,p_arc:Number,p_colour:uint,p_alpha:Number,p_startHidden:Boolean=false)
		{
			_radius = p_radius;
			_width = p_width;
			_arc = p_arc;
			_colour = p_colour;
			_alpha = p_alpha;
			
			_speed = 1;
			_autoStartStop = true;
			_thread = new Thread(this);
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_subHolder = new Sprite();
			_subHolder.blendMode = BlendMode.LAYER;
			_holder.addChild(_subHolder);
			
			_subHolderMask = new Shape();
			_subHolderMask.graphics.beginFill(0xffffff,1);
			_subHolderMask.graphics.drawCircle(0,0,_radius);
			_subHolderMask.graphics.endFill();
			_holder.addChild(_subHolderMask);
			
			_subHolder.mask = _subHolderMask;
						
			_wedge = new Shape();
			renderWedge(_arc);
			_subHolder.addChild(_wedge);
						
			_alphaMask = new Sprite();
			_alphaMask.alpha = 0.01;
			_alphaMask.blendMode = BlendMode.ALPHA;
			_alphaMask.graphics.beginFill(0xff0000,1);
			_alphaMask.graphics.drawCircle(0,0,(_radius+1)-_width);
			_alphaMask.graphics.endFill();
			_subHolder.addChild(_alphaMask);
		}
		
		protected function renderWedge(p_value:Number):void
		{
			_wedge.graphics.clear();
			_wedge.graphics.beginFill(_colour,_alpha);
			DrawWedge.draw(_wedge.graphics,new Point(0,0),90,-360*p_value,_radius+1,_radius+1);
			_wedge.graphics.endFill();
		}
		
		/**
		 * Set the speed of the animation in degrees rotated per frame.
		 */
		public function setSpeed(p_value:Number):void
		{
			_speed = p_value;
		}
		
		/**
		 * Set the arc of the stroke, as a value between 0 and 1.
		 */
		public function setArc(p_value:Number):void
		{
			renderWedge(p_value);
		}
		
		/**
		 * Public run method for the thread.
		 */
		public function run():void
		{
			_wedge.rotation += _speed;
		}
		
		/**
		 * Start the animation.
		 */
		public function start():void
		{
			_thread.start();
		}
		
		/**
		 * Stop the animation.
		 */
		public function stop():void
		{
			_thread.stop();
		}
		
		/**
		 * Boolean value specifying whether the thread should be
		 * automatically started at the beginning of a show, and stopped
		 * and the end of a hide.
		 */
		public function setAutoStartStop(p_value:Boolean):void
		{
			_autoStartStop = p_value;
		}
		
		/**
		 * Stop the animation and rotate the symbol to an arbitrary rotation.
		 */
		public function rotateTo(p_rotation:Number,p_duration:Number=0.75,p_ease:Function=null):void
		{
			_thread.stop();
			
			if ( p_ease == null )
			{
				p_ease = Strong.easeInOut;
			}
			
			TweenLite.to(_wedge,p_duration,{ease:p_ease,rotation:p_rotation});
		}
		
		override protected function _showStart():void
		{
			super._showStart();
			
			if ( _autoStartStop )
			{
				_thread.start();
			}
		}
		
		override protected function _hideComplete():void
		{
			super._hideComplete();
			
			if ( _autoStartStop )
			{
				_thread.stop();
			}
		}
	}
}