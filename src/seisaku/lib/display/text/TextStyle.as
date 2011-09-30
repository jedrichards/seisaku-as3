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
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import seisaku.lib.util.ObjectUtils;
	
	/**
	 * Simple class containing style parameters for a DynamicText instance.
	 */
	public class TextStyle
	{
		public var bold:Boolean = false;
		public var align:String = TextFormatAlign.LEFT;
		public var colour:int = 0x000000;
		public var width:Number = 200;
		public var height:Number = 200;
		public var autoSize:String = TextFieldAutoSize.LEFT;
		public var size:Number = 12;
		public var multiLine:Boolean = true;
		public var wordWrap:Boolean = true;
		public var selectable:Boolean = false;
		public var condenseWhite:Boolean = false;
		public var border:Boolean = false;
		public var borderColour:Number = 0xff0000;
		public var leading:Number = 0;
		public var antiAliasType:String = AntiAliasType.NORMAL;
		public var italic:Boolean = false;
		public var gridFitType:String = GridFitType.PIXEL;
		public var thickness:Number = 0;
		public var sharpness:Number = 0;
		public var font:String = "Arial";
		public var letterSpacing:Number = 0;
		public var underline:Boolean = false;
		public var kerning:Boolean = false;
		public var embedFonts:Boolean = true;
		public var blockIndent:Number = 0;
		public var indent:Number = 0;
		public var bullet:Boolean = false;
		public var leftMargin:Number = 0;
		public var rightMargin:Number = 0;
		
		/**
		 * Return a copy/clone of the instance.
		 * 
		 * @return A duplicated TextClipStyle instance.
		 */
		public function clone():TextStyle
		{	
			return ObjectUtils.copyTyped(this,TextStyle) as TextStyle;
		}
		
		/**
		 * Set the necessary properties to create a multiline text field
		 * with a fixed width and word wrapping.
		 */
		public function makeFixedWidth(p_width:Number):void
		{	
			width = p_width;
			wordWrap = true;
			multiLine = true;
		}
		
		/**
		 * Set the necessary properties to create a multiline text field
		 * that resizes to any width, i.e. extra lines are only created
		 * if the text contents the relevant HTML markup (<p>, <br/> etc.).
		 */
		public function makeMultiLine():void
		{
			multiLine = true;
			wordWrap = false;
		}
		
		/**
		 * Set the necessary properties to create a single line text field
		 * that expands horizontally to any width.
		 */
		public function makeOneLine():void
		{	
			multiLine = false;
			wordWrap = false;
		}
	}
}