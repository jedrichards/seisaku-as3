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
 
package seisaku.lib.events
{
	import flash.events.Event;
	import flash.media.ID3Info;
	
	/**
	 * Custom event class for the Media classes.
	 */
	public class MediaEvent extends Event {
		
		/**
		 * Dispatched when the media stream starts to load into the client.
		 */
		public static const LOAD_STARTED:String = "mediaLoadStarted";
		
		/**
		 * Dispatched every frame as the media stream is loading into the client.
		 */
		public static const LOAD_PROGRESS:String = "mediaLoadProgress";
		
		/**
		 * Dispatched when the media stream is finished loading into the client.
		 */
		public static const LOAD_COMPLETE:String = "mediaLoadComplete";
		
		/**
		 * Dispatched when there's been an error loading the stream into the client.
		 */
		public static const LOAD_ERROR:String = "mediaLoadError";
		
		/**
		 * Dispatched every frame as the media is preloading. The amount of preloading
		 * is defined by the value passed to the secondsToPreload() IMedia method.
		 */
		public static const PRELOAD_PROGRESS:String = "mediaPreloadProgress";
		
		/**
		 * Dispatched when the media has finished preloading. The amount of preloading
		 * is defined by the value passed to the secondsToPreload() IMedia method.
		 */
		public static const PRELOAD_COMPLETE:String = "mediaPreloadComplete";
		
		/**
		 * Dispatched as soon as the media is ready to play, regardless of overall
		 * load/preload progress.
		 */
		public static const READY:String = "mediaReady";
		
		/**
		 * Dispatched when the media changes state. States defined in the MediaState class.
		 */
		public static const STATE_CHANGE:String = "mediaStateChange";
		
		/**
		 * Dispatched when the NetStream instance within FlvMedia dispatches a
		 * NetStatusEvent.NET_STATUS event.
		 */
		public static const NETSTREAM_STATUS:String = "mediaNetStreamStatus";
		
		/**
		 * Dispatched when FLV metadata or MP3 ID3 tags are available for inspection.
		 */
		public static const METADATA:String = "mediaMetadata";
		
		/**
		 * Dispatched when MP4 metadata is ecountered.
		 */
		public static const MP4_METADATA:String = "mp4Metadata";
		
		/**
		 * Dispatched every frame while the media position is changing.
		 */
		public static const PLAY_PROGRESS:String = "mediaPlayProgress";
		
		/**
		 * Dispatched every time the setVolume() IMedia method is invoked.
		 */
		public static const VOLUME_CHANGE:String = "mediaVolumeChange";
		
		/**
		 * Dispatched when the media has played to a conclusion.
		 */
		public static const COMPLETE:String = "mediaComplete";
		
		/**
		 * Dispatched when the media stream is closed.
		 */
		public static const CLOSE:String = "mediaClose";
		
		/**
		 * Dispatched when an FLV cue point is encountered.
		 */
		public static const CUE_POINT:String = "mediaCuePoint";
		
		/**
		 * Dispatched when the video plays head arrives in a video position time range
		 * that contains a subtitle.
		 */
		public static const ENTER_SUBTITLE:String = "mediaEnterSubtitle";
		
		/**
		 * Dispatched when the video play head exits a position time range that contains
		 * a subtitle.
		 */
		public static const EXIT_SUBTITLE:String = "mediaExitSubtitle";
		
		/**
		 * Dispatched when the still JPG image is loaded in a VideoMediaWithStill instance
		 */
		public static const STILL_LOADED:String = "stillLoaded";
		
		public var netStatusCode:String;
		public var loadProgress:Number;
		public var preloadProgress:Number;
		public var playProgress:Number;
		public var cuePoint:Object;
		public var state:String;
		public var id3:ID3Info;
		public var volume:Number;
		public var metadata:Object;
		public var subtitleIndex:Number;
		
		public function MediaEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{	
			super(p_type,p_bubbles,p_cancelable);
		}
		
		override public function clone():Event
		{
			var event:MediaEvent = new MediaEvent(type,bubbles,cancelable);
			
			event.netStatusCode = netStatusCode;
			event.loadProgress = loadProgress;
			event.preloadProgress = preloadProgress;
			event.playProgress = playProgress;
			event.cuePoint = cuePoint;
			event.state = state;
			event.id3 = id3;
			event.volume = volume;
			event.metadata = metadata;
			event.subtitleIndex = subtitleIndex;
			
            return event;
        }
        
        override public function toString():String
        {
        	return formatToString("MediaEvent","type","bubbles","cancelable","eventPhase","netStatusCode","loadProgress","preloadProgress","playProgress","cuePoint","state","id3","volume","metaData","subtitleIndex");
        }
	}
}