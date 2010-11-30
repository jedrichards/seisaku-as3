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
	import flash.net.SharedObject;
	
	import seisaku.lib.util.ObjectUtils;
	
	/**
	 * Provides a simple method for determining whether a SharedObject instance has "expired" based
	 * on a notional "shelf life".
	 * 
	 * <p>An ExpirableSharedObject will report itself as expired until the refresh() method is called 
	 * for the first time, after which it will only report itself as expired once the shelf life has
	 * elapsed.</p>
	 * 
	 * <p>Use the getSharedObject() method to add any other arbitrary data to the SharedObject as per
	 * normal.</p> 
	 */
	public class ExpirableSharedObject
	{
		private static const _EXPIRE_TIME_VALUE_NAME:String = "expireTime";
		
		private var _so:SharedObject;
		private var _shelfLife:Number;
		
		/**
		 * @param p_name SharedObject name.
		 * @param p_path Path to SharedObject.
		 * @param p_shelfLife Shelf life of the shared object in days.
		 */
		public function ExpirableSharedObject(p_name:String,p_path:String="/",p_shelfLife:Number=1)
		{	
			_so = SharedObject.getLocal(p_name,p_path);
			
			setShelfLife(p_shelfLife);
		}
		
		/**
		 * Set the the shelf life of the shared object, i.e. the time until expiry
		 * from the moment it is refreshed.
		 * 
		 * @param p_value The shelf life in days.
		 */
		public function setShelfLife(p_value:Number):void
		{	
			_shelfLife = p_value*24*60*60*1000;
		}
		
		/**
		 * Return the the shelf life of the shared object in days.
		 */
		public function getShelfLife():Number
		{	
			return _shelfLife/24/60/60/1000;
		}
		
		/**
		 * Refresh the expiry time to some time in the future as defined by the shelf life.
		 * This method can be called multiple times, at any time, to refresh the object.
		 */
		public function refresh():void
		{	
			_so.data[_EXPIRE_TIME_VALUE_NAME] = _getTime()+_shelfLife;
			_so.flush();
		}
		
		/**
		 * Check to see if the shared object is expired.
		 */
		public function isExpired():Boolean
		{	
			return ( getExpireTime()<_getTime() || isNaN(_so.data[_EXPIRE_TIME_VALUE_NAME]) ) ? true : false;
		}
		
		/**
		 * Get the time in days until the shared object is expired.
		 */
		public function daysToExpiry():Number
		{	
			return (getExpireTime()-_getTime())/24/60/60/1000;
		}
		
		public function timeToExpiry():Number
		{
			return getExpireTime()-_getTime();
		}
		
		public function hoursToExpiry():Number
		{
			return (getExpireTime()-_getTime())/60/60/1000;
		}
		
		/**
		 * Check to see if the SharedObject has any contents.
		 */
		public function hasData():Boolean
		{	
			return ( ObjectUtils.numProps(_so.data) > 0 ) ? true : false;
		}
		
		/**
		 * Return a reference to <code>SharedObject.data</code> object. Use
		 * this to read and write data to the SharedObject.
		 */
		public function getDataObject():Object
		{	
			return _so.data;
		}
		
		/**
		 * Return the moment, in UTC milliseconds, when the shared object will expire.
		 */
		public function getExpireTime():Number
		{	
			return _so.data[_EXPIRE_TIME_VALUE_NAME];
		}
		
		private function _getTime():Number
		{	
			return new Date().getTime();
		}
	}
}