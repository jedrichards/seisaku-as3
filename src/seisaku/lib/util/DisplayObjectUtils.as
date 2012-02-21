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
 
package seisaku.lib.util {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A set of static methods for working with DisplayObject and its subclasses.
	 */
	public class DisplayObjectUtils
	{	
		/**
		 * Remove all children from a DisplayObjectContainer.
		 * 
		 * @param p_target DisplayObject instance to iterate over and remove children.
		 */
		public static function removeChildren(p_target:DisplayObjectContainer):void
		{	
    		while ( p_target.numChildren )
    		{
				p_target.removeChildAt(0);
        	}
		}

		/**
		 * Set the RGB tint of a display object via ColorTransform.
		 * 
		 * @param p_target DisplayObject instance to modify.
		 * @param p_nColour RGB uint value.
		 */
		public static function setTint(p_target:DisplayObject,p_colour:uint):void
		{	
			var colTrans:ColorTransform = new ColorTransform();
			colTrans.color = p_colour;
			p_target.transform.colorTransform = colTrans;
		}
		
		/**
		 * Remove the effects of a ColorTransform.
		 * 
		 * @param p_target DisplayObject instance to modify.
		 * @param p_nColour RGB uint value.
		 */
		public static function clearTint(p_target:DisplayObject):void
		{	
			p_target.transform.colorTransform = new ColorTransform();
		}
		
		/**
		 * Center a DisplayObject within an arbitrary rectangle.
		 * 
		 * @param p_target DisplayObject to center.
		 * @param p_rect Rectangle instance.
		 * @param p_snap Whether to snap the DisplayObject to whole numbered pixels after the translation.
		 */
		public static function centerInRect(p_target:DisplayObject,p_rect:Rectangle,p_snap:Boolean=true):void
		{			
			p_target.x = p_rect.x+(p_rect.width/2)-(p_target.width/2);
			p_target.y = p_rect.y+(p_rect.height/2)-(p_target.height/2);
			
			var bounds:Rectangle = p_target.getBounds(p_target);
			p_target.x -= bounds.x;
			p_target.y -= bounds.y;
			
			if ( p_snap )
			{
				snap(p_target);
			}
		}
		
		/**
		 * Center a DisplayObject to its parent's (0,0) reference point.
		 * 
		 * @param p_target DisplayObject to center.
		 * @param p_snap Whether to snap the DisplayObject to whole numbered pixels after the translation.
		 */
		public static function centreToOrigin(p_target:DisplayObject,p_snap:Boolean=true):void
		{	
			p_target.x = -(p_target.width/2);
			p_target.y = -(p_target.height/2);
			
			var bounds:Rectangle = p_target.getBounds(p_target);
			p_target.x -= bounds.x;
			p_target.y -= bounds.y;
			
			if ( p_snap )
			{
				snap(p_target);
			}
		}
		
		/**
		 * Center a DisplayObject with respect to its parents width and height.
		 * 
		 * @param p_target DisplayObject instance to center.
		 * @param p_snap Whether to snap the DisplayObject to whole numbered pixels after the translation.
		 */
		public static function centerInParent(p_target:DisplayObject,p_snap:Boolean=true):void
		{	
			if ( p_target.parent == null )
			{
				throw(new Error("DisplayObjectUtils: target DisplayObject has no reference to its parent"));
			}
			
			var bounds:Rectangle = p_target.parent.getBounds(p_target.parent);
			
			centerInRect(p_target,new Rectangle(0,0,bounds.width+bounds.x,bounds.height+bounds.y),p_snap);
		}
		
		/**
		 * Center a DisplayObject in the stage.
		 * 
		 * @param p_stage Reference to the stage.
		 * @param p_snap Whether to snap the DisplayObject to whole numbered pixels after the translation.
		 */
		public static function centerInStage(p_target:DisplayObject,p_stage:Stage,p_snap:Boolean=true):void
		{	 
			if ( p_target.parent == null )
			{
				throw(new Error("Target DisplayObject has no reference to its parent"));
			}
			
			var stageCentre:Point = p_target.parent.globalToLocal(new Point(p_stage.stageWidth/2,p_stage.stageHeight/2));
						
			p_target.x = stageCentre.x-(p_target.width/2);
			p_target.y = stageCentre.y-(p_target.height/2);
			
			var bounds:Rectangle = p_target.getBounds(p_target);
			p_target.x -= bounds.x;
			p_target.y -= bounds.y;
			
			if ( p_snap )
			{
				snap(p_target);
			}
		}
		
		/**
		 * Snap a DisplayObject's x and y position to whole numbered pixels.
		 * 
		 * @param p_target DisplayObject to position.
		 */
		public static function snap(p_target:DisplayObject):void
		{
			p_target.x = Math.round(p_target.x);
			p_target.y = Math.round(p_target.y);
		}
		
		/**
		 * Return a Matrix suitable for transforming a DisplayObject to fit inside
		 * an arbitrary rectangle.
		 * 
		 * @param p_target DisplayObject to resize/fit into the rectangle
		 * @param p_rect Rectangle to fit the DisplayObject into
		 * @param p_fillRect If true the DisplayObject will totally fill the rectangle, potentially with cropping
		 * @param p_align How to align the DisplayObject inside the rectangle, values are C,T,L,R,B,TL,TR,BL,BR
		 */
		public static function getFitToRectMatrix(p_target:DisplayObject,p_rect:Rectangle,p_fillRect:Boolean=true,p_align:String="C"):Matrix
		{
			var matrix : Matrix = new Matrix();
			
			var wD : Number = p_target.width / p_target.scaleX;
			var hD : Number = p_target.height / p_target.scaleY;
			var wR : Number = p_rect.width;
			var hR : Number = p_rect.height;
			var sX : Number = wR / wD;
			var sY : Number = hR / hD;
			var rD : Number = wD / hD;
			var rR : Number = wR / hR;
			var sH : Number = p_fillRect ? sY : sX;
			var sV : Number = p_fillRect ? sX : sY;
			var s : Number = rD >= rR ? sH : sV;
			var w : Number = wD * s;
			var h : Number = hD * s;
			var tX : Number = 0.0;
			var tY : Number = 0.0;
			
			switch (p_align)
			{
				case "L":
				case "TL":
				case "BL":
				tX = 0.0;
				break;
					
				case "R":
				case "TR":
				case "BR":
				tX = w - wR;
				break;
					
				default : 					
				tX = 0.5 * (w - wR);
			}
			
			switch (p_align)
			{
				case "T":
				case "TL":
				case "TR":
				tY = 0.0;
				break;
					
				case "B":
				case "BL":
				case "BR":
				tY = h - hR;
				break;
					
				default : 					
				tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s,s);
			matrix.translate(p_rect.left-tX,p_rect.top-tY);
			
			return matrix;
		}
		
		/**
		 * Return the BitmapData representation of a DisplayObject. This method will
		 * return BitmapData of the entire DisplayObject even if some or all of its
		 * graphical content exists in the negative x/y coordinate spaces.
		 * 
		 * @param p_target DisplayObject instance to copy to BitmapData.
		 */
		public static function getBitmapData(p_target:DisplayObject):BitmapData
		{	
			var bounds:Rectangle = p_target.getBounds(p_target);
			
			var bitmap:BitmapData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			bitmap.draw(p_target,new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			
			return bitmap;
		}
		
		public static function cropBitmapData(p_bitmapData:BitmapData,p_x:Number,p_y:Number,p_width:Number,p_height:Number):BitmapData
		{
			var crop:BitmapData = new BitmapData(p_width,p_height);
			
			crop.copyPixels(p_bitmapData,new Rectangle(p_x,p_y,p_width,p_height),new Point(0,0));
			
			return crop;
		}
		
		/**
		 * Sort a DisplayObjectContainer's children's indices based on a particular child property.
		 * For example, sort child depth based on y position.
		 * 
		 * @param p_target Parent DisplayObjectContainer to sort through.
		 * @param p_prop String representation of the child property to sort on.
		 * @param p_options Options object to pass to the Array.sortOn method.
		 */
		public static function sortChildren(p_target:DisplayObjectContainer,p_prop:String,p_options:Object=null):void
		{
			var numChildren:uint = p_target.numChildren;
			
			if ( numChildren < 2 )
			{
				return;
			}
			
			var temp:Array = new Array();
			
			for ( var i:uint=0; i<numChildren; i++ )
			{
				temp.push(p_target.getChildAt(i));
			}
			
			temp.sortOn(p_prop,p_options);

			var j:int = numChildren;
			
		    while (j--)
		    {
		        if (p_target.getChildIndex(temp[j]) != j)
		        {
		            p_target.setChildIndex(temp[j], j);
		        }
		    }
		}
		
		/**
		 * Quickly draw a rectangle and specify its colour and alpha values.
		 * 
		 * @param p_graphics Target Graphics instance
		 * @param p_colour Colour of the rectangle
		 * @param p_alpha Alpha of the rectangle
		 */
		public static function drawRect(p_graphics:Graphics,p_rect:Rectangle,p_colour:uint=0,p_alpha:Number=1):void
		{
			p_graphics.beginFill(p_colour,p_alpha);
			p_graphics.drawRect(p_rect.x,p_rect.y,p_rect.width,p_rect.height);
			p_graphics.endFill();
		}
		
		/**
		 * Quickly draw a rounded rectangle and specify its colour and alpha values.
		 * 
		 * @param p_graphics Target Graphics instance
		 * @param p_colour Colour of the rectangle
		 * @param p_alpha Alpha of the rectangle
		 */
		public static function drawRoundedRect(p_graphics:Graphics,p_rect:Rectangle,p_ellipseWidth:Number,p_ellipseHeight:Number,p_colour:uint,p_alpha:Number):void
		{
			p_graphics.beginFill(p_colour,p_alpha);
			p_graphics.drawRoundRect(p_rect.x,p_rect.y,p_rect.width,p_rect.height,p_ellipseWidth,p_ellipseHeight);
			p_graphics.endFill();
		}
		
		/**
		 * Map a point from one DisplayObject's coordinate space to another DisplayObject's
		 * coordinate space.
		 * 
		 * @param p_point Point to map
		 * @param p_currentScope DisplayObject containing point
		 * @param p_targetScope DisplayObject to map to
		 */
		public static function mapPoint(p_point:Point,p_currentScope:DisplayObject,p_targetScope:DisplayObject):Point
		{
			var mappedPoint:Point = p_currentScope.localToGlobal(p_point);
			
			return p_targetScope.globalToLocal(mappedPoint);
		}
	}
}