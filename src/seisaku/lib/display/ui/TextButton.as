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
	
	import flash.events.MouseEvent;
	
	import seisaku.lib.display.text.Text;
	import seisaku.lib.display.text.TextStyle;
	import seisaku.lib.events.DynamicTextEvent;
	import seisaku.lib.util.DisplayObjectUtils;
	
	/**
	 * Sub-class of HideableSpriteButton that creates a simple text button by wrapping a DynamicText
	 * instance. Colour fading of the text is optionally supported on rollover/rollout etc. The mouse
	 * out colour is defined by the colour value in the DynamicTextStyle instance, whereas the
	 * mouse over colour is set seperately.
	 */
	public class TextButton extends Button
	{	
		protected var _textField:Text;
		protected var _overColour:uint;
		protected var _outColour:uint;
		protected var _fadeDuration:Number;
		protected var _doColFade:Boolean;
		protected var _style:TextStyle;
		protected var _labelText:String;
		protected var _selected:Boolean;
		
		/**
		 * @param p_labelText Text content.
		 * @param p_style TextStyle object to style the internal DynamicText instance.
		 * @param p_colFade Boolean value defining whether the button text colour fades on roll over etc.
		 * @param p_overColour Text colour for the mouse over state. Dormant/out colour specified in TextStyle instance.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function TextButton(p_labelText:String="",p_style:TextStyle=null,p_colFade:Boolean=false,p_overColour:uint=0x000000,p_startHidden:Boolean=false)
		{
			_labelText = p_labelText;
			_style = p_style;
			_doColFade = p_colFade;
			_overColour = p_overColour;
			
			_fadeDuration = 0.25;
			_outColour = p_style.colour;
			_selected = false;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_textField = new Text(_labelText,_style);
			_textField.addEventListener(DynamicTextEvent.TEXT_CHANGE,_textChange,false,0,true);
			_holder.addChild(_textField);

			createHitSprite();
			
			_resize();
		}
		
		/**
		 * Set the over colour of the TextButton, i.e. the colour the text fades
		 * to on mouse over if the instance is set to execute colour transitions.
		 * 
		 * @param p_n Colour of over state.
		 */
		public function setOverColour(p_nColour:int):void
		{
			_overColour = p_nColour;
			
			if ( _mouseOver )
			{
				TweenLite.killTweensOf(_textField);
				DisplayObjectUtils.setTint(_textField,_overColour);
			}
		}
		
		public function setOutColour(p_nColour:uint):void
		{
			_outColour = p_nColour;
			
			if ( !_mouseOver )
			{
				TweenLite.killTweensOf(_textField);
				DisplayObjectUtils.setTint(_textField,_outColour);
			}
		}
		
		/**
		 * Set whether the text button executes a colour transition on interaction.
		 * 
		 * @param p_b Boolean value.
		 */
		public function setDoColFade(p_value:Boolean):void
		{
			_doColFade = p_value;
		}
		
		/**
		 * Set the length of the rollover colour transition.
		 * 
		 * @param p_n Transition length, in seconds.
		 */
		public function setColFadeDuration(p_value:Number):void
		{
			_fadeDuration = p_value;
		}
		
		/**
		 * Return a reference to the wrapped DynamicText instance in order
		 * to change the style or text content etc.
		 */
		public function getDynamicText():Text
		{
			return _textField;
		}
		
		override public function dispose():void
		{
			_style = null;
			
			TweenLite.killTweensOf(_textField);
			_textField.dispose();
			_holder.removeChild(_textField);
			_textField = null;
			
			super.dispose();
		}
		
		protected function _resize():void
		{
			_hitSprite.x = _textField.x;
			_hitSprite.y = _textField.y;
			_hitSprite.width = _textField.getTextField().width;
			_hitSprite.height = _textField.getTextField().height;
		}
		
		public function setSelected(p_selected:Boolean):void
		{
			_selected = p_selected;
			
			if ( _selected )
			{
				if ( _doColFade )
				{
					_colFade(_overColour);
				}
			}
			else
			{
				if ( !_mouseOver )
				{
					if ( _doColFade )
					{
						_colFade(_outColour);
					}
				}
			}
		}
		
		public function getSelected():Boolean
		{
			return _selected;
		}
		
		override protected function _rollOver(p_event:MouseEvent):void
		{
			super._rollOver(p_event);
			
			if ( _doColFade )
			{
				_colFade(_overColour);
			}
		}
		
		override protected function _rollOut(p_event:MouseEvent):void
		{
			super._rollOut(p_event);
			
			if ( !_selected )
			{
				if ( _doColFade )
				{
					_colFade(_outColour);
				}
			}
		}
		
		protected function _colFade(p_tint:uint):void
		{
			TweenLite.to(_textField,_fadeDuration,{ease:Linear.easeNone,tint:p_tint});
		}
		
		private function _textChange(p_event:DynamicTextEvent):void
		{
			_resize();
		}
	}
}