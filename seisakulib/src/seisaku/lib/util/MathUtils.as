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
	
	/**
	 * Set of static methods for mathematical operations.
	 */
	public class MathUtils
	{	
		/**
		 * Return a random real number (non-integer) within a range.
		 * 
		 * @param p_min Lower range limit.
		 * @param p_max Upper range limit.
		 */
		public static function random(p_min:Number=0,p_max:Number=1):Number
		{	
			return p_min+(Math.random()*(p_max-p_min));
		}
		
		/**
		 * Return a random integer within a range.
		 * 
		 * @param p_min Lower range limit.
		 * @param p_max Upper range limit.
		 */
		public static function randomInt(p_min:Number,p_max:Number):Number
		{	
			return Math.round(random(p_min-0.49999,p_max+0.49999));
		}
		
		/**
		 * Test to see if a value lies within a range.
		 * 
		 * @param p_value The value to test.
		 * @param p_min Lower range limit.
		 * @param p_max Upper range limit.
		 */
		public static function inRange(p_value:Number,p_min:Number,p_max:Number):Boolean
		{	
			return ( p_value >= p_min && p_value <= p_max ) ? true : false;
		}
		
		/**
		 * Limits/trims a value to a range.
		 * 
		 * @param p_value The value to limit.
		 * @param p_min Lower range limit.
		 * @param p_max Upper range limit.
		 */
		public static function limit(p_value:Number,p_min:Number,p_max:Number):Number
		{	
			return Math.min(p_max,Math.max(p_min,p_value));
		}
		
		/**
		 * Normalises a range value into the equivalent value between 0 and 1.
		 * 
		 * @param p_value Value to transform.
		 * @param p_min Lower limit of range.
		 * @param p_max Upper limit of range.
		 */
		public static function normalise(p_value:Number,p_min:Number,p_max:Number):Number
		{	
			return (p_value-p_min)/(p_max-p_min);
		}
		
		/**
		 * Linear interpolation of a normalised value (from 0 to 1) to the
		 * equivalent value on a range.
		 * 
		 * @param p_value Normalised value.
		 * @param p_min Lower limit of range.
		 * @param p_max Upper limit of range.
		 */
		public static function interpolate(p_value:Number,p_min:Number,p_max:Number):Number
		{	
			return p_min+(p_max-p_min)*p_value;
		}
		
		/**
		 * Map a value on one range to the equivalent value on a second range.
		 * 
		 * @param p_value Value on first range.
		 * @param p_valueMin Lower limit of first range.
		 * @param p_valueMax Upper limit of first range.
		 * @param p_targetMin Lower limit of second range.
		 * @param p_targetMax Upper limit of second range.
		 */
	    public static function map(p_value:Number,p_valueMin:Number,p_valueMax:Number,p_targetMin:Number,p_targetMax:Number):Number
	    {
			return interpolate(normalise(p_value,p_valueMin,p_valueMax),p_targetMin,p_targetMax);
		}
		
		/**
		 * Round a number to an arbitrary number of decimal places.
		 * 
		 * @param p_value Number to round.
		 * @param p_places Number of decimal places to round off to.
		 */
		public static function round(p_value:Number,p_places:uint=0):Number
		{	
			var order:uint = Math.pow(10,p_places);
			
			return (p_places==0)?Math.round(p_value):int(p_value*order)/order;
		}
		
		/**
		 * Convert a decimal RGB number into it's corresponding hexadecimal string.
		 * 
		 * @param p_rgb Decimal RGB uint to convert.
		 */
		public static function hexToString(p_rgb:uint,p_minLength:Number=6):String
		{	
			var s:String = (((p_rgb>>24)!=0)?Number((p_rgb>>>24)&0xFFFFFF).toString(16):"")+Number(p_rgb&0xFFFFFF).toString(16);
			
			 while ( p_minLength > s.length)
			 {
			 	s = "0"+s;
			 }
			
			return s;
		}
		
		/**
		 * Extract the red component from a decimal RGB value.
		 * 
		 * @param p_rgb Decimal RGB number to convert.
		 */
		public static function extractR(p_rgb:uint):uint
		{	
			return ( p_rgb & 0xFF0000 ) >>> 16;
		}
		
		/**
		 * Extract the green component from a decimal RGB value.
		 * 
		 * @param p_rgb Decimal RGB number to convert.
		 */
		public static function extractG(p_rgb:uint):uint
		{	
			return ( p_rgb &0x00FF00 ) >>> 8;
		}
		
		/**
		 * Extract the blue component from a decimal RGB value.
		 * 
		 * @param p_rgb Decimal RGB number to convert.
		 */
		public static function extractB(p_rgb:uint):uint
		{	
			return p_rgb & 0x0000FF;
		}
		
		/**
		 * Composite an RGB value from seperate red, geen and blue components,
		 * each component should be a value between 0 and 255, or 0x00 and 0xff.
		 * 
		 * @param p_r Red value.
		 * @param p_g Green value.
		 * @param p_b Blue value.
		 */
		public static function compositeRGB(p_r:uint,p_g:uint,p_b:uint):uint
		{	
			return ( p_r << 16 ) | ( p_g << 8 ) | p_b;
		}
		
		/**
		 * Insert a red value into a pre-existing RGB value.
		 * 
		 * @param p_rgb The full RGB value to manipulate.
		 * @param p_r The red value.
		 */
		public static function insertR(p_rgb:uint,p_r:uint):uint
		{	
			return ( p_rgb & 0x00FFFF ) | ( p_r << 16 );
		}
		
		/**
		 * Insert a green value into a pre-existing RGB value.
		 * 
		 * @param p_rgb The full RGB value to manipulate.
		 * @param p_g The green value.
		 */
		public static function insertG(p_rgb:uint,p_g:uint):uint
		{	
			return ( p_rgb&0xFF00FF ) | ( p_g << 8 );
		}
		
		/**
		 * Insert a blue value into a pre-existing RGB value.
		 * 
		 * @param p_rgb The full RGB value to manipulate.
		 * @param p_b The red value.
		 */
		public static function insertB(p_rgb:uint,p_b:uint):uint
		{	
			return ( p_rgb&0xFFFF00 ) | p_b;
		}
		
		/**
		 * Trim or clip a colour component down to the 0~255 range.
		 * 
		 * @param p_value Colour component to trim.
		 */
		public static function limitColourComponent(p_value:uint):uint
		{	
			return limit(p_value,0,255);
		}
		
		/**
		 * Returns a point geometrically between the two specified points. Use the
		 * third argument, p_bias, to introduce a bias towards either the first or
		 * second point, i.e. a bias of 1 would return the first point, a bias of 0
		 * would return the second point, while the default value of 0.5 returns a
		 * point exactly equidistant between the two.
		 * 
		 * @param p_point1 First point.
		 * @param p_point2 Second point.
		 * @param p_bias Point position bias, defaults to 0.5.
		 */
		public function interpolatePoints(p_point1:Point,p_point2:Point,p_bias:Number=0.5):Point
		{	
			return Point.interpolate(p_point1,p_point2,p_bias);
		}
		
		/**
		 * Get the distance between two cartesian coordinates.
		 * 
		 * @param p_x1 First coordinates x position.
		 * @param p_y1 First coordinates y position.
		 * @param p_x2 Second coordinates x position.
		 * @param p_y2 Second coordinates y position.
		 */
		public static function distance(p_x1:Number,p_y1:Number,p_x2:Number,p_y2:Number):Number
		{	
			return hypotenuse(p_x1-p_x2,p_y1-p_y2);
		}
		
		/**
		 * Get the distance between two Point instances.
		 * 
		 * @param p_point1 First Point instance.
		 * @param p_point2 Second Point instance.
		 */
		public static function distancePoints(p_point1:Point,p_point2:Point):Number
		{	
			return Point.distance(p_point1,p_point2);
		}
		
		/**
		 * Calculate the length of the hypotenuse of a right angled triangle.
		 * 
		 * @param p_length1 Length of first adjacent side.
		 * @param p_length2 Length of second adjacent side.
		 */
		public static function hypotenuse(p_length1:Number,p_length2:Number):Number
		{	
			return Math.sqrt((p_length1*p_length1)+(p_length2*p_length2));
		}
		
		/**
		 * Returns the angle in radians (from 0 to 2π) defined by the point (x,y), when measured
		 * counterclockwise from a circle's negative y axis, where the center of the circle is a
		 * point (0,0).
		 * 
		 * @param p_x Point's x position.
		 * @param p_y Point's y position.
		 */
		public static function angle(p_x:Number,p_y:Number):Number
		{	
			var theta:Number = Math.atan2(p_x,p_y);
			
			return (theta+(Math.PI*2))%(Math.PI*2);
		}
		
		/**
		 * Returns the angle in radians (from 0 to 2π) defined by the point p_p2, when measured
		 * counterclockwise from a circle's negative y axis, where the point p_p1 represents the
		 * center of the circle.
		 * 
		 * @param p_point1 Point instance defining the center of the circle.
		 * @param p_point2 Point instance defining the offset from the circle's center.
		 */
		public static function anglePoints(p_point1:Point,p_point2:Point):Number
		{	
			return angle(p_point1.x-p_point2.x,p_point1.y-p_point2.y);
		}
		
		/**
		 * Convert radians to degrees.
		 * 
		 * @param p_value Radians value.
		 */
		public static function radToDeg(p_value:Number):Number
		{	
			  return p_value*180/Math.PI;
		}
		
		/**
		 * Convert degrees to radians.
		 * 
		 * @param p_value Degrees value.
		 */
		public static function degToRad(p_value:Number):Number
		{	
			return p_value*(Math.PI/180);
		}
		
		/**
		 * Calculate the smallest Flash rotation value to achieve a transition between two angles.
		 * 
		 * @param p_angle1 Starting angle.
		 * @param p_angle2 Ending angle.
		 */
		public static function shortestRotation(p_angle1:Number,p_angle2:Number):Number
		{	
			var n1:Number = Math.abs(p_angle1-p_angle2);
			var n2:Number = Math.abs(p_angle1-(p_angle2+360));
			var n3:Number = Math.abs(p_angle1-(p_angle2-360));
			
			if ( Math.min(n1,Math.min(n2,n3)) == n2 )
			{
				return p_angle2 + 360;
			}
			else if ( Math.min(n1,Math.min(n2,n3)) == n3 )
			{
				return p_angle2 - 360;
			}
			else
			{
				return p_angle2;
			}
		}
		
		/**
		 * Return a new point that has been displaced from an origin (0,0) by the
		 * specified displacement and angle. The angle should be supplied in radians
		 * as measured counterclockwise from a circle's x axis.
		 * 
		 * @param p_distance Distance displaced from origin.
		 * @param p_angle Angle of displacement in radians.
		 */
		public static function angledDisplacement(p_distance:Number,p_angle:Number):Point
		{	
			return new Point(p_distance*Math.cos(p_angle),p_distance*Math.sin(p_angle));
		}
		
		/**
		 * Convert bytes to kilobytes.
		 * 
		 * @param p_bytes Number of bytes.
		 */
		public static function bytesToKiloBytes(p_bytes:Number):Number
		{	
			return p_bytes*0.0009765625;
		}
		
		/**
		 * Convert bytes to kilobits.
		 * 
		 * @param p_bytes Number of bytes.
		 */
		public static function bytesToKiloBits(p_bytes:Number):Number
		{	
			return p_bytes*0.0078125;
		}
		
		/**
		 * Calculate the number of seconds worth of progressively loading external media (i.e. FLV or
		 * MP3) to buffer before playback should begin in order to ensure that the playhead never
		 * catches up with the load progress.
		 * 
		 * @param p_nMediaLength Length of media, in seconds.
		 * @param p_nMediaBitRate Bit rate of media in kbits/second.
		 * @param p_nBandwidthBitRate User's bandwidth in kbits/second.
		 */
		public static function simpleBuffer(p_duration:Number,p_bitRate:Number,p_bandwidth:Number):Number
		{
			return Math.max(0,Math.ceil(p_duration-p_duration/(p_bitRate/p_bandwidth)));
		}
		
		/**
		 * Fractionally approach a numeric value relative to another numeric value.
		 * Can be useful for simple custom easing. The p_bias parameter defines the
		 * degree of approach. A value of 0 would result in the returned value equaling
		 * p_value1, whereas a value of 1 would result in the returned value equaling
		 * p_value2. A value of 0.5 (the default) would result in a figure exactly
		 * in-between p_value1 and p_value2 being returned.
		 * 
		 * @param p_value1 First value, this is the value we start at.
		 * @param p_value2 Second value, this is the value that we're approaching.
		 * @param p_bias Degree of approach.
		 */
		public static function approach(p_value1:Number,p_value2:Number,p_bias:Number=0.5):Number
		{	
			return p_value1-((p_value1-p_value2)*p_bias)
		}
		
		/**
		 * Determine whether a value is even (or odd).
		 * 
		 * @param p_value Value to test.
		 */
		public static function isEven(p_value:Number):Boolean
		{
			return (p_value & 1) == 0;
		}
	}
}