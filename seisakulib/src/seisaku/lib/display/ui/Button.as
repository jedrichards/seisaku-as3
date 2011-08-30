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
	 
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.ButtonEvent;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.ObjectUtils;
	
	/**
	 * Sub-class of HideableSprite that acts as a button via a composited hit area Sprite.
	 * 
	 * <p>The hit area sprite has various mouse events automatically added when the hit area
	 * is created, so in order add button functionality (roll over effects etc.) overwrite the
	 * relevant protected methods. To respond to button interaction externally to the class
	 * listen to the HideableSpriteButtonEvent objects that are dispatched.</p>
	 * 
	 * <p>HideableSpriteButton can be identified in a collection of buttons by setting the
	 * value of the public id property.</p>
	 * 
	 * @see seisaku.lib.events.HideableSpriteButtonEvent HideableSpriteButtonEvent
	 */
	public class Button extends HideableSprite
	{
		protected var _hitSprite:Sprite;
		protected var _mouseOver:Boolean;
		protected var _enabled:Boolean;
		
		public var id:Number;
		
		/**
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function Button(p_startHidden:Boolean=false)
		{	
			_enabled = true;
			_mouseOver = false;
			
			super(p_startHidden);
		}
		
		/**
		 * Create a rectangular sprite within the scope of the HideableSpriteButton to use as a hit area.
		 * If no size metrics are supplied it will size itself to the current size of the parent.
		 * 
		 * @param p_x x position for the hit area.
		 * @param p_y y position for the hit area.
		 * @param p_width hit area width.
		 * @param p_height hit area height.
		 */
		public function createHitSprite(p_x:Number=0,p_y:Number=0,p_width:Number=0,p_height:Number=0,p_colour:uint=0,p_alpha:Number=0):void
		{				
			if ( p_width == 0 )
			{
				p_width = width;
			}
			
			if ( p_height == 0 )
			{
				p_height = height;
			}
			
			var hitSprite:Sprite = new Sprite();
			hitSprite.x = p_x;
			hitSprite.y = p_y;
			
			hitSprite.graphics.beginFill(p_colour,p_alpha);
			hitSprite.graphics.drawRect(0,0,p_width,p_height);
			hitSprite.graphics.endFill();
			
			_setHitSprite(hitSprite);
		} 
		
		/**
		 * Create a circular sprite within the scope of the HideableSpriteButton to use as a hit area.
		 * 
		 * @param p_x x position for the hit area.
		 * @param p_y y position for the hit area.
		 * @param p_width hit area width.
		 * @param p_height hit area height.
		 */
		public function createCircleHitSprite(p_x:Number,p_y:Number,p_radius:Number,p_colour:uint=0,p_alpha:Number=0):void
		{
			var hitSprite:Sprite = new Sprite();
			hitSprite.x = p_x;
			hitSprite.y = p_y;
			
			hitSprite.graphics.beginFill(p_colour,p_alpha);
			hitSprite.graphics.drawCircle(0,0,p_radius);
			hitSprite.graphics.endFill();
			
			_setHitSprite(hitSprite);
		}
		
		protected function _setHitSprite(p_hitSprite:Sprite):void
		{
			if ( _hitSprite )
			{	
				Debug.logClassError(this,"_setHitSprite","Cannot set new hit sprite, one already exists");
				return;
			}
			
			_hitSprite = p_hitSprite;
			_hitSprite.buttonMode = true;
			_hitSprite.tabEnabled = false;
			_holder.addChild(_hitSprite);
			
			_hitSprite.addEventListener(MouseEvent.CLICK,_click,false,0,true);
			_hitSprite.addEventListener(MouseEvent.DOUBLE_CLICK,_doubleClick,false,0,true);
			_hitSprite.addEventListener(MouseEvent.MOUSE_DOWN,_mouseDown,false,0,true);
			_hitSprite.addEventListener(MouseEvent.MOUSE_UP,_mouseUp,false,0,true);
			_hitSprite.addEventListener(MouseEvent.ROLL_OUT,_rollOut,false,0,true);
			_hitSprite.addEventListener(MouseEvent.ROLL_OVER,_rollOver,false,0,true);
			_hitSprite.addEventListener(MouseEvent.MOUSE_MOVE,_mouseMove,false,0,true);
		}
		
		protected function _removeHitSprite():void
		{
			if ( !_hitSprite ) 
			{
				Debug.logClassError(this,"_setHitSprite","Cannot remove hit sprite, it does not exist");
				return;
			}
			
			_hitSprite.removeEventListener(MouseEvent.CLICK,_click);
			_hitSprite.removeEventListener(MouseEvent.DOUBLE_CLICK,_doubleClick);
			_hitSprite.removeEventListener(MouseEvent.MOUSE_DOWN,_mouseDown);
			_hitSprite.removeEventListener(MouseEvent.MOUSE_UP,_mouseUp);
			_hitSprite.removeEventListener(MouseEvent.ROLL_OUT,_rollOut);
			_hitSprite.removeEventListener(MouseEvent.ROLL_OVER,_rollOver);
			_hitSprite.removeEventListener(MouseEvent.MOUSE_MOVE,_mouseMove);
			
			removeChild(_hitSprite);
			
			_hitSprite = null;
		}
		
		/**
		 * Resize the hit area to a new width and height.
		 * If no size metrics are supplied it will size itself to the current size of the parent.
		 * 
		 * @param p_nWidth Hit area width.
		 * @param p_nHeight Hit area height.
		 */
		public function resizeHitArea(p_width:Number=0,p_height:Number=0):void
		{
			if ( !_hitSprite )
			{
				Debug.logClassError(this,"resizeHitArea","Cannot resize hit sprite, it does not exist");
				return;
			}
			
			_hitSprite.width = p_width == 0 ? _hitSprite.width : p_width;
			_hitSprite.height = p_height == 0 ? _hitSprite.height : p_height;
		}
		
		/**
		 * Translate the hit area in the x and y.
		 * 
		 * @param p_nX Hit area x position.
		 * @param p_nY Hit area y position.
		 */
		public function moveHitSprite(p_x:Number,p_y:Number):void
		{
			if ( !_hitSprite )
			{
				Debug.logClassError(this,"moveHitSprite","Cannot move hit sprite, it does not exist");
				return;
			}
			
			_hitSprite.x = p_x;
			_hitSprite.y = p_y;
		}
				
		/**
		 * Set whether to use a hand cursor when hovering over the hit area.
		 * 
		 * @param p_b Boolean value.
		 */
		public function setUseHandCursor(p_value:Boolean):void
		{
			_hitSprite.useHandCursor = p_value;
		}
		
		/**
		 * Set the enabled state of the HideableSpriteButton.
		 * 
		 * @param p_bEnabled Boolean value.
		 */
		public function setEnabled(p_value:Boolean):void
		{
			_enabled = p_value;
			
			mouseChildren = _enabled;
		}
		
		/**
		 * Get the enabled state of the HideableSpriteButton.
		 * 
		 * @return Enabled state boolean value.
		 */
		public function getEnabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * Toggle on/off the enabled state of the HideableSpriteButton.
		 */
		public function toggleEnabled():void
		{
			setEnabled(!_enabled);
		}
		
		/**
		 * Get the mouse over state.
		 */
		public function getMouseOver():Boolean
		{
			return _mouseOver;
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		override public function dispose():void
		{
			if ( _hitSprite ) _removeHitSprite();
			
			super.dispose();
		}
		
		override protected function _showStart():void
		{
			super._showStart();
			
			setEnabled(_enabled);
		}
		
		override protected function _hideStart():void
		{
			super._hideStart();
			
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		protected function _rollOver(p_event:MouseEvent):void
		{
			_mouseOver = true;
			
			dispatchEvent(_getEvent(ButtonEvent.ROLL_OVER));
			
			if ( p_event.buttonDown )
			{
				_dragOver();
			}
		}
		
		protected function _rollOut(p_event:MouseEvent):void
		{
			_mouseOver = false;
			
			dispatchEvent(new ButtonEvent(ButtonEvent.ROLL_OUT));
			
			if ( p_event.buttonDown && _hitSprite.stage != null )
			{
				_dragOut();
			}
		}
				
		protected function _mouseDown(p_event:MouseEvent):void
		{
			dispatchEvent(_getEvent(ButtonEvent.MOUSE_DOWN));
			
			stage.addEventListener(MouseEvent.MOUSE_UP,_onStageMouseUp,false,0,true);
		}
		
		protected function _mouseUp(p_event:MouseEvent):void
		{
			dispatchEvent(_getEvent(ButtonEvent.MOUSE_UP));
			
			stage.removeEventListener(MouseEvent.MOUSE_UP,_onStageMouseUp);
		}
		
		protected function _mouseMove(p_event:MouseEvent):void
		{
			dispatchEvent(_getEvent(ButtonEvent.MOUSE_MOVE));
		}
		
		private function _onStageMouseUp(p_event:MouseEvent):void
		{
			_releaseOutside();
			
			stage.removeEventListener(MouseEvent.MOUSE_UP,_onStageMouseUp);
		}
		
		protected function _click(p_event:MouseEvent):void
		{
			dispatchEvent(_getEvent(ButtonEvent.CLICK));
		}
		
		protected function _doubleClick(p_event:MouseEvent):void
		{
			dispatchEvent(_getEvent(ButtonEvent.DOUBLE_CLICK));
		}
		
		protected function _dragOver():void
		{
			dispatchEvent(_getEvent(ButtonEvent.AS2_DRAG_OVER));
		}
		
		protected function _dragOut():void
		{
			dispatchEvent(_getEvent(ButtonEvent.AS2_DRAG_OUT));
		}
		
		protected function _releaseOutside():void
		{
			dispatchEvent(_getEvent(ButtonEvent.AS2_RELEASE_OUTSIDE));
		}
		
		protected function _getEvent(p_type:String):ButtonEvent
		{
			var event:ButtonEvent = new ButtonEvent(p_type);
			
			event.id = id;
			
			return event;
		}
	}
}