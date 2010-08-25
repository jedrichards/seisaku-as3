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
 
package seisaku.lib.display.text
{	 
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.DynamicTextEvent;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Subclass of HideableSprite that wraps a dynamic textfield. Abstracts the slightly
	 * lengthy/fiddly process of styling a TextField from scratch by accepting a
	 * DynamicTextStyle instance to the constructor. Designed for use with non-editable
	 * text fields displaying embedded fonts.
	 * 
	 * <p>You can listen for changes to the text content or style of the instance via the
	 * DynamicTextEvent.TEXT_CHANGE event.</p>
	 */
	public class Text extends HideableSprite
	{
		
		protected var _textField:TextField;
		protected var _style:TextStyle;
		protected var _format:TextFormat;
		protected var _text:String;
		
		/**
		 * @param p_text Text content, defaults to an empty string.
		 * @param p_style DynamicTextStyle object to style the captive textfield.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function Text(p_text:String="",p_style:TextStyle=null,p_startHidden:Boolean=false)
		{
			_text = p_text;			
			_style = p_style == null ? new TextStyle() : p_style;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_textField = new TextField();
			_holder.addChild(_textField);
			
			_refresh();
		}
		
		/**
		 * Apply a new style to the instance.
		 * 
		 * @param p_style New style object.
		 */
		public function setStyle(p_style:TextStyle):void
		{	
			_style = p_style.clone();
			
			_refresh();
			
			dispatchEvent(new DynamicTextEvent(DynamicTextEvent.TEXT_CHANGE));
		}
		
		public function getStyle():TextStyle
		{
			return _style.clone();
		}
		
		/**
		 * Set the text.
		 * 
		 * @param p_s New text content.
		 */
		public function setText(p_text:String):void
		{	
			_text = p_text;
			
			_setText();
			
			dispatchEvent(new DynamicTextEvent(DynamicTextEvent.TEXT_CHANGE));
		}
		
		/**
		 * Get the current text.
		 */
		public function getText():String
		{	
			return _text;
		}
		
		/**
		 * Return a reference to the composited TextField instance.
		 * 
		 * @return Internal text field.
		 */
		public function getTextField():TextField
		{	
			return _textField;
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		override public function dispose():void
		{
			_format = null;
			_style = null;
			
			_holder.removeChild(_textField);
			_textField = null;
			
			super.dispose();
		}
		
		protected function _refresh():void
		{	
			_textField.antiAliasType = _style.antiAliasType;
			_textField.gridFitType = _style.gridFitType;
			_textField.thickness = _style.thickness;
			_textField.sharpness = _style.sharpness;
			_textField.multiline = _style.multiLine;
			_textField.wordWrap = _style.wordWrap;
			_textField.embedFonts = _style.embedFonts;
			_textField.width = _style.width;
			_textField.height = _style.height;
			_textField.selectable = _style.selectable;
	        _textField.condenseWhite = _style.condenseWhite;
	        _textField.border = _style.border;
	        _textField.borderColor = _style.borderColour;

			_setText();
			
			_format = new TextFormat();
			_format.leading = _style.leading;
			_format.bold = _style.bold ? true : null;
	        _format.italic = _style.italic ? true : null;
	        _format.underline = _style.underline ? true : null;
	        _format.bullet = _style.bullet ? true : null;
	        _format.align = _style.align;
			_format.letterSpacing = _style.letterSpacing;
			_format.underline = _style.underline;
			_format.kerning = _style.kerning;
			_format.indent = _style.indent;
			_format.blockIndent = _style.blockIndent;
			_format.leftMargin = _style.leftMargin;
			_format.rightMargin = _style.rightMargin;
			
			_textField.setTextFormat(_format);
			_textField.defaultTextFormat = _format;
			
			_textField.autoSize = _style.autoSize;
		}
		
		protected function _setText():void
		{	
			_textField.htmlText = "<font face='"+_style.font+"' size='"+_style.size+"' color='#"+MathUtils.hexToString(_style.colour)+"'>"+_text+"</font>";
		}
	}
}