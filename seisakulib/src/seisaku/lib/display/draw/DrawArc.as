﻿/*
* Seisaku-Lib AS3
*
* Hosting: code.google.com/p/seisaku-lib
* Portfolio: www.seisaku.co.uk
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
	
	/**
	 * Contains a static method for drawing an arc.
	 */
	public class DrawArc
	{
		/**
		 * Draw an arc.
		 */
		public static function draw(t:Sprite,sx:Number,sy:Number,radius:Number,arc:Number,startAngle:Number=0):void
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
			
			// Move the pen
			t.graphics.moveTo(sx,sy);
			
			if (Math.abs(arc) > 360) 
			{
				arc = 360;
			}
			
			numOfSegs = Math.ceil(Math.abs(arc) / 30);
			segAngle = arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (startAngle / 180) * Math.PI;
			
			ax = sx - Math.cos(angle) * radius;
			ay = sy - Math.sin(angle) * radius;
			
			for(var i:int=0; i<numOfSegs; i++) 
			{
				angle += segAngle;
				
				angleMid = angle - (segAngle / 2);
				
				bx = ax + Math.cos(angle) * radius;
				by = ay + Math.sin(angle) * radius;
				
				cx = ax + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
				cy = ay + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
				
				t.graphics.curveTo(cx,cy,bx,by);
			}
		}
	}
}