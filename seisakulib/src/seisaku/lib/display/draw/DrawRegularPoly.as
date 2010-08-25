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
	import flash.geom.Point;
	import flash.display.Graphics;
	
	/**
	 * Contains a static method for drawing a regular polygon, i.e. a polygon that
	 * is both cyclic and equilateral, with an arbitrary number of sides.
	 * 
	 * <p>Tip: draw an equilateral triangle by specifying just 3 sides.</p>
	 */
	public class DrawRegularPoly
	{	
		/**
		 * Draw a regular polygon.
		 * 
		 * @param p_g Target Graphics instance.
		 * @param p_center Origin of the polygon in the Graphic instance's coordinate space.
		 * @param p_numSides Number of sides of the polygon.
		 * @param p_rad Radius of the polygon.
		 * @param p_angle Starting angle, in degrees. Defaults to 0.
		 */
		public static function draw(p_g:Graphics,p_center:Point,p_numSides:Number,p_rad:Number,p_angle:Number=0):void
		{	
			p_numSides = Math.abs(p_numSides);
			
			if ( p_numSides < 3 )
			{
				return;
			}
			 
			var step:Number = (Math.PI*2)/p_numSides;
			var start:Number = (p_angle/180)*Math.PI;
			
			p_g.moveTo(p_center.x+(Math.cos(start)*p_rad), p_center.y-(Math.sin(start)*p_rad));
			
			var dX:Number;
			var dY:Number;
			
			for (var i:Number=1; i<=p_numSides; i++)
			{
				dX = p_center.x+Math.cos(start+(step*i))*p_rad;
				dY = p_center.y-Math.sin(start+(step*i))*p_rad;
				p_g.lineTo(dX,dY);
			}
		}
	}
}