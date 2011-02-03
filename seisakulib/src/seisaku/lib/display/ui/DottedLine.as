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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Uses BitmapData to draw a dotted line.
	 */
	public class DottedLine extends HideableSprite
	{
		private var _length:Number;
		private var _bitmap:Bitmap;
		private var _lineHolderMask:Shape;
		private var _bitmapData:BitmapData;
		private var _colour:Number;
		private var _alpha:Number;
		private var _size:Number;
		private var _spacing:Number;
		
		public function DottedLine(p_length:Number,p_colour:Number,p_size:Number=2,p_spacing:Number=3,p_alpha:Number=1,p_startHidden:Boolean=false)
		{
			_length = p_length;
			_colour = MathUtils.rgbToARGB(p_colour,255);
			_size = p_size;
			_alpha = p_alpha;
			_spacing = p_spacing;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_bitmapData = new BitmapData(_length,_size,true,0);
			_bitmapData.lock();
			
			var numSteps:Number = Math.floor(_length/(_size+_spacing));
			var xPos:Number = 0;
			for ( var i:Number=0; i<numSteps; i++ )
			{	
				_bitmapData.fillRect(new Rectangle(xPos,0,_size,_size),_colour);
				
				xPos += _size+_spacing;
				/*if ( MathUtils.isEven(i) )
				{
					_bitmapData.fillRect(new Rectangle(i*_size,0,_size,_size),_colour);
				}*/
			}
			
			_bitmapData.unlock();
			
			_bitmap = new Bitmap(_bitmapData,PixelSnapping.ALWAYS,false);
			_bitmap.alpha = _alpha;
			_holder.addChild(_bitmap);
		}
	}
}