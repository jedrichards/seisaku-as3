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
 
package seisaku.lib.util
{
	import flash.geom.Point;
	
	public class WanderingPoint
	{
		//private var _speed:Number;
		//private var _origin:Point;
		/*private var _maxXRad:Number;
		private var _maxYRad:Number;
		private var _xRadiusMod:Number;
		private var _yRadiusMod:Number;
		private var _xRadiusModRate:Number;
		private var _yRadiusModRate:Number;
		private var _xMod:Number;
		private var _yMod:Number;
		private var _xModRate:Number;
		private var _yModRate:Number;
		private var _randomness:Number;*/
		private var _point:Point;
		private var _width:Number;
		//private var _height:Number;
		private var _origin:Point;
		private var _radius:Number;
		private var _drivers:Array;
		
		/**
		 * Wandering point. Needs work ... perhaps add more sin/cos drivers?
		 */
		public function WanderingPoint(p_width:Number)
		{
			_drivers = new Array();
			
			_width = p_width;
			//_height = p_height;
			
			_point = new Point();
			_origin = new Point(p_width/2,p_width/2);
			_radius = p_width/2;
			
			/*_speed = p_speed;
			_origin = p_origin;

			_maxXRad = _origin.x;
			_maxYRad = _origin.y;
			
			_xMod = _yMod = 0;
		
			_xModRate =  _speed*MathUtils.random(0.75,1.5);
			_yModRate =  _speed*MathUtils.random(0.75,1.5);
			
			_xRadiusMod = _yRadiusMod = Math.PI;
			
			_xRadiusModRate = _speed*MathUtils.random(0.75,1.5);
			_yRadiusModRate = _speed*MathUtils.random(0.75,1.5);*/
			
			var driver:WanderingPointDriver = new WanderingPointDriver();
			driver.speedDegrees = 5;
			driver.currDegrees = 0;
			
			_drivers.push(driver);
		}

		public function advance():void
		{
			for ( var i:Number=0; i<_drivers.length; i++ )
			{
				var driver:WanderingPointDriver = _drivers[i] as WanderingPointDriver;
				
				driver.currDegrees += driver.speedDegrees;
				
				var rads:Number = MathUtils.degToRad(driver.currDegrees);
				
				var newX:Number = Math.cos(rads) * _radius;
				var newY:Number = Math.sin(rads) * _radius;
				
				_point.x += newX;
				_point.y += newY;
			}
			/*_xRadiusMod += _xRadiusModRate;
			_yRadiusMod += _yRadiusModRate;
			
			var radX:Number = Math.cos(_xRadiusMod)*_maxXRad;
			var radY:Number = Math.cos(_yRadiusMod)*_maxYRad;
			
			_xMod += _xModRate;
			_yMod += _yModRate;
			
			_point.x = _origin.x + Math.cos(_xMod)*radX;
			_point.y = _origin.y + Math.sin(_yMod)*radY;*/
			
			//_point.x = _origin.x+Math.cos(_xMod=_xMod+_xModRate)*(_maxXRad/2+Math.cos(_xRadiusMod=_xRadiusMod+_xRadiusModRate)*_maxXRad/2);
    		//_point.y = _origin.y+Math.sin(_yMod=_yMod+_yModRate)*(_maxYRad/2+Math.cos(_yRadiusMod=_yRadiusMod+_yRadiusModRate)*_maxYRad/2);

		}
		
		public function getPointX():Number
		{
			return _point.x;
		}
		
		public function getPointY():Number
		{
			return _point.y;
		}
		
		/*public function getPoint():Point
		{
			return _point;
		}*/
	}
}

class WanderingPointDriver
{
	public var speedDegrees:Number;
	public var currDegrees:Number;
}