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
 
package seisaku.lib.display
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import seisaku.lib.events.HideableExternalAssetEvent;
	import seisaku.lib.util.Debug;
	
	/**
	 * Encapsulates the functionality for loading in an external asset (JPG, PNG, SWF etc.)
	 * as a sub-class of HideableSprite.
	 */
	public class HideableExternalAsset extends HideableSprite
	{
		protected var _checkPolicyFile:Boolean;
		protected var _isVerbose:Boolean;
		protected var _loader:Loader;
		protected var _uri:String;
		protected var _showOnLoad:Boolean;
		protected var _loaderContext:LoaderContext;
		protected var _smooth:Boolean;
		
		public function HideableExternalAsset(p_uri:String="",p_isVerbose:Boolean=false,p_showOnLoad:Boolean=false,p_smooth:Boolean=false,p_startHidden:Boolean=false)
		{
			_isVerbose = p_isVerbose;
			_uri = p_uri;
			_showOnLoad = p_showOnLoad;
			_smooth = p_smooth;
			
			_checkPolicyFile = false;

			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_loaderContext = new LoaderContext();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_complete,false,0,true);
			_loader.contentLoaderInfo.addEventListener(Event.INIT,_init,false,0,true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,_ioError,false,0,true);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_progress,false,0,true);
			addChildToHolder(_loader);
		}
		
		/**
		 * Start to load the external asset.
		 * 
		 * @param Image asset URI.
		 */
		public function load(p_uri:String=""):void
		{
			if ( p_uri != "" )
			{
				_uri = p_uri;
			}
			
			//_log("attempting to load \""+_uri+"\"");
			
			_loaderContext.checkPolicyFile = _checkPolicyFile;
						
			try
			{
				if ( _loaderContext.checkPolicyFile )
				{
					_loader.load(new URLRequest(_uri),_loaderContext);
				}
				else
				{
					_loader.load(new URLRequest(_uri));
				}
				
			}
			catch (p_error:Error)
			{
				_log("error attempting to load \""+_uri+"\", "+p_error.message,Debug.L2_WARNING);
				
				dispatchEvent(new HideableExternalAssetEvent(HideableExternalAssetEvent.LOAD_ERROR));
			}
		}
		
		/**
		 * Sets whether to check for a cross domain policy file on every load. This needs
		 * to be set to true for Flickr image loading if you plan to manipulate bitmap data.
		 */
		public function setCheckPolicyFile(p_value:Boolean):void
		{
			_checkPolicyFile = p_value;
		}
		
		/**
		 * Specify whether the instance outputs all events and errors to the Debug class.
		 * 
		 * @param p_value Verbose boolean value.
		 */
		public function setVerbose(p_value:Boolean):void
		{
			_isVerbose = p_value;
		}
		
		/**
		 * Access the loaded content. Could be cast to MovieClip
		 * or Bitmap depending on the type of loaded content.
		 */
		public function getContent():DisplayObject
		{
			return _loader.content as DisplayObject;
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */		
		override public function dispose():void
		{
			if ( _loader.content )
			{
				if ( _loader.content is Bitmap )
				{
					Bitmap(_loader.content).bitmapData.dispose();
				}
			}
			
			if ( _loader )
			{
				try
				{
					_loader.unload();
				}
				catch (p_error:Error)
				{
					_log("error unloading \""+_uri+"\", "+p_error.message,Debug.L2_WARNING);
				}
				
				try
				{
					_loader.close();
				}
				catch (p_error:Error)
				{
					_log("error closing loader for \""+_uri+"\", "+p_error.message,Debug.L2_WARNING);
				}
							
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,_complete);
				_loader.contentLoaderInfo.removeEventListener(Event.INIT,_init);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,_ioError);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,_progress);
				
				_holder.removeChild(_loader);
				
				_loader = null;
			}
			
			super.dispose();
		}
		
		public function getURI():String
		{
			return _uri;
		}
		
		protected function _complete(p_event:Event):void
		{
			_log("asset fully loaded \""+_uri+"\"");
			
			if ( _showOnLoad )
			{
				show();
			}
			
			if ( _smooth )
			{
				if ( getContent() is Bitmap )
				{
					Bitmap(getContent()).smoothing = true;
					Bitmap(getContent()).pixelSnapping = PixelSnapping.NEVER;
				}
			}
			
			dispatchEvent(new HideableExternalAssetEvent(HideableExternalAssetEvent.FULLY_LOADED));
		}
		
		protected function _init(p_event:Event):void
		{
			dispatchEvent(new HideableExternalAssetEvent(HideableExternalAssetEvent.CONTENT_INIT));
		}
		
		protected function _ioError(p_event:IOErrorEvent):void
		{
			_log("error during load of \""+_uri+"\", "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(new HideableExternalAssetEvent(HideableExternalAssetEvent.LOAD_ERROR));
		}
		
		protected function _progress(p_event:ProgressEvent):void
		{
			var event:HideableExternalAssetEvent = new HideableExternalAssetEvent(HideableExternalAssetEvent.LOAD_PROGRESS);
			
			event.progress = p_event.bytesLoaded/p_event.bytesTotal;
			
			dispatchEvent(event);
		}
		
		protected function _log(p_value:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log("ExternalHideableSprite: "+p_value,p_level,p_introspect,p_initTabs);
			}
		}
	}
}