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
	import flash.display.LoaderInfo;
	
	/**
	 * Utility class for easy access to flash vars. Needs to be passed a valid non-null reference
	 * to the root loaderInfo object, e.g. <code>root.loaderInfo</code>.
	 */
	public class FlashVars
	{
		private static var _loaderInfo:LoaderInfo;
		
		/**
		 * Initialise with a reference to the root LoaderInfo instance.
		 * 
		 * @param p_root A reference to the root LoaderInfo instance.
		 */
		public static function init(p_loaderInfo:LoaderInfo):void
		{
			_loaderInfo = p_loaderInfo;	
		}
		
		/**
		 * Attempt to access a flashvar, and return a default value if it does not exist.
		 * 
		 * @param p_key Flashvar name.
		 * @param p_default Default value.
		 * @param p_verbose Whether to output debug information.
		 */
		public static function getFlashVar(p_key:String,p_default:String,p_verbose:Boolean=false):String
		{
			_validateLoaderInfo();
			
			if ( valueExists(p_key) )
			{
				if ( p_verbose )
				{
					Debug.log("FlashVars returning flashvar \""+p_key+"\" with value \""+getValue(p_key)+"\"");
				}
				
				return getValue(p_key);
			}
			else
			{
				if ( p_verbose )
				{
					Debug.log("FlashVars key \""+p_key+"\" not found, returning default value \""+p_default+"\"",Debug.L2_WARNING);
				}
				
				return p_default;
			}
		}
		
		/**
		 * Directly access a flashvar.
		 * 
		 * @param p_key Flashvar name.
		 */
		public static function getValue(p_key:String):String
		{	
			_validateLoaderInfo();
			
			return _loaderInfo.parameters[p_key];
		}
		
		/**
		 * Check to see if a flashvar exists.
		 * 
		 * @param p_key Flashvar name.
		 */
		public static function valueExists(p_key:String):Boolean
		{
			_validateLoaderInfo();
			
			return ( getValue(p_key) == null ) ? false : true; 
		}	
		
		/**
		 * Output a formatted string representing all available flashvars to the
		 * output panel/debug console.
		 */ 
		public static function debugFlashVars():void
		{
			_validateLoaderInfo();
			
			Debug.log(_loaderInfo.parameters,Debug.L0_INFORMATIONAL,true);
		}
		
		private static function _validateLoaderInfo():void
		{
			if ( !_loaderInfo )
			{
				throw( new Error("FlashVars: no root LoaderInfo object specified") );
			}
		}
	}
}