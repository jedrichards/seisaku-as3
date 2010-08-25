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
	import seisaku.lib.util.MathUtils;
	import flash.utils.ByteArray;

	/**
	 * A set of static methods for working with arrays.
	 */
	public class ArrayUtils
	{	
		/**
		 * Shuffle the contents of the array. Array is directly modified.
		 * 
		 * @param p_array Target array.
		 */
		public static function shuffle(p_array:Array):void
		{	
			var arrayLength:uint = p_array.length;
			
			for( var i:uint=0; i<arrayLength; i++ )
			{
				var random:uint = MathUtils.randomInt(0,arrayLength-1);
				var temp:* = p_array[i];
				p_array[i] = p_array[random];
				p_array[random] = temp;
			}
		}
		
		/**
		 * Return a random element from an array.
		 * 
		 * @param p_array Source array.
		 * 
		 * @return Random item from the array.
		 */
		public static function randomElement(p_array:Array):*
		{	
			return p_array[MathUtils.randomInt(0,p_array.length-1)];
		}
		
		/**
		 * Calculate the average value of all the numerical items in an array.
		 * 
		 * @param p_array Source array.
		 */
		public static function average(p_array:Array):Number
		{	
			return sum(p_array)/p_array.length;
		}
		
		/**
		 * Calculate the sum of all the numerical items in an array.
		 * 
		 * @param p_array Source array.
		 */
		public static function sum(p_array:Array):Number
		{	
			var total:Number = 0;
			var numElements:Number = p_array.length;
			
			for( var i:Number=0; i<numElements; i++ )
			{
				total += p_array[i];
			}
			
			return total;
		}
		
		/**
		 * Calculate the maximum numerical value in the array.
		 * 
		 * @param p_array Source array.
		 */
		public static function max(p_array:Array):Number
		{	
			var temp:Array = p_array.sort( Array.NUMERIC | Array.DESCENDING | Array.RETURNINDEXEDARRAY );
			
			return p_array[temp[0]];
		}
		
		/**
		 * Calculate the minimum numerical value in the array.
		 * 
		 * @param p_a Source array.
		 */
		public static function min(p_array:Array):Number
		{	
			var temp:Array = p_array.sort( Array.NUMERIC | Array.RETURNINDEXEDARRAY );
			
			return p_array[temp[0]];
		}
		
		/**
		 * Remove duplicated items from an array. Array is directly modified.
		 * 
		 * @param p_array Target array.
		 */
		public static function removeDuplicates(p_array:Array):void
		{	
			var numElements:Number = p_array.length;
			
			for( var i:Number=0; i<numElements; i++ )
			{
				for( var j:Number=0; j<numElements; j++ )
				{
					if( p_array[i] === p_array[j] && i!=j )
					{
						p_array.splice(j,1);
						j--;
					}
				}
			}
		}
		
		/**
		 * Returns the index of the first occurance of an item in an array, or -1
		 * if item is not present.
		 * 
		 * @param p_array Source array.
		 * @param p_term Item to search for.
		 */
		public static function firstIndexOf(p_array:Array,p_term:*):Number
		{	
			var numElements:Number = p_array.length;
			
			var i:uint = 0;
			
			while ( i < numElements )
			{
				if ( p_term === p_array[i] ) {
					return i;
				}
				i++;
			}
			
			return -1;
		}
		
		/**
		 * Returns the index of the last occurance of an item in an array, or -1
		 * if item is not present.
		 * 
		 * @param p_array Source array.
		 * @param p_term Item to search for.
		 */
		public static function lastIndexOf(p_array:Array,p_term:*):Number
		{	
			var i:uint = p_array.length;
			
			while ( i-- )
			{
				if ( p_term === p_array[i] )
				{
					return i;
				}
			}
			
			return -1;
		}
	}
}