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
 
package seisaku.lib.puremvc
{
	import flash.net.URLVariables;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import seisaku.lib.data.XMLService;
	import seisaku.lib.events.XMLServiceEvent;
	import seisaku.lib.util.Debug;

	/**
	 * PureMVC proxy to a static XML file, or dynamic XML based web service.
	 */
	public class XMLServiceProxy extends Proxy implements IProxy
	{
		protected var _service:XMLService;
		protected var _isVerbose:Boolean;
		
		public function XMLServiceProxy(p_name:String,p_data:Object)
		{
			super(p_name,p_data);
		}
		
		override public function onRegister():void
		{
			_isVerbose = true;
			
			_service = new XMLService();
			
			_service.addEventListener(XMLServiceEvent.LOAD_ERROR,_xmlLoadError);
			_service.addEventListener(XMLServiceEvent.PARSE_ERROR,_xmlParseError);
			_service.addEventListener(XMLServiceEvent.READY,_xmlReady);
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
		
		/**
		 * Load the contents of a static XML file or dynamic XML web service.
		 * 
		 * @param p_uri URI of the resource.
		 * @param p_vars Optional URLVariables instance.
		 */
		public function load(p_uri:String,p_vars:URLVariables=null):void
		{	
			_service.load(p_uri,p_vars);
		}
		
		protected function _xmlLoadError(p_event:XMLServiceEvent):void
		{
			_log(p_event.type,Debug.L2_WARNING);
		}
		
		protected function _xmlParseError(p_event:XMLServiceEvent):void
		{
			_log(p_event.type,Debug.L2_WARNING);
		}
		
		protected function _xmlReady(p_event:XMLServiceEvent):void
		{
			_log(p_event.type,Debug.L0_INFORMATIONAL);
		}
		
		private function _log(p_item:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log(proxyName+": "+p_item,p_level,p_introspect,p_initTabs);
			}
		}
	}
}