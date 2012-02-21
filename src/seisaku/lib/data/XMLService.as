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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLVariables;
	
	import seisaku.lib.events.XMLServiceEvent;
	import seisaku.lib.util.Debug;
	
	/**
	 * Provides access to remote XML data (static XML or dynamic output from a web service).
	 * POST vars can optionally be supplied to the <code>load</code> method.
	 * 
	 * <p>The data represented by this class can be refreshed by repeatedly calling the
	 * <code>load</code> method, although two load operations cannot happen concurrently in
	 * the same instance.</p>
	 * 
	 * <p>Extend this class with XML parsing and data access methods relevant to your data
	 * model.</p>
	 * 
	 * @see seisaku.lib.events.XMLDataServiceEvent XMLDataServiceEvent
	 */
	public class XMLService extends EventDispatcher
	{	
		protected var _request:TextRequest;
		protected var _isLoading:Boolean;
		protected var _isVerbose:Boolean;
		protected var _uri:String;
		protected var _xml:XML;
		
		/**
		 * @param p_uri XML file/service URI. Can also be supplied to the <code>load</code> method.
		 * @param p_isVerbose Specify whether the instance logs events and errors to the Debug class.
		 */
		public function XMLService(p_uri:String="",p_isVerbose:Boolean=false)
		{	
			_uri = p_uri;
			_isVerbose = p_isVerbose;
			
			_isLoading = false;
		}
		
		/**
		 * Load the XML data.
		 * 
		 * @param p_uri XML file/service URI. No need to supply again if already passed to the constructor.
		 * @param p_postVars Optional post vars.
		 * @param p_verboseRequest Whether the TextRequest instance should be verbose.
		 */
		public function load(p_uri:String="",p_postVars:URLVariables=null,p_verboseRequest:Boolean=false):void
		{	
			if ( _isLoading )
			{
				_log("error, load operation still in progress. Load operation aborted.");
				
				return;
			}
			
			if ( p_uri != "" )
			{
				_uri = p_uri;
			}
			
			_isLoading = true;
			
			_request = new TextRequest(p_verboseRequest);
			_request.addEventListener(Event.COMPLETE,_complete,false,0,true);
			_request.addEventListener(IOErrorEvent.IO_ERROR,_xmlError,false,0,true);
			_request.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_xmlError,false,0,true);
			
			if ( p_postVars != null )
			{
				_request.addPostVars(p_postVars);
			}
			
			_request.load(_uri);
		}
		
		/**
		 * Ready the instance for a new load operation.
		 */
		public function cleanUp():void
		{	
			if ( _request )
			{
				_request.removeEventListener(Event.COMPLETE,_complete);
				_request.removeEventListener(IOErrorEvent.IO_ERROR,_xmlError);
				_request.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_xmlError);
				_request.dispose();
				_request = null;
			}
			
			_isLoading = false;
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		public function dispose():void
		{
			cleanUp();
			
			_xml = null;
		}
		
		/**
		 * Access a reference to the most recently loaded XML.
		 */
		public function getXML():XML
		{	
			return _xml;
		}
		
		/**
		 * Specify whether the instance logs all events and errors.
		 * 
		 * @param p_value Verbose boolean value.
		 */
		public function setVerbose(p_value:Boolean):void
		{
			_isVerbose = p_value;
		}
		
		private function _complete(p_event:Event):void
		{	
			try
			{
				_xml = new XML(_request.getText());

				_parse();
				
				cleanUp();
				
				_xmlReady();
			}
			catch (p_error:Error)
			{
				cleanUp();
				
				_log(XMLServiceEvent.PARSE_ERROR+" "+p_error.message,Debug.L2_WARNING);
				
				var event:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.PARSE_ERROR);
				
				event.error = p_error.message;
				
				dispatchEvent(event);
			}
		}
		
		/**
		 * Override this method in a subclass to add any custom parsing that should complete
		 * before the XMLDataServiceEvent.READY event is dispatched.
		 */
		protected function _parse():void
		{
		}
		
		private function _xmlReady():void
		{	
			_log(XMLServiceEvent.READY,Debug.L1_EVENT);
			
			dispatchEvent(new XMLServiceEvent(XMLServiceEvent.READY));
		}
		
		private function _xmlError(p_event:ErrorEvent):void
		{
			cleanUp();
			
			_log(XMLServiceEvent.LOAD_ERROR,Debug.L2_WARNING);
			
			dispatchEvent(new XMLServiceEvent(XMLServiceEvent.LOAD_ERROR));
		}
		
		private function _log(p_item:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log("XMLService: \""+_uri+"\" "+p_item,p_level,p_introspect,p_initTabs);
			}
		}
	}
}