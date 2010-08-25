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
 
package seisaku.lib.media {
	
	/**
	 * Static constants for the media states.
	 */
	public class MediaState
	{	
		/**
		 * The idle state is active while the media stream is closed.
		 */
		public static const IDLE:String = "idle";
		
		/**
		 * The playing state is active while the instance is advancing through a media stream.
		 */
		public static const PLAYING:String = "playing";
		
		/**
		 * The paused state is active while a media stream is open, but not being played.
		 */
		public static const PAUSED:String = "paused";
		
		/**
		 * The stoppedComplete state is active while a media stream is open and has played to a conclusion and stopped.
		 */
		public static const STOPPED_COMPLETE:String = "stoppedComplete";
		
		/**
		 * This idle-like state is entered after the media fails to load from a URL.
		 */
		public static const ERROR_IDLE:String = "errorIdle";
		
		/**
		 * This state is briefly entered while the media is buffering enough data to start playing.
		 * It is not related to the preloading or loading events.
		 */
		public static const INITIAL_BUFFERING:String = "initialBuffering";
	}
}