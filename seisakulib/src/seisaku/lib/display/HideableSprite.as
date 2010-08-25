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

package seisaku.lib.display
{	 
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import seisaku.lib.events.HideableSpriteEvent;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.DisplayObjectUtils;
	import seisaku.lib.util.ObjectUtils;
	
	/**
	 * Sub-class of Sprite that provides methods for showing and hiding itself. By default
	 * the show/hide effect just involves a fade between 0 and 1 alpha values, with the object
	 * setting its visibility to false upon completetion of a hide operation. The alpha values
	 * for the show and hide states can be easily customised, along with the duration of the
	 * fade.
	 * 
	 * <p>In order to achieve more complex show/hide effects (for example, sliding in and out
	 * child objects, blurs etc.) overwrite or extend the <code>_doShow</code> and 
	 * <code>_doHide</code> methods. Take care that the <code>_showStart</code>, 
	 * <code>_showComplete</code>, <code>_hideStart</code> and <code>_hideComplete</code> methods
	 * are still called by your custom show/hide code at the appropriate moments if you require
	 * this type of functionality.</p>
	 * 
	 * <p>By default show/hide operations are performed on the child Sprite <code>_holder</code>,
	 * so add your child elements to <code>_holder</code> for them to be shown and hidden along with
	 * the main instance. It will be assumed safe to start and cancel tweens on <code>_holder</code>
	 * at anytime. Be sure to override and extend the <code>_createChildren</code> method
	 * to build your instance.</p>
	 * 
	 * @see seisaku.lib.events.HideableSpriteEvent HideableSpriteEvent
	 */
	public class HideableSprite extends Sprite
	{	
		public static const NAME:String = "HideableSprite";
		
		protected var _showHideDuration:Number;
		protected var _showAlpha:Number;
		protected var _hideAlpha:Number;
		protected var _isShowing:Boolean;
		protected var _holder:Sprite;
		
		/**
		 * @param p_startHidden Whether to create the instance on stage in a hidden state.
		 */
		public function HideableSprite(p_startHidden:Boolean=false)
		{
			_showHideDuration = 0.5;
			_showAlpha = 1;
			_hideAlpha = 0;
			_isShowing = true;

			_createChildren();
			
			if ( p_startHidden )
			{
				hide(false);
			}
		}
		
		/**
		 * Show the HideableSprite.
		 * 
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade in (animate) while showing.
		 * @param p_delay Optional delay in seconds until the show starts.
		 */
		public function show(p_fade:Boolean=true,p_delay:Number=0):void
		{	
			if ( _isShowing )
			{
				return;
			}
			
			_isShowing = true;
			
			_doShow(p_fade?_showHideDuration:0,p_delay);
		}
		
		/**
		 * Hide the HideableSprite.
		 * 
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade out (animate) while hiding.
		 * @param p_delay Optional delay in seconds until the hide starts.
		 */
		 public function hide(p_fade:Boolean=true,p_delay:Number=0):void
		 {	
		 	if ( !_isShowing )
		 	{
		 		return;
		 	}
		 	
			_isShowing = false;
			
			_doHide(p_fade?_showHideDuration:0,p_delay);
		} 
		
		/**
		 * Get the current show/hide state.
		 * 
		 * @return The show/hide state as a boolean.
		 */
		public function getShowing():Boolean
		{	
			return _isShowing;
		}
		
		/**
		 * Show or hide the HideableSprite.
		 * 
		 * @param p_bShow Boolean value specifying show/hide state.
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade out (animate) while hiding.
		 * @param p_delay Optional delay in seconds until the hide starts.
		 */
		public function setShowing(p_showing:Boolean,p_fade:Boolean=true,p_delay:Number=0):void
		{	
			if ( p_showing )
			{
				show(p_fade,p_delay);
			}
			else
			{
				hide(p_fade,p_delay);
			}
		} 
		
		/**
		 * Toggle between the show/hide states.
		 * 
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade out (animate) while hiding.
		 * @param p_delay Optional delay in seconds until the hide starts.
		 */
		public function toggleShowing(p_fade:Boolean=true,p_delay:Number=0):void
		{	
			setShowing(!_isShowing,p_fade,p_delay);
		}
		
		/**
		 * Set the duration for the show/hide fade animation, in seconds.
		 * 
		 * @param p_value Show/hide duration.
		 */
		public function setShowHideDuration(p_value:Number):void
		{	
			_showHideDuration = p_value;
		}
		
		/**
		 * Set the alpha value for the show state.
		 * 
		 * @param p_value Show state alpha.
		 */
		public function setShowAlpha(p_value:Number):void
		{	
			_showAlpha = p_value;
		}
		
		/**
		 * Set the alpha value for the hide state.
		 * 
		 * @param p_value Hide state alpha.
		 */
		public function setHideAlpha(p_value:Number):void
		{	
			_hideAlpha = p_value;
		}
		
		/**
		 * Add a DisplayObject to the internal _holder sprite.
		 *
		 * @param p_child Child DisplayObject to add.
		 */
		public function addChildToHolder(p_child:DisplayObject):void
		{
			_holder.addChild(p_child);
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		public function dispose():void
		{
			removeEventListener(Event.ADDED,_added);
			
			if ( _holder )
			{
				TweenLite.killTweensOf(_holder);
				
				DisplayObjectUtils.removeChildren(_holder);
				
				removeChild(_holder);
				_holder = null;
			}
		}
		
		protected function _createChildren():void
		{
			_holder = new Sprite();
			addChild(_holder);
			
			addEventListener(Event.ADDED,_added,false,0,true);
		}
		
		private function _added(p_event:Event):void
		{
			if ( DisplayObject(p_event.target).parent == this )
			{
				Debug.log(ObjectUtils.getClassName(this)+": warning, add child objects to _holder",Debug.L2_WARNING);
			}
		}
		
		protected function _doShow(p_duration:Number,p_delay:Number):void
		{	
			TweenLite.to(_holder,p_duration,{delay:p_delay,overwrite:OverwriteManager.ALL_IMMEDIATE,autoAlpha:_showAlpha,ease:Linear.easeNone,onStart:_showStart,onComplete:_showComplete});
		}
		
		protected function _doHide(p_duration:Number,p_delay:Number):void
		{	
			TweenLite.to(_holder,p_duration,{delay:p_delay,overwrite:OverwriteManager.ALL_IMMEDIATE,autoAlpha:_hideAlpha,ease:Linear.easeNone,onStart:_hideStart,onComplete:_hideComplete});
		}
		
		protected function _showStart():void
		{	
			dispatchEvent(new HideableSpriteEvent(HideableSpriteEvent.SHOW));
		}
		
		protected function _showComplete():void
		{	
			dispatchEvent(new HideableSpriteEvent(HideableSpriteEvent.SHOW_COMPLETE));
		}
		
		protected function _hideStart():void
		{	
			dispatchEvent(new HideableSpriteEvent(HideableSpriteEvent.HIDE));
		}
		
		protected function _hideComplete():void
		{	
			dispatchEvent(new HideableSpriteEvent(HideableSpriteEvent.HIDE_COMPLETE));
		}
	}
}