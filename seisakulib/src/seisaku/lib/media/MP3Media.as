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
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import seisaku.lib.events.MediaEvent;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.Debug;
	
	/**
	 * Model for progressively streaming an MP3 over HTTP via a Sound instance.
	 * In order to report accurate play positions the MP3's length will be set from
	 * the value of its TLEN id3 tag, or if this tag is absent it will be calculated
	 * with increasing accuracy as the sound is loaded into the client.
	 * 
	 * <p>In the scope of these Media classes "preload time" is defined as the number
	 * of seconds worth of media stream to preload before the MediaEvent.PRELOAD_COMPLETE
	 * event is fired.</p>
	 * 
	 * <p>If the duration of the MP3 is not found in the ID3 tags the class will attempt
	 * to estimate the duration with increasing accuracy as the sound is loaded in.</p>
	 * 
	 * @see seisaku.lib.events.MediaEvent MediaEvent
	 * @see seisaku.lib.media.MediaState MediaState
	 */
	public class MP3Media extends EventDispatcher implements IThread,IMedia
	{	
		private var _isID3DurationValid:Boolean;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _volume:Number;
		private var _isMuted:Boolean;
		private var _secondsToPreload:Number;
		private var _thread:Thread;
		private var _state:String;
		private var _uri:String;
		private var _ready:Boolean;
		private var _isLoaded:Boolean;
		private var _isPreloaded:Boolean;
		private var _preloadProgress:Number;
		private var _positionSecs:Number;
		private var _loadProgress:Number;
		private var _durationSecs:Number;
		private var _isVerbose:Boolean;
		
		public var autoPlay:Boolean;
		public var loop:Boolean;
		
		/**
		 * MP3Media constructor.
		 * 
		 * @param p_isVerbose Boolean value specifying whether the instance should output events and errors.
		 */
		public function MP3Media(p_verbose:Boolean=false)
		{
			_isVerbose = p_verbose;
			
			autoPlay = false;
			loop = false;
			
			_volume = 1;
			_isMuted = false;
			_secondsToPreload = 5;
			_isID3DurationValid = false;
			
			_initVars();
			
			_thread = new Thread(this);
			
			_setState(MediaState.IDLE);
		}
		
		private function _refreshSound():void
		{
			if ( _sound )
			{
				_sound.removeEventListener(Event.OPEN,_soundLoadStart);
				_sound.removeEventListener(ProgressEvent.PROGRESS,_soundLoadProgress);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR,_soundLoadError);
				_sound.removeEventListener(Event.COMPLETE,_soundLoadComplete);
				_sound.removeEventListener(Event.ID3,_soundID3);
				
				_sound = null;
			}
			
			_sound = new Sound();
			
			_sound.addEventListener(Event.OPEN,_soundLoadStart);
			_sound.addEventListener(ProgressEvent.PROGRESS,_soundLoadProgress);
			_sound.addEventListener(IOErrorEvent.IO_ERROR,_soundLoadError);
			_sound.addEventListener(Event.COMPLETE,_soundLoadComplete);
			_sound.addEventListener(Event.ID3,_soundID3);
		}
		
		/**
		 * Start to load external media.
		 * 
		 * @param p_sUri Media URI.
		 */
		public function load(p_uri:String):void
		{	
			if ( !_isStreamClosed() )
			{
				_log("MP3Media "+MediaError.MEDIA_OPEN_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			_refreshSound();
			
			_uri = p_uri;
			
			_sound.load(new URLRequest(p_uri));
			
			_channel = _sound.play();
			
			_applyVolume(_volume);
			
			_applySoundCompleteEvent();
			
			_thread.start();
		}
		
		/**
		 * Play the MP3 in its current position.
		 */
		public function play():void
		{	
			if ( _isStreamClosed() )
			{
				_log("MP3Media "+MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			if ( _isStreamPlaying() )
			{
				_log("MP3Media "+MediaError.MEDIA_PLAYING,Debug.L2_WARNING);
				
				return;
			}
			
			_channel = _sound.play(getPositionSecs()*1000);
			
			_applyVolume(_volume);
			
			_applySoundCompleteEvent();
			
			_setState(MediaState.PLAYING);
		}
		
		/**
		 * Pause the media in its current position.
		 * 
		 * @throws seisaku.lib.media.MediaError You may call pause when there is no MP3 loaded.
		 */
		public function pause():void
		{	
			if ( _isStreamClosed()  )
			{
				_log("FLVMedia "+MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			if ( !_isStreamPlaying() )
			{
				_log("MP3Media "+MediaError.MEDIA_PAUSED,Debug.L2_WARNING);
				
				return;
			}
			
			_channel.stop();
			
			_setState(MediaState.PAUSED);
		}
		
		/**
		 * Close the MP3 stream.
		 * 
		 * @throws seisaku.lib.media.MediaError You may call close when there is no MP3 loaded.
		 */
		public function close():void
		{
			if ( _isStreamClosed()  )
			{
				_log("FLVMedia "+MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			_log("MP3Media "+MediaEvent.CLOSE,Debug.L1_EVENT);
			
			_initVars();
			
			_setState(MediaState.IDLE);
			
			dispatchEvent(new MediaEvent(MediaEvent.CLOSE));

			_channel.stop();
			
			try
			{
				
				_sound.close();
			}
			catch(p_error:IOError)
			{
				_log("MP3Media error "+p_error.message,Debug.L2_WARNING);
			}
			
			_thread.stop();
		}
		
		/**
		 * Set the muted state.
		 * 
		 * @param p_value Muted state.
		 */
		public function setMuted(p_value:Boolean):void
		{	
			if ( _isMuted == p_value )
			{
				return;
			}
			
			_isMuted = p_value;
			
			_applyVolume( _isMuted ? 0 : _volume );
		}
		
		/**
		 * Return the muted state.
		 */
		public function getMuted():Boolean
		{
			return _isMuted;
		}
		
		/**
		 * Set the volume.
		 * 
		 * @param p_value Volume as a value from 0 to 1.
		 */
		public function setVolume(p_value:Number):void
		{	
			if ( _volume == p_value )
			{
				return;
			}
			
			_volume = p_value;
			
			_isMuted = ( _volume == 0 ) ? true : false;
			
			dispatchEvent(new MediaEvent(MediaEvent.VOLUME_CHANGE));
			
			_applyVolume(_volume);
		}
		
		/**
		 * Return the current volume as a value between 0 and 1.
		 */
		public function getVolume():Number
		{	
			return _volume;
		}
		
		/**
		 * Fade the volume over a period of time.
		 * 
		 * @param p_nVolume Stream's target volume.
		 * @param p_nDuration Volume fade duration.
		 */
		public function fadeVolumeTo(p_nVolume:Number,p_nDuration:Number=1):void
		{
			if ( _volume == p_nVolume )
			{
				return;
			}
			
			_volume = p_nVolume;
			
			_isMuted = ( _volume == 0 ) ? true : false;
			
			var event:MediaEvent = new MediaEvent(MediaEvent.VOLUME_CHANGE);
			
			event.volume = _volume;
			
			dispatchEvent(event);
			
			TweenLite.to(_channel,p_nDuration,{ease:Linear.easeNone,volume:_volume});
		}
		
		/**
		 * Return the state of the MP3Media instance.
		 */
		public function getState():String
		{	
			return _state;
		}
		
		/**
		 * Return the length of the MP3 in seconds. Assumed accurate if found
		 * in the MP3 ID3 metadata, or else is calculated with increasing
		 * accuracy as the sound is progressively downloaded.
		 */
		public function getDurationSecs():Number
		{
			return _durationSecs;
		}
		
		/**
		 * Set the play position of the stream.
		 * 
		 * @param p_value New position in seconds.
		 */
		public function setPositionSecs(p_value:Number):void
		{	
			if ( _isStreamClosed()  )
			{
				_log("FLVMedia "+MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			if ( _isStreamPlaying() )
			{
				_channel.stop();
				
				_channel = _sound.play(p_value*1000);
				
				_applyVolume(_volume);
				
				_applySoundCompleteEvent();
			}
			else
			{
				_positionSecs = p_value;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				event.playProgress = getPosition();
				dispatchEvent(event);
			}
		}
		
		/**
		 * Set the play position of the stream.
		 * 
		 * @param p_value New position, as a value from 0 to 1.
		 */
		public function setPosition(p_value:Number):void
		{				
			setPositionSecs(_durationSecs*p_value);
		}
		
		/**
		 * Return the position of the MP3 as a value between 0 and 1.
		 */
		public function getPosition():Number
		{	
			var position:Number = _positionSecs/_durationSecs;
			
			return ( isNaN(position) ) ? 0 : position;
		}
		
		/**
		 * Return the play position of the MP3 in seconds.
		 * 
		 * @return Play position.
		 */
		public function getPositionSecs():Number
		{
			return ( isNaN(_positionSecs) ) ? 0 : _positionSecs;
		}
		
		/**
		 * Return the URI of the MP3.
		 */
		public function getURI():String
		{
			return _uri;
		}

		/**
		 * Return the preload progress of FLV as a value between 0 and 1.
		 */
		public function getPreloadProgress():Number
		{	
			return _preloadProgress;
		}
		
		/**
		 * Set the number of seconds of MP3 that this instance will preload/buffer
		 * before the MediaEvent.PRELOAD_COMPLETE is fired.
		 * 
		 * @param p_value Seconds to preload.
		 */
		public function setSecondsToPreload(p_value:Number):void
		{
			_secondsToPreload = p_value;
		}
		
		/**
		 * Return the load progress of the MP3 as a value between 0 and 1.
		 */
		public function getLoadProgress():Number
		{	
			return _loadProgress;
		}
		
		/**
		 * Return the number of second's worth of MP3 loaded.
		 */
		public function getLoadedSecs():Number
		{	
			return _durationSecs*getLoadProgress();
		}
		
		/**
		 * Specify whether the instance logs all events and errors to the Debug class.
		 * 
		 * @param p_value Verbose boolean value.
		 */
		public function setVerbose(p_value:Boolean):void
		{
			_isVerbose = p_value;
		}
		
		/**
		 * Get the ready state of the media.
		 */
		public function getReady():Boolean
		{
			return _ready;
		}
		
		/**
		 * Public run method for the thread.
		 */
		public function run():void
		{	
			if ( !_isPreloaded )
			{
				_auditPreloadProgress();
			}
			
			if ( !_ready && !_sound.isBuffering )
			{
				_soundReady();
			}
			
			_auditPosition();
		}

		private function _getPreloadProgress():Number
		{	
			var preloadProgress:Number = Math.min(1,getLoadedSecs()/_secondsToPreload);
			
			return (isNaN(preloadProgress) ) ? 0 : preloadProgress;
		}
		
		private function _auditPreloadProgress():void
		{
			var preloadProgress:Number = _getPreloadProgress();
			
			if ( _preloadProgress != preloadProgress )
			{
				_preloadProgress = preloadProgress;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.PRELOAD_PROGRESS);
				event.preloadProgress = _preloadProgress;
				dispatchEvent(event);
				
				if ( _preloadProgress == 1 )
				{					
					_isPreloaded = true;
					
					_log("MP3Media "+MediaEvent.PRELOAD_COMPLETE,Debug.L1_EVENT);
					
					dispatchEvent(new MediaEvent(MediaEvent.PRELOAD_COMPLETE));
				}
			}
		}
		
		private function _soundReady():void
		{			
			_ready = true;
			
			if ( _sound.id3.TLEN != undefined )
			{				
				_isID3DurationValid = true;
				
				_durationSecs = _sound.id3.TLEN*0.001;
			}
			
			if ( autoPlay )
			{
				_setState(MediaState.PLAYING);
			}
			else
			{
				_setState(MediaState.PAUSED);
				
				_channel.stop();
			}
			
			_log("MP3Media "+MediaEvent.READY,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.READY));
		}
		
		private function _auditPosition():void
		{
			var playProgressSecs:Number = _channel.position*0.001;
			
			if ( _state == MediaState.PLAYING && _positionSecs != playProgressSecs )
			{
				_positionSecs = playProgressSecs;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				event.playProgress = getPosition();
				dispatchEvent(event);
			}
		}
		
		private function _getLoadProgress():Number
		{
			var loadProgress:Number = _sound.bytesLoaded/_sound.bytesTotal;
			
			return (isNaN(loadProgress))?0:loadProgress;
		}
		
		private function _soundID3(p_event:Event):void
		{	
			_sound.removeEventListener(Event.ID3,_soundID3);
			
			_log("MP3Media "+MediaEvent.METADATA,Debug.L1_EVENT);
			
			_log(_sound.id3,Debug.L0_INFORMATIONAL,true,"  ");
			
			var event:MediaEvent = new MediaEvent(MediaEvent.METADATA);
			event.id3 = _sound.id3;
			dispatchEvent(event);
		}
		
		private function _soundLoadError(p_event:IOErrorEvent):void
		{
			_log("MP3Media "+MediaEvent.LOAD_ERROR,Debug.L1_EVENT);
			
			_setState(MediaState.ERROR_IDLE);
			
			dispatchEvent(new MediaEvent(MediaEvent.LOAD_ERROR));
		}
		
		private function _soundLoadProgress(p_event:ProgressEvent):void
		{
			_loadProgress = _getLoadProgress();
			
			var event:MediaEvent = new MediaEvent(MediaEvent.LOAD_PROGRESS);
			event.loadProgress = _loadProgress;
			dispatchEvent(event);
			
			if ( !_isID3DurationValid )
			{
				_durationSecs = ((1/_loadProgress)*_sound.length)*0.001;
			}
		}
		
		private function _soundLoadComplete(p_event:Event):void
		{
			_log("MP3Media "+MediaEvent.LOAD_COMPLETE,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
		}
		
		private function _soundLoadStart(p_event:Event):void
		{
			_log("MP3Media "+MediaEvent.LOAD_STARTED,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.LOAD_STARTED));
			
			_setState(MediaState.INITIAL_BUFFERING);
		}
		
		private function _soundComplete(p_event:Event):void
		{
			_log("MP3Media "+MediaEvent.COMPLETE,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.COMPLETE));
			
			if ( !loop )
			{
				_setState(MediaState.STOPPED_COMPLETE);
				_channel.stop();
				_positionSecs = 0;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				event.playProgress = getPosition();
				dispatchEvent(event);
			}
			else
			{
				setPosition(0);
			}
		}
		
		private function _applyVolume(p_value:Number):void
		{
			var soundTransform:SoundTransform = _channel.soundTransform;
			
			soundTransform.volume = p_value;
			
			_channel.soundTransform = soundTransform;
		}
		
		private function _applySoundCompleteEvent():void
		{
			_channel.addEventListener(Event.SOUND_COMPLETE,_soundComplete,false,0,true);
		}
		
		private function _setState(p_value:String):void
		{	
			if ( p_value == _state )
			{
				return;
			}
			
			_state = p_value;
			
			_log("MP3Media "+MediaEvent.STATE_CHANGE+" "+_state,Debug.L1_EVENT);
			
			var event:MediaEvent = new MediaEvent(MediaEvent.STATE_CHANGE);
			event.state = _state;
			dispatchEvent(event);
		}
		
		private function _log(p_value:*,p_level:uint=0,p_introspect:Boolean=false,p_initTabs:String=""):void
		{
			if ( _isVerbose )
			{
				Debug.log(p_value,p_level,p_introspect,p_initTabs);
			}
		}
		
		private function _initVars():void
		{
			_ready = false;
			_isID3DurationValid = false;
			_uri = "";
			_isLoaded = false;
			_isPreloaded = false;
			_preloadProgress = 0;
			_positionSecs = 0;
			_loadProgress = 0;
			_durationSecs = 0;
		}
		
		private function _isStreamClosed():Boolean
		{
			if ( _state == MediaState.IDLE || _state == MediaState.ERROR_IDLE )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function _isStreamPlaying():Boolean
		{
			if ( _state == MediaState.PLAYING )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}