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
	import seisaku.lib.util.Debug;
	
	/**
	 * Static class for converting a HTTP status code into a meaningful string.
	 */
	public class HTTPStatusInfo
	{
		public static const TESTING_OFFLINE:String = "testingOffline";
		public static const INFORMATIONAL:String = "informational";
		public static const SUCCESS:String = "success";
		public static const REDIRECTION:String = "redirection";
		public static const CLIENT_ERROR:String = "clientError";
		public static const SERVER_ERROR:String = "serverError";
		public static const UNKNOWN:String = "unknown";
		
		public static function getType(p_status:Number):String
		{
			var status:String = p_status.toString();
			
			switch ( status.charAt(0) )
			{
				case "0":
					return TESTING_OFFLINE;
				case "1":
					return INFORMATIONAL;
				case "2":
					return SUCCESS;
				case "3":
					return REDIRECTION;
				case "4":
					return CLIENT_ERROR;
				case "5":
					return SERVER_ERROR;
				default:
					return UNKNOWN;
			}
		}
	}
}