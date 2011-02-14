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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import seisaku.lib.events.BandwidthCalculatorEvent;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.MathUtils;
	import seisaku.lib.util.StringUtils;
	
	/**
	 * This class times the loading operation of an arbitrary external data object (SWF, JPG, XML etc.)
	 * via a URLLoader and estimates the client's available bandwidth.
	 * 
	 * @see seisaku.lib.events.BandwidthCalculatorEvent BandwidthCalculatorEvent
	 */
	public class BandwidthCalculator extends EventDispatcher
	{				
		private var _startMS:Number;
		private var _bandwidth:Bandwidth;
		private var _loader:URLLoader;
		private var _isCalculating:Boolean;
		private var _applyOverhead:Boolean;
		private var _disableCache:Boolean;
		private var _isVerbose:Boolean;
		private var _overhead:Number;
		private var _fileName:String;
		
		/**
		 * @param p_isVerbose Boolean value specifying whether the instance should output events and errors.
		 */
		public function BandwidthCalculator(p_isVerbose:Boolean=true)
		{	
			_isVerbose = p_isVerbose;
			
			_overhead = 0.93;
			_disableCache = false;
			_applyOverhead = false;
			_bandwidth = new Bandwidth();
			_isCalculating = false;
			_fileName = "";
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.OPEN,_open,false,0,true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,_securityError,false,0,true);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,_httpStatus,false,0,true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,_ioError,false,0,true);
			_loader.addEventListener(Event.COMPLETE,_complete,false,0,true);
			_loader.addEventListener(ProgressEvent.PROGRESS,_progress,false,0,true);
		}
		
		/**
		 * Start calculating the bandwidth.
		 * 
		 * @param p_uri URI of a server object.
		 */
		public function calculate(p_uri:String):void
		{	
			if ( _isCalculating )
			{
				throw( new Error("Cannot perform multiple concurrent calculations") );
			}
			
			if ( _disableCache )
			{
				p_uri = StringUtils.appendCacheBuster(p_uri);
			}
			
			_fileName = "\""+StringUtils.fileName(p_uri)+"\"";
			
			try
			{
				_loader.load(new URLRequest(p_uri));
			}
			catch (p_error:Error)
			{
				_log(BandwidthCalculatorEvent.ERROR+" "+p_error.message,Debug.L2_WARNING);
				
				dispatchEvent(new BandwidthCalculatorEvent(BandwidthCalculatorEvent.ERROR));
			}
		}

		/**
		 * Return a copy of the Bandwidth instance that holds the user's estimated bandwidth.
		 * 
		 * @return A Bandwidth instance.
		 */
		public function getBandwidth():Bandwidth
		{	
			return _bandwidth.clone();
		}
		
		/**
		 * Specify whether the instance logs all events and errors to the Debug instance.
		 */
		public function setVerbose(p_value:Boolean):void
		{
			_isVerbose = p_value;
		}
		
		/**
		 * Specify whether the instance should append a random number in a query string
		 * to the load request in order to disable browser cachine.
		 */
		public function setDisableCache(p_value:Boolean):void
		{
			_disableCache = p_value;
		}
		
		/**
		 * Specify whether the instance should reduce the calculated bandwidth value to
		 * allow for packet overheads and general fluctuations in bandwidth.
		 */
		public function setApplyOverhead(p_value:Boolean):void
		{
			_applyOverhead = p_value;
		}
		
		/**
		 * Set the bandwidth overhead value. The final bandwidth value is calculated
		 * by multiplying the original bandwidth value by the overhead value.
		 */
		public function setOverhead(p_value:Number):void
		{
			_overhead = p_value;
		}
		
		/**
		 * Cancel the current load operation, remove event listeners and null internal properties
		 * ready for garbage collection.
		 */
		public function cleanUp():void
		{	
			_loader.removeEventListener(Event.OPEN,_open);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,_securityError);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,_httpStatus);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR,_ioError);
			_loader.removeEventListener(Event.COMPLETE,_complete);
			
			try
			{
				_loader.close();
			}
			catch (p_error:Error)
			{
			}
			
			_loader.data = null;
			
			_loader = null;
			
			_bandwidth = null;
		}
		
		private function _open(p_event:Event):void
		{	
			//_log(Event.OPEN,Debug.L1_EVENT);
			
			_startMS = getTimer();
			
			_isCalculating = true;
		}
		
		private function _progress(p_event:ProgressEvent):void
		{
			//_log(p_event.type,Debug.L1_EVENT);
			
			var event:BandwidthCalculatorEvent = new BandwidthCalculatorEvent(BandwidthCalculatorEvent.PROGRESS);
			
			event.progress = p_event.bytesLoaded/p_event.bytesTotal;
			
			dispatchEvent(event);
		}
		
		private function _complete(p_event:Event):void
		{	
			_isCalculating = false;
			
			_bandwidth.setDownloadMetrics(_loader.bytesTotal,(getTimer()-_startMS)/1000);
			
			if ( _applyOverhead )
			{
				_bandwidth.setBytesPerSecond( _bandwidth.getBytesPerSecond() * _overhead );
			}
			
			var kiloBitsPerSecond:Number = Math.round(_bandwidth.getKiloBitsPerSecond());
			var kiloBytesPerSecond:Number = Math.round(_bandwidth.getKiloBytesPerSecond());
			var megaBytesPerSecond:Number = MathUtils.round(_bandwidth.getKiloBytesPerSecond()*0.0009765625,2);
			
			_log("calucated "+kiloBitsPerSecond+" kb/s | "+kiloBytesPerSecond+" kB/s | "+megaBytesPerSecond+" MB/s ("+_overhead+" overhead)");
			
			var event:BandwidthCalculatorEvent = new BandwidthCalculatorEvent(BandwidthCalculatorEvent.COMPLETE);
			
			event.bandwidth = getBandwidth();
			
			dispatchEvent(event);
		}
		
		private function _httpStatus(p_event:HTTPStatusEvent):void
		{	
			//_log(HTTPStatusEvent.HTTP_STATUS+" "+p_event.status+" "+HTTPStatusInfo.getType(p_event.status));
		}
		
		private function _ioError(p_event:IOErrorEvent):void
		{	
			_log(IOErrorEvent.IO_ERROR+" "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(new BandwidthCalculatorEvent(BandwidthCalculatorEvent.ERROR));
		}
		
		private function _securityError(p_event:SecurityErrorEvent):void
		{	
			_log(SecurityErrorEvent.SECURITY_ERROR+" "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(new BandwidthCalculatorEvent(BandwidthCalculatorEvent.ERROR));
		}
		
		private function _log(p_item:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log("bandwidthCalculator: "+p_item,p_level,p_introspect,p_initTabs);
			}
		}
	}
}