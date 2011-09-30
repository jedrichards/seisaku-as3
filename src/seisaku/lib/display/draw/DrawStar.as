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
 
package seisaku.lib.display.draw
{	 
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * Contains a static method for drawing a star with the drawing API.
	 */
	public class DrawStar
	{	
		/**
		 * Draw a star.
		 * 
		 * @param p_g Target Graphics instance.
		 * @param p_center Origin of the star in the Graphics instance's coordinate space.
		 * @param p_numPoints Number of points. Math.abs(p_nNumPoints) must be greater than 2.
		 * @param p_innerRad Radius of the indent of the points.
		 * @param p_outerRad Radius of the tips of the points.
		 * @param p_angle Optional starting angle in degrees, defaults to 0.
		 */
		public static function draw(p_g:Graphics,p_center:Point,p_numPoints:Number,p_innerRad:Number,p_outerRad:Number,p_angle:Number=0):void
		{
			var count:Number = Math.abs(p_numPoints);
			
			if ( count>2 )
			{
				var step:Number;
				var halfStep:Number;
				var start:Number;
				var dX:Number;
				var dY:Number;
				
				step = (Math.PI*2)/p_numPoints;
				halfStep = step/2;
				start = (p_angle/180)*Math.PI;
				
				p_g.moveTo(p_center.x+(Math.cos(start)*p_outerRad), p_center.y-(Math.sin(start)*p_outerRad));
				
				for (var i:Number=1; i<=count; i++)
				{	
					dX = p_center.x+Math.cos(start+(step*i)-halfStep)*p_innerRad;
					dY = p_center.y-Math.sin(start+(step*i)-halfStep)*p_innerRad;
					
					p_g.lineTo(dX,dY);
					
					dX = p_center.x+Math.cos(start+(step*i))*p_outerRad;
					dY = p_center.y-Math.sin(start+(step*i))*p_outerRad;
					
					p_g.lineTo(dX,dY);
				}
			}
		}
	}
}