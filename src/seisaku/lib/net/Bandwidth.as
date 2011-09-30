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
 
package seisaku.lib.net
{	
	import seisaku.lib.util.MathUtils;
	
	/**
	 * Represents a bandwidth value.
	 */
	public class Bandwidth
	{	
		private var _bytesPerSecond:Number;
		
		/**
		 * @param p_bytesPerSecond Explicit value for B/s, defaults to 0.
		 */
		public function Bandwidth(p_bytesPerSecond:Number=0)
		{	
			_bytesPerSecond = p_bytesPerSecond;
		}
		
		/**
		 * Calculate a bandwidth based on a total amount of bytes and the time
		 * taken to load them.
		 * 
		 * @param p_totalBytes Total size of the asset in bytes.
		 * @param p_totalTimeSecs Total time taken to download in seconds.
		 */
		public function setDownloadMetrics(p_totalBytes:Number,p_totalTimeSecs:Number):void
		{
			
			_bytesPerSecond = Math.round(p_totalBytes/p_totalTimeSecs);
		}
		
		/**
		 * Explicity set the B/s value.
		 */
		public function setBytesPerSecond(p_bytesPerSecond:Number):void
		{
			_bytesPerSecond = p_bytesPerSecond;
		}
		
		/**
		 * Return the current bandwidth value in B/s.
		 */
		public function getBytesPerSecond():Number
		{	
			return _bytesPerSecond;
		}
		
		/**
		 * Return the current bandwidth value in kB/s.
		 */
		public function getKiloBytesPerSecond():Number
		{	
			return MathUtils.bytesToKiloBytes(_bytesPerSecond);
		}
		
		/**
		 * Return the current bandwidth value in kb/s.
		 */
		public function getKiloBitsPerSecond():Number
		{	
			return MathUtils.bytesToKiloBits(_bytesPerSecond);
		}
		
		/**
		 * Clone the instance.
		 */
		public function clone():Bandwidth
		{	
			return new Bandwidth(_bytesPerSecond);
		}
		
		public function toString():String
		{
			return "[object Bandwidth "+getKiloBytesPerSecond()+" kB/s]";
		}
	}
}