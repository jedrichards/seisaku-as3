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
 
package seisaku.lib.data
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import seisaku.lib.net.HTTPStatusInfo;
	import seisaku.lib.util.Debug;
	
	/**
	 * Encapsulates the functionality for loading raw text content from a remote URL.
	 * POST vars may also be included in the request.
	 * 
	 * <p>Each instance of this class represents one text load operation, and should be
	 * disposed of once the text content has been gathered.</p>
	 * 
	 * <p>A full range of URLLoader events are redispatched from this class.</p>
	 */
	public class TextRequest extends EventDispatcher {
		
		protected var _urlLoader:URLLoader;
		protected var _request:URLRequest;
		protected var _isVerbose:Boolean;
		protected var _loadAttempted:Boolean;
		protected var _uri:String;
		
		/**
		 * @param p_isVerbose Specify whether the instance logs events and errors to the Debug class.
		 */
		public function TextRequest(p_isVerbose:Boolean=false)
		{	
			_isVerbose = p_isVerbose;
			
			_loadAttempted = false;
			_uri = "";
			
			_request = new URLRequest();
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE,_complete,false,0,true);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,_httpStatus,false,0,true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,_ioError,false,0,true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_securityError,false,0,true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,_progress,false,0,true);
			_urlLoader.addEventListener(Event.OPEN,_open,false,0,true);
		}
		
		/**
		 * Optionally add post vars to the request.
		 * 
		 * @param p_value Post vars.
		 */
		public function addPostVars(p_value:URLVariables):void
		{				
			_request.data = p_value;
			_request.method = URLRequestMethod.POST;
			_request.contentType = "application/x-www-form-urlencoded";
		}
		
		/**
		 * Load text data.
		 * 
		 * @param p_value URI of XML data.
		 */
		public function load(p_uri:String):void
		{
			if ( _loadAttempted )
			{
				_log("error, a load has already been attempted with this instance. Load operation aborted.",Debug.L2_WARNING);
				
				return;
			}
			
			_loadAttempted = true;
			_uri = p_uri;
			_request.url = _uri;
						
			try
			{
				_urlLoader.load(_request);
			}
			catch (p_error:Error)
			{
				_log("error, failed to start load. "+p_error.message,Debug.L2_WARNING);
			}
		}
		
		/**
		 * Return the loaded text data.
		 */
		public function getText():String
		{	
			return String(_urlLoader.data);
		}
		
		/**
		 * Cancel the current load operation, remove event listeners and null internal properties
		 * ready for garbage collection.
		 */
		public function dispose():void
		{
			try
			{
				_urlLoader.close();
			}
			catch (p_error:Error)
			{
				_log("error closing URLLoader instance. "+p_error.message,Debug.L2_WARNING);
			}
			
			_urlLoader.removeEventListener(Event.COMPLETE,_complete);
			_urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,_httpStatus);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,_ioError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_securityError);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS,_progress);
			_urlLoader.removeEventListener(Event.OPEN,_open);
			
			_urlLoader = null;
			_request = null;
		}
		
		/**
		 * Specify whether the instance logs all events and errors to the Debug instance.
		 * 
		 * @param p_value Verbose value.
		 */
		public function setVerbose(p_value:Boolean):void
		{
			_isVerbose = p_value;
		}
		
		private function _complete(p_event:Event):void
		{	
			_log(Event.COMPLETE,Debug.L1_EVENT);
			
			dispatchEvent(p_event);
		}
		
		private function _httpStatus(p_event:HTTPStatusEvent):void
		{	
			dispatchEvent(p_event);
		}
		
		private function _ioError(p_event:IOErrorEvent):void
		{	
			_log(IOErrorEvent.IO_ERROR+" "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(p_event);
		}
		
		private function _securityError(p_event:SecurityErrorEvent):void
		{	
			_log(SecurityErrorEvent.SECURITY_ERROR+" "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(p_event);
		}
		
		private function _progress(p_event:ProgressEvent):void
		{	
			dispatchEvent(p_event);
		}
		
		private function _open(p_event:Event):void
		{
			dispatchEvent(p_event);
		}
		
		private function _log(p_item:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log("TextRequest: \""+_uri+"\" "+p_item,p_level,p_introspect,p_initTabs);
			}
		}
	}
}