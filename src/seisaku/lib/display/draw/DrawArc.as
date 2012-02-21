/*
* Seisaku-Lib AS3
*
* Project home: https://github.com/jedrichards/seisakulib
* Website: http://www.seisaku.co.uk
* Contact: jed@seisaku.co.uk
*	
* Copyright (c) 2009 Seisaku Limited/Jed Richards
*
* Permission is hereby granted,free of charge,to any person obtaining a copy
* of this software and associated documentation files (the "Software"),to deal
* in the Software without restriction,including without limitation the rights
* to use,copy,modify,merge,publish,distribute,sublicense,and/or sell
* copies of the Software,and to permit persons to whom the Software is
* furnished to do so,subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS",WITHOUT WARRANTY OF ANY KIND,EXPRESS OR
* IMPLIED,INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,DAMAGES OR OTHER
* LIABILITY,WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE,ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package seisaku.lib.display.draw
{
	import flash.display.*;
	import flash.geom.Point;
	
	/**
	 * Contains a static method for drawing an arc.
	 */
	public class DrawArc
	{
		/**
		 * Draw an arc.
		 * 
		 * @param p_g Target Graphics instance.
		 * @param p_center Origin of the arc in the Graphics instance's coordinate space.
		 * @param p_radius Radius of the arc.
		 * @param p_arc Sweep of the arc, in degrees.
		 * @param p_startAngle Starting angle, in degrees.
		 */
		public static function draw(p_g:Graphics,p_centre:Point,p_radius:Number,p_arc:Number,p_startAngle:Number=0):void
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;

			p_g.moveTo(p_centre.x,p_centre.y);
			
			if (Math.abs(p_arc) > 360) 
			{
				p_arc = 360;
			}
			
			numOfSegs = Math.ceil(Math.abs(p_arc) / 30);
			segAngle = p_arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (p_startAngle / 180) * Math.PI;
			
			ax = p_centre.x - Math.cos(angle) * p_radius;
			ay = p_centre.y - Math.sin(angle) * p_radius;
			
			for(var i:int=0; i<numOfSegs; i++) 
			{
				angle += segAngle;
				
				angleMid = angle - (segAngle / 2);
				
				bx = ax + Math.cos(angle) * p_radius;
				by = ay + Math.sin(angle) * p_radius;
				
				cx = ax + Math.cos(angleMid) * (p_radius / Math.cos(segAngle / 2));
				cy = ay + Math.sin(angleMid) * (p_radius / Math.cos(segAngle / 2));
				
				p_g.curveTo(cx,cy,bx,by);
			}
		}
	}
}