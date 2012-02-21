/*
 * Seisaku-Lib AS3
 *
 * Project home: https://github.com/jedrichards/seisakulib
 * Website: http://www.seisaku.co.uk
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	/**
	 * A set of static methods for instantiating class definitions held in a SWF's library. In order
	 * to create instances this utility class needs a reference to the relevant ApplicationDomain, i.e.
	 * <code>root.loaderInfo.applicationDomain</code>.
	 */
	public class LibraryUtils
	{
		private static var _domain:ApplicationDomain;
		
		/**
		 * Initialise with the application domain you want to use to generate assets.
		 * 
		 * @param p_domain ApplicationDomain instance.
		 */
		public static function init(p_domain:ApplicationDomain=null):void
		{
			_domain = p_domain;
		}
		
		/**
		 * Create a MovieClip instance from the library.
		 * 
		 * @param p_className MovieClip class name, as set in the SWF's library.
		 * @param p_domain ApplicationDomain to use to generate the asset, optional if previously set.
		 */
		public static function createMovieClip(p_className:String):MovieClip
		{
			_validateDomain();
			
			var c:Class = Class(_domain.getDefinition(p_className));
			
			return new c() as MovieClip;
		}
		
		/**
		 * Create a Sound instance from the library.
		 * 
		 * @param p_className Sound class name, as set in the SWF's library.
		 * @param p_domain ApplicationDomain to use to generate the asset, optional if previously set.
		 */
		public static function createSound(p_className:String,p_domain:ApplicationDomain=null):Sound
		{
			_validateDomain();
			
			var c:Class = Class(_domain.getDefinition(p_className));
			
			return new c() as Sound;
		}
		
		/**
		 * Create a BitmapData instance from the library.
		 * 
		 * @param p_className BitmapData class name, as set in the SWF's library.
		 * @param p_domain ApplicationDomain to use to generate the asset, optional if previously set.
		 */
		public static function createBitmapData(p_className:String,p_domain:ApplicationDomain=null):BitmapData
		{
			_validateDomain();
			
			var c:Class = Class(_domain.getDefinition(p_className));
			
			return new c(0,0) as BitmapData;
		}
		
		/**
		 * Create a Bitmap instance from the library.
		 * 
		 * @param p_className BitmapData class name, as set in the SWF's library.
		 * @param p_domain ApplicationDomain to use to generate the asset, optional if previously set.
		 */
		public static function createBitmap(p_className:String,p_pixelSnapping:String="auto",p_smoothing:Boolean=false,p_domain:ApplicationDomain=null):Bitmap
		{
			return new Bitmap(createBitmapData(p_className,p_domain),p_pixelSnapping,p_smoothing);
		}
				
		private static function _validateDomain():void
		{
			if ( _domain == null )
			{
				throw(new Error("LibraryUtils: no ApplicationDomain instance specified"));
			}
		}
	}
}