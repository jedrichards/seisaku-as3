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
 
package seisaku.lib.media
{
	import flash.events.IEventDispatcher;
	
	
	/**
	 * Common interface for media classes. Enables polymorphism between media types, for
	 * example media instances of different types (MP3 or FLV) could be interchangable
	 * between one set of controls.
	 */
	public interface IMedia extends IEventDispatcher
	{
		function load(p_uri:String):void;
		
		function play():void;
		
		function pause():void;
		
		function close():void;
		
		function setMuted(p_value:Boolean):void;
		
		function getMuted():Boolean;
		
		function setVolume(p_value:Number):void;
		
		function getVolume():Number;
		
		function fadeVolumeTo(p_value:Number,p_duration:Number=1):void;
		
		function getState():String;
		
		function getDurationSecs():Number;
		
		function setPositionSecs(p_value:Number):void;
		
		function getPositionSecs():Number;
		
		function setPosition(p_value:Number):void;
		
		function getPosition():Number;
		
		function getURI():String;
		
		function getPreloadProgress():Number;
		
		function setSecondsToPreload(p_value:Number):void;
		
		function getLoadProgress():Number;
		
		function getLoadedSecs():Number;
		
		function setVerbose(p_value:Boolean):void;
		
		function getReady():Boolean;
	}
}