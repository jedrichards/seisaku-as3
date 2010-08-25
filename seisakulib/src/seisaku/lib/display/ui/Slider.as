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
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.ButtonEvent;
	import seisaku.lib.events.SliderEvent;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Simple draggable slider user control.
	 * 
	 * @see seisaku.lib.events.SliderEvent SliderEvent
	 */
	public class Slider extends HideableSprite implements IThread
	{	
		protected var _thread:Thread;
		protected var _trackWidth:Number
		protected var _trackHeight:Number
		protected var _handleWidth:Number;
		protected var _trackColour:uint;
		protected var _trackAlpha:Number;
		protected var _handleColour:uint;
		protected var _handleAlpha:Number;
		protected var _track:Button;
		protected var _handle:Sprite;
		protected var _dragHandle:Button;
		protected var _isHandleDown:Boolean;
		protected var _handleMaxX:Number;
		protected var _easing:Number;
		protected var _handleOverColour:Number;
		protected var _tintHandle:Boolean;
		
		/**
		 * @param p_trackWidth Width of the slider track in pixels.
		 * @param p_trackHeight Height of the slider track in pixels.
		 * @param p_handleWidth Width of the slider handle.
		 * @param p_trackColour Track colour.
		 * @param p_trackAlpha Track alpha.
		 * @param p_handleColour Handle colour.
		 * @param p_handleAlpha Handle alpha.
		 * @param p_handleOverColour Colour of handle when active.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function Slider(p_trackWidth:Number,p_trackHeight:Number,p_handleWidth:Number,p_trackColour:Number,p_trackAlpha:Number,p_handleColour:Number,p_handleAlpha:Number,p_handleOverColour:Number,p_startHidden:Boolean=false)
		{
			_trackWidth = p_trackWidth;
			_trackHeight = p_trackHeight;
			_handleWidth = p_handleWidth;
			_trackColour = p_trackColour;
			_trackAlpha = p_trackAlpha;
			_handleColour = p_handleColour;
			_handleAlpha = p_handleAlpha;
			_handleOverColour = p_handleOverColour;
			
			_isHandleDown = false;
			_easing = 1;
			_thread = new Thread(this);
			_tintHandle = true;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_track = new Button();
			_track.createHitArea(0,0,_trackWidth,_trackHeight,_trackColour,_trackAlpha);
			_track.setUseHandCursor(false);
			_track.addEventListener(ButtonEvent.CLICK,_trackClick,false,0,true);
			_holder.addChild(_track);
			
			_handle = new Sprite();
			_handle.graphics.beginFill(_handleColour,_handleAlpha);
			_handle.graphics.drawRect(0,0,_handleWidth,_trackHeight);
			_handle.graphics.endFill();
			_holder.addChild(_handle);
			
			_dragHandle = new Button();
			_dragHandle.createHitArea(0,0,_handleWidth,_trackHeight,0xff0000,0);
			_dragHandle.addEventListener(ButtonEvent.ROLL_OVER,_dragHandleMouseRollOver);
			_dragHandle.addEventListener(ButtonEvent.ROLL_OUT,_dragHandleMouseRollOut);
			_dragHandle.addEventListener(ButtonEvent.MOUSE_DOWN,_dragHandleMouseDown);
			_dragHandle.addEventListener(ButtonEvent.MOUSE_UP,_dragHandleMouseUp);
			_dragHandle.addEventListener(ButtonEvent.AS2_RELEASE_OUTSIDE,_dragHandleMouseUp);
			_holder.addChild(_dragHandle);
			
			_handleMaxX = _trackWidth-_handleWidth;
		}
		
		private function _dragHandleMouseRollOver(p_event:ButtonEvent):void
		{
			if ( _tintHandle )
			{
				TweenLite.to(_handle,0.25,{ease:Linear.easeNone,tint:_handleOverColour});
			}
		}
		
		private function _dragHandleMouseRollOut(p_event:ButtonEvent):void
		{
			if ( !_isHandleDown )
			{
				if ( _tintHandle )
				{
					TweenLite.to(_handle,0.25,{ease:Linear.easeNone,tint:_handleColour});
				}
			}
		}
		
		private function _dragHandleMouseDown(p_event:ButtonEvent):void
		{	
			_isHandleDown = true;
			
			_thread.start();
			
			_dragHandle.startDrag(false,new Rectangle(0,_dragHandle.y,_handleMaxX,0));
			
			dispatchEvent(new SliderEvent(SliderEvent.HANDLE_DOWN));
		}
		
		private function _dragHandleMouseUp(p_event:ButtonEvent):void
		{	
			_isHandleDown = false;
			
			if ( !_dragHandle.getMouseOver() )
			{
				if ( _tintHandle )
				{
					TweenLite.to(_handle,0.25,{ease:Linear.easeNone,tint:_handleColour});
				}
			}
			
			_dragHandle.stopDrag();
			
			dispatchEvent(new SliderEvent(SliderEvent.SLIDER_UPDATED));
			
			dispatchEvent(new SliderEvent(SliderEvent.HANDLE_UP));
		}
		
		private function _trackClick(p_event:ButtonEvent):void
		{	
			setPosition(MathUtils.normalise(mouseX-(_handleWidth/2),0,_handleMaxX));
		}
		
		/**
		 * Public run method for thread.
		 */
		public function run():void
		{	
			_handle.x = MathUtils.limit(MathUtils.approach(_handle.x,_dragHandle.x,_easing),0,_handleMaxX);
			
			if ( MathUtils.inRange(_handle.x,_dragHandle.x-0.25,_dragHandle.x+0.25) /* && !_isHandleDown */ )
			{
				_handle.x = _dragHandle.x;
				
				if ( !_isHandleDown )
				{
					_thread.stop();
				}
			}
			
			dispatchEvent(new SliderEvent(SliderEvent.SLIDER_UPDATING));
		}
		
		public function setTrackClickable(p_value:Boolean):void
		{
			_track.mouseChildren = p_value;
			_track.mouseEnabled = p_value;
		}
		
		/**
		 * Set a new slider position.
		 * 
		 * @param p_value Slider position as a value from 0 to 1.
		 */
		public function setPosition(p_value:Number):void
		{				
			if ( _isHandleDown || p_value == getPosition() )
			{	
				return;
			}
						
			_dragHandle.x = MathUtils.interpolate(MathUtils.limit(p_value,0,1),0,_handleMaxX);
			
			dispatchEvent(new SliderEvent(SliderEvent.SLIDER_UPDATED));
			
			_thread.start();
		}
		
		/**
		 * Return the current position of the slider as a value from 0 to 1. Any
		 * easing applied to the motion of the handle is disregarded.
		 * 
		 * @return Slider position.
		 */
		public function getPosition():Number
		{	
			return MathUtils.normalise(_dragHandle.x,0,_handleMaxX);
		}
		
		/**
		 * Return the position of the slider as a value from 0 to 1, incorporating
		 * any easing effects applied to the motion of the handle.
		 * 
		 * @return Slider's position, with easing.
		 */
		public function getEasedPosition():Number
		{	
			return MathUtils.normalise(_handle.x,0,_handleMaxX);
		}
		
		/**
		 * Resize the handle width.
		 * 
		 * @param p_value New handle width.
		 */
		public function setHandleWidth(p_value:Number):void
		{	
			var nCurrentPosition:Number = getPosition();
			
			_handleWidth = p_value;
			
			_dragHandle.width = _handleWidth;
			_handle.width = _handleWidth;
			
			_handleMaxX = _trackWidth-_handleWidth;
			
			setPosition(nCurrentPosition);
			
			_handle.x = _dragHandle.x;
		}
		
		public function setDragHandleHeight(p_value:Number):void
		{
			_dragHandle.height = p_value;
		}
		
		public function setDragHandleY(p_value:Number):void
		{
			_dragHandle.y = p_value;
		}
		
		/**
		 * Enable or disable the slide bar.
		 * 
		 * @param p_value Boolean value, enabled state of the slider.
		 */
		public function enable(p_value:Boolean):void
		{	
			_dragHandle.setEnabled(p_value);
		}
		
		/**
		 * Set the degree of easing in the motion of the slider handle. A value closer to 0
		 * will result in pronounced easing, whereas 1 (default) will exhibit no easing.
		 * 
		 * @param p_n Easing coefficient as a value between 0 and 1.
		 */
		public function setEasing(p_value:Number):void
		{	
			_easing = p_value;
		}
	}
}