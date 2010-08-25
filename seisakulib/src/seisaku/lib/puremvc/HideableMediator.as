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
 
package seisaku.lib.puremvc
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.HideableSpriteEvent;
	
	/**
	 * PureMVC mediator that uses a HideableSprite as its base view component. Use the
	 * <code>_addComponent</code> method to add child components to the base view component.
	 */
	public class HideableMediator extends Mediator implements IMediator
	{
		protected var _isFirstShow:Boolean;
		protected var _base:HideableSprite;
		
		public function HideableMediator(p_mediatorName:String=null,p_viewComponent:Object=null)
		{
			super(p_mediatorName,p_viewComponent);
		}
		
		override public function onRegister():void
		{
			_isFirstShow = true;
			
			_base = new HideableSprite();
			_base.addEventListener(HideableSpriteEvent.SHOW,_baseShowStart);
			_base.addEventListener(HideableSpriteEvent.SHOW_COMPLETE,_baseShowComplete);
			_base.addEventListener(HideableSpriteEvent.HIDE,_baseHideStart);
			_base.addEventListener(HideableSpriteEvent.HIDE_COMPLETE,_baseHideComplete);
			viewComponent.addChild(_base);
		}
		
		/**
		 * Return a reference to the base HideableSprite. All child components of this
		 * mediator should be added to the base HideableSprites holder to be included
		 * in the show/hide operations.
		 */
		public function getBase():HideableSprite
		{
			return _base;
		}
		
		/**
		 * Show this HideableMediator.
		 * 
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade in (animate) while showing.
		 * @param p_delay Optional delay in seconds until the show starts.
		 */
		public function show(p_fade:Boolean=true,p_delay:Number=0):void
		{
			_base.show(p_fade,p_delay);
		}
		
		/**
		 * Hide this HideableMediator.
		 * 
		 * @param p_fade Optional boolean value specifying whether the HideableSprite should fade out (animate) while hiding.
		 * @param p_delay Optional delay in seconds until the hide starts.
		 */
		public function hide(p_fade:Boolean=true,p_delay:Number=0):void
		{
			_base.hide(p_fade,p_delay);
		}
		
		protected function _baseShowStart(p_event:HideableSpriteEvent):void
		{
			if ( _isFirstShow )
			{
				_isFirstShow = false;
				
				_firstShow();
			}
		}
		
		protected function _baseShowComplete(p_event:HideableSpriteEvent):void
		{
		}
		
		protected function _baseHideStart(p_event:HideableSpriteEvent):void
		{
		}
		
		protected function _baseHideComplete(p_event:HideableSpriteEvent):void
		{
		}
		
		protected function _firstShow():void
		{
		}
		
		protected function _addComponent(p_child:DisplayObject):void
		{
			_base.addChildToHolder(p_child);
		}
	}
}