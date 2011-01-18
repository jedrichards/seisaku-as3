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
	 * Contains a static method for drawing a wedge (i.e. a section of a pie chart) with
	 * the drawing API.
	 */
	public class DrawWedge
	{	
		/**
		 * Draw a wedge.
		 * 
		 * @param p_g Target Graphics instance.
		 * @param p_center Origin of the wedge in the Graphics instance's coordinate space.
		 * @param p_angle Starting angle, in degrees.
		 * @param p_arc Sweep of the wedge, in degrees.  A negative value draws clockwise.
		 * @param p_xRad X radius of the wedge.
		 * @param p_yRad Y radius of the wedge.
		 */
		public static function draw(p_g:Graphics,p_center:Point,p_angle:Number,p_arc:Number,p_xRad:Number,p_yRad:Number):void
		{
			p_g.moveTo(p_center.x,p_center.y);
			
			var segAngle:Number;
			var theta:Number;
			var angle:Number;
			var angleMid:Number;
			var numSegs:Number;
			var aX:Number;
			var aY:Number;
			var bX:Number;
			var bY:Number;
			var cX:Number;
			var cY:Number;
			
			if ( Math.abs(p_arc)>360 )
			{	
				p_arc = 360;
			}
			
			numSegs = Math.ceil(Math.abs(p_arc)/45);
			segAngle = p_arc/numSegs;
			theta = -(segAngle/180)*Math.PI;
			angle = -(p_angle/180)*Math.PI;
			
			if ( numSegs>0 )
			{	
				aX = p_center.x+Math.cos(p_angle/180*Math.PI)*p_xRad;
				aY = p_center.y+Math.sin(-p_angle/180*Math.PI)*p_yRad;
				
				p_g.lineTo(aX, aY);
				
				for (var i:uint = 0; i<numSegs; i++)
				{	
					angle += theta;
					angleMid = angle-(theta/2);
					
					bX = p_center.x+Math.cos(angle)*p_xRad;
					bY = p_center.y+Math.sin(angle)*p_yRad;
					cX = p_center.x+Math.cos(angleMid)*(p_xRad/Math.cos(theta/2));
					cY = p_center.y+Math.sin(angleMid)*(p_yRad/Math.cos(theta/2));
					
					p_g.curveTo(cX, cY, bX, bY);
				}
				
				p_g.lineTo(p_center.x, p_center.y);
			}
		}
	}
}