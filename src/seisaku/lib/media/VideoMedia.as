/*
 *  seisaku.co.uk
 * 
 *	Copyright (c) 2009 Seisaku Limited/Jed Richards 
 * 
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *	
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *	
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */
 
package seisaku.lib.media
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.MediaEvent;
	import seisaku.lib.net.NetStatusEventCode;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.MathUtils;
	import seisaku.lib.util.StringUtils;
	
	/**
	 * Model and view for a *progressively* loaded On2-VP6 encoded FLV or MPEG-4 H.264/AAC based
	 * video file (player 9.0.115.0 and later). This class is able to adapt to the different
	 * types of metadata found in various file types. Not designed for use with RMTP streams.
	 * 
	 * <p>In the context of these Media classes "preload time" is defined as the number
	 * of seconds worth of media stream to preload before the MediaEvent.PRELOAD_COMPLETE
	 * event is fired.</p>
	 * 
	 * <p>VideoMedia offers increased functionality via the setBandwidth() method. By calling
	 * this method and supplying an accurate estimate of the client's bandwidth the instance
	 * can auto-calculate the minimum preload time to ensure a stutter free play through.</p>
	 * 
	 * @see seisaku.lib.events.MediaEvent MediaEvent
	 * @see seisaku.lib.media.MediaState MediaState
	 */
	public class VideoMedia extends HideableSprite implements IThread,IMedia
	{
		protected var _video:Video;
		protected var _netStream:NetStream;
		protected var _connection:NetConnection;
		protected var _bitRate:Number;
		protected var _videoWidth:Number;
		protected var _videoHeight:Number;
		protected var _allowCompleteEvent:Boolean;
		protected var _userBandwidth:Number;
		protected var _volume:Number;
		protected var _isMuted:Boolean;
		protected var _secondsToPreload:Number;
		protected var _isPreloaded:Boolean;
		protected var _preloadProgress:Number;
		protected var _positionSecs:Number;
		protected var _loadProgress:Number;
		protected var _durationSecs:Number;
		protected var _thread:Thread;
		protected var _uri:String;
		protected var _ready:Boolean;
		protected var _isLoaded:Boolean;
		protected var _state:String;
		protected var _isVerbose:Boolean;
		protected var _fileName:String;
		protected var _fileExtension:String;
		protected var _controlsHolder:Sprite;
		protected var _mp4MetaDataLoaded:Boolean;
		protected var _standardMetaDataLoaded:Boolean;
		protected var _minSecondsToPreload:Number;
		protected var _maxSecondsToPreload:Number;
		
		/**
		 * Sets whether the instance should attempt to auto resize the Video instance
		 * when appropriate metadata is encountered.
		 */
		public var autoSizeOnMetaData:Boolean;
		
		/**
		 * Sets whether the video should rewind and pause on the first frame once it
		 * completes (setting loop to true will override this behaviour).
		 */
		public var autoRewind:Boolean;
		
		/**
		 * Sets whether the video should start playing as soon as the metadata has
		 * been acquired and the first few frames have been loaded into the client,
		 * i.e. it should play with minimum preloading.
		 */
		public var autoPlay:Boolean;
		
		/**
		 * Sets whether the video should continuing playing from the beginning again
		 * when it gets to the end.
		 */
		public var loop:Boolean;
		
		public var autoPlayWhenPreloaded:Boolean;
		
		/**
		 * @param p_isVerbose Boolean value specifying whether the instance should output events and errors.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 * @param p_showHideDuration Duration of the show/hide fade in seconds.
		 * @param p_showAlpha Alpha value of show state.
		 * @param p_hideAlpha Alpha value of hide state.
		 */
		public function VideoMedia(p_isVerbose:Boolean=false,p_startHidden:Boolean=false)
		{
			_isVerbose = p_isVerbose;
			
			autoPlay = false;
			loop = false;
			autoSizeOnMetaData = true;
			autoRewind = true;
			
			_volume = 1;
			_isMuted = false;
			_secondsToPreload = 5;
			_userBandwidth = 0;
			_thread = new Thread(this);
			_minSecondsToPreload = 0;
			_maxSecondsToPreload = 1000;
			
			_initVars();
			
			_state = MediaState.IDLE;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{	
			super._createChildren();
			
			_connection = new NetConnection();
			_connection.connect(null);
			
			_netStream = new NetStream(_connection);
			_netStream.client = {onCuePoint:_netStreamCuePoint,onMetaData:_netStreamMetaData};
			_netStream.addEventListener(NetStatusEvent.NET_STATUS,_netStreamStatus,false,0,true);
			
			_video = new Video();
			_video.attachNetStream(_netStream);
			_holder.addChild(_video);
			
			_controlsHolder = new Sprite();
			_holder.addChild(_controlsHolder);
		}
		
		/**
		 * Start to load a FLV.
		 * 
		 * @param p_uri FLV URI.
		 */
		public function load(p_uri:String):void
		{	
			if ( !_isStreamClosed() )
			{
				_log(MediaError.MEDIA_OPEN_MSG,Debug.L2_WARNING);
				
				return;
			}

			_uri = p_uri;
			
			_fileName = "\""+StringUtils.fileName(_uri)+"\"";
			
			_fileExtension = StringUtils.fileExtension(_uri);
			
			_netStream.play(_uri);
			
			_log(MediaEvent.LOAD_STARTED,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.LOAD_STARTED));
			
			if ( !autoPlay )
			{
				_netStream.pause();
				_netStream.seek(0);
			}
		}
		
		/**
		 * Play the FLV from its current position.
		 */
		public function play():void
		{
			if ( _isStreamClosed() )
			{
				_log(MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			if ( _isStreamPlaying() )
			{
				_log(MediaError.MEDIA_PLAYING,Debug.L2_WARNING);
				
				return;
			}
			
			_setState(MediaState.PLAYING);
			
			_netStream.resume();
		}
		
		/**
		 * Pause the FLV in its current position.
		 */
		public function pause():void
		{
			if ( _isStreamClosed()  )
			{
				_log(MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			if ( !_isStreamPlaying() )
			{
				_log(MediaError.MEDIA_PAUSED,Debug.L2_WARNING);
				
				return;
			}
			
			_setState(MediaState.PAUSED);
			
			_netStream.pause();
		}
		
		/**
		 * Close the stream.
		 */
		public function close():void
		{	
			if ( _isStreamClosed()  )
			{
				_log(MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			_log(MediaEvent.CLOSE,Debug.L1_EVENT);
			
			_initVars();
			
			_setState(MediaState.IDLE);
			
			dispatchEvent(new MediaEvent(MediaEvent.CLOSE));
			
			_netStream.close();
			
			_thread.stop();
		}
		
		/**
		 * Return a reference to an empty Sprite positioned at a depth suitable
		 * for an overlayed set of controls.
		 */
		public function getControlsHolder():Sprite
		{
			return _controlsHolder;
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
			
			_applyNewVolume( _isMuted ? 0 : _volume );
		}
		
		/**
		 * Return the muted state.
		 */
		public function getMuted():Boolean
		{	
			return _isMuted;
		}
		
		/**
		 * Set the volume. If volume is set to 0 muted state is automatically toggled.
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
			
			_applyNewVolume(_volume);
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
		 * @param p_value Volume to fade to as a value between 0 and 1.
		 * @param p_duration Volume fade duration.
		 */
		public function fadeVolumeTo(p_value:Number,p_duration:Number=1):void
		{
			if ( _volume == p_value )
			{
				return;
			}
			
			_volume = p_value;
			
			_isMuted = ( _volume == 0 ) ? true : false;
			
			var event:MediaEvent = new MediaEvent(MediaEvent.VOLUME_CHANGE);
			
			event.volume = _volume;
			
			dispatchEvent(event);
			
			TweenLite.to(_netStream,p_duration,{ease:Linear.easeNone,volume:_volume});
		}
		
		/**
		 * Resize the Video instance.
		 * 
		 * @param p_width New width.
		 * @param p_height New height.
		 */
		public function resizeVideo(p_width:Number,p_height:Number):void
		{	
			_video.width = p_width;
			_video.height = p_height;
		}
		
		/**
		 * Return the state of the VideoMedia instance.
		 */
		public function getState():String
		{
			return _state;
		}
		
		/**
		 * Return the length of the FLV in seconds. This value is only
		 * valid once the FLV metadata has been acquired.
		 */
		public function getDurationSecs():Number
		{	
			return _durationSecs;
		}
		
		public function getSecondsToPreload():Number
		{
			return _secondsToPreload;
		}
		
		/**
		 * Seek to a new position in the FLV by seconds.
		 * 
		 * @param p_value New position in seconds.
		 */
		public function setPositionSecs(p_value:Number):void
		{
			if ( _isStreamClosed()  )
			{
				_log(MediaError.MEDIA_CLOSED_MSG,Debug.L2_WARNING);
				
				return;
			}
			
			_netStream.seek(p_value);
				
			if ( getState() == MediaState.STOPPED_COMPLETE )
			{
				pause();
			}
		}
		
		/**
		 * Return the position of the FLV in seconds.
		 */
		public function getPositionSecs():Number
		{	
			return _positionSecs;
		}
		
		/**
		 * Seek to a new position in the FLV.
		 * 
		 * @param p_value New position as a value from 0 to 1.
		 */
		public function setPosition(p_value:Number):void
		{
			setPositionSecs(p_value*_durationSecs);
		}
		
		/**
		 * Return the position of the FLV as a value between 0 and 1.
		 */
		public function getPosition():Number
		{	
			var position:Number = _positionSecs/_durationSecs;
			 
			return (isNaN(position))?0:position;
		}
		
		/**
		 * Return the URI of the stream.
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
		 * Set the number of seconds of FLV that this instance will preload/buffer
		 * before the MediaEvent.PRELOAD_COMPLETE is fired.
		 * 
		 * @param p_value Seconds to preload.
		 */
		public function setSecondsToPreload(p_value:Number):void
		{	
			_secondsToPreload = p_value;
		}
		
		public function setSecondsToPreloadRange(p_min:Number,p_max:Number):void
		{
			_minSecondsToPreload = p_min;
			
			_maxSecondsToPreload = p_max;
		}
		
		/**
		 * Supply an estimate of the user's bandwidth. Any non-zero value set here
		 * will be used to calculate the preload time, as long as this method is
		 * called before the FLV loading operation begins.
		 * 
		 * @param p_value Bandwidth value in kilobits/second.
		 */
		public function setBandwidth(p_value:Number):void
		{
			_userBandwidth = p_value;
		}
		
		/**
		 * Return the load progress of the FLV as a value between 0 and 1.
		 */
		public function getLoadProgress():Number
		{	
			return _loadProgress;
		}
		
		/**
		 * Return the number of second's worth of FLV loaded.
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
		 * Enable/disable smoothing on scaled video.
		 * 
		 * @param p_value Boolean video smoothing value.
		 */
		public function setVideoSmoothing(p_value:Boolean):void
		{
			_video.smoothing = p_value;
		}
		
		/**
		 * Public run method for the thread.
		 */
		public function run():void
		{	
			_auditPreloadProgress();
			_auditLoadProgress();
			_auditPosition();
		}
		
		/**
		 * Determine if the FLV media has been fully loaded into the client.
		 */
		public function getIsLoaded():Boolean
		{
			return _isLoaded;
		}
		
		/**
		 * Ready the instance for garbage collection.
		 */
		override public function dispose():void
		{	
			close();
				
			_connection.close();
			_connection = null;
			
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS,_netStreamStatus);
			_netStream.close();
			_netStream = null;
			
			_holder.removeChild(_video);
			_video = null;
			
			_holder.removeChild(_controlsHolder);
			_controlsHolder = null;
			
			super.dispose();
		}
		
		public function pauseStream():void
		{
			
		}
		
		public function resumeStream():void
		{
			
		}
		
		protected function _getPreloadProgress():Number
		{	
			var preloadProgress:Number = Math.min(1,getLoadedSecs()/_secondsToPreload);
			
			if ( _secondsToPreload > _durationSecs )
			{
				preloadProgress = _getLoadProgress();
			}
			
			return isNaN(preloadProgress) ? 0 : preloadProgress;
		}
		
		protected function _auditPreloadProgress():void
		{	
			var preloadProgress:Number = _getPreloadProgress();
			
			if ( _preloadProgress != preloadProgress )
			{
				_preloadProgress = preloadProgress;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.PRELOAD_PROGRESS);
				event.preloadProgress = _preloadProgress;
				dispatchEvent(event);
			}
			
			if ( _preloadProgress == 1 && !_isPreloaded )
			{
				_isPreloaded = true;
				
				dispatchEvent(new MediaEvent(MediaEvent.PRELOAD_COMPLETE));

				_log(MediaEvent.PRELOAD_COMPLETE,Debug.L1_EVENT);
				
				if ( autoPlayWhenPreloaded )
				{
					play();
				}
			}
		}
		
		protected function _auditLoadProgress():void
		{	
			var loadProgress:Number = _getLoadProgress();
			
			if ( _loadProgress != loadProgress )
			{
				_loadProgress = loadProgress;
				
				var event:MediaEvent = new MediaEvent(MediaEvent.LOAD_PROGRESS);
				event.loadProgress = _loadProgress;
				dispatchEvent(event);
			}
			
			if ( _loadProgress == 1 && !_isLoaded && _isPreloaded )
			{
				_isLoaded = true;
					
				_log(MediaEvent.LOAD_COMPLETE,Debug.L1_EVENT);
					
				dispatchEvent(new MediaEvent(MediaEvent.LOAD_COMPLETE));
			}
		}
		
		protected function _auditPosition():void
		{	
			var currentPositionSecs:Number = Math.min(_netStream.time,_durationSecs);
			
			if ( _positionSecs != currentPositionSecs )
			{
				_positionSecs = currentPositionSecs;

				var event:MediaEvent = new MediaEvent(MediaEvent.PLAY_PROGRESS);
				event.playProgress = getPosition();
				dispatchEvent(event);
				
				_allowCompleteEvent = true;
			}
			
			if ( _positionSecs >= _durationSecs && _state == MediaState.PLAYING && _allowCompleteEvent )
			{
				_flvComplete();
			}
		}
		
		protected function _flvComplete():void
		{		
			_allowCompleteEvent = false;
			
			if ( loop )
			{
				setPosition(0);
				
				play();
			}
			else
			{
				if ( autoRewind )
				{
					setPosition(0);
				}
				
				_netStream.pause();
				
				_setState(MediaState.STOPPED_COMPLETE);
			}
			
			_log(MediaEvent.COMPLETE,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.COMPLETE));
		}
		
		protected function _getLoadProgress():Number
		{
			var loadProgress:Number = _netStream.bytesLoaded/_netStream.bytesTotal;
			
			return ( isNaN(loadProgress)) ? 0 : loadProgress;
		}
		
		protected function _netStreamMetaData(p_metadata:Object):void
		{
			// We'll use the presence of the "canSeekToEnd" property to determine if
			// the metadata is standard MP4 metadata or FLV/F4V-style Adobe metadata:
			
			if ( p_metadata.canSeekToEnd == undefined )
			{
				_parseMP4MetaData(p_metadata);
			}
			else
			{
				_parseStandardMetaData(p_metadata);
			}
		}
		
		protected function _parseMP4MetaData(p_metadata:Object):void
		{
			if ( _mp4MetaDataLoaded )
			{
				return;
			}
			
			_log(MediaEvent.MP4_METADATA,Debug.L1_EVENT);
				
			_mp4MetaDataLoaded = true;
						
			_durationSecs = p_metadata.duration;
			
			// MP4 metadata doesn't contain videodatarate and audiodatarate values like Adobe
			// FLV and F4V metadata, so we'll estimate the overall bitrate via the stream byte
			// size and duration values:
			
			_bitRate = Math.round(MathUtils.bytesToKiloBits(_netStream.bytesTotal)/_durationSecs);
						
			_videoWidth = p_metadata.width;
			_videoHeight = p_metadata.height;
			
			if ( autoSizeOnMetaData && !isNaN(_videoWidth) && !isNaN(_videoHeight) )
			{
				resizeVideo(_videoWidth,_videoHeight);
			}
			
			// If the user's bandwidth value has been set to a valid non-zero figure we'll use it
			// to calculate how many seconds to preload:
			
			if ( _userBandwidth != 0 && !isNaN(_userBandwidth) )
			{
				_secondsToPreload = MathUtils.simpleBuffer(_durationSecs,_bitRate,_userBandwidth);
				
				_secondsToPreload = MathUtils.limit(_secondsToPreload,_minSecondsToPreload,_maxSecondsToPreload);
			}
						
			if ( _isVerbose )
			{
				Debug.log("  duration : "+_durationSecs+" s",Debug.L0_INFORMATIONAL);
				Debug.log("  bitrate : "+_bitRate+" Kb/s",Debug.L0_INFORMATIONAL);
				Debug.log("  width : "+_videoWidth,Debug.L0_INFORMATIONAL);
				Debug.log("  height : "+_videoHeight,Debug.L0_INFORMATIONAL);
				Debug.log("  preload seconds : "+_secondsToPreload+" s",Debug.L0_INFORMATIONAL);
			}
			
			var event:MediaEvent = new MediaEvent(MediaEvent.MP4_METADATA);
			event.metadata = p_metadata;
			dispatchEvent(event);
			
			// If the file is an F4V it is likely to contain both MP4 metadata and additional
			// metadata injected by the Adobe Media Encoder. We'll only declare the stream ready
			// if the file isn't an F4V and Adobe Media Encoder metadata hasn't been parsed.
			
			if ( _fileExtension != "f4v" && !_standardMetaDataLoaded )
			{
				_streamReady();
			}			
		}
		
		protected function _parseStandardMetaData(p_metadata:Object):void
		{
			if ( _standardMetaDataLoaded )
			{
				return;
			}
			
			_log(MediaEvent.METADATA,Debug.L1_EVENT);
			
			_standardMetaDataLoaded = true;
			
			_durationSecs = p_metadata.duration;
			
			// If we have valid videodatarate and audiodatarate metadata values we can use
			// these to calculate the bitrate accurtately, otherwise calculate it based on
			// the stream size and duration like we do for MP4-style metadata:
			
			if ( p_metadata.videodatarate && p_metadata.audiodatarate )
			{
				_bitRate = p_metadata.videodatarate + p_metadata.audiodatarate;
			}
			else
			{
				_bitRate = MathUtils.bytesToKiloBits(_netStream.bytesTotal)/_durationSecs;
			}

			_videoWidth = p_metadata.width;
			_videoHeight = p_metadata.height;
			
			if ( autoSizeOnMetaData && !isNaN(_videoWidth) && !isNaN(_videoHeight) )
			{
				resizeVideo(_videoWidth,_videoHeight);
			}
			
			// If the user's bandwidth value has been set to a valid non-zero figure we'll use it
			// to calculate how many seconds to preload:
			
			if ( _userBandwidth != 0 && !isNaN(_userBandwidth) )
			{
				_secondsToPreload = MathUtils.simpleBuffer(_durationSecs,_bitRate,_userBandwidth);
				
				_secondsToPreload = MathUtils.limit(_secondsToPreload,_minSecondsToPreload,_maxSecondsToPreload);
			}
			
			if ( _isVerbose )
			{
				Debug.log("  duration : "+_durationSecs+" s",Debug.L0_INFORMATIONAL);
				Debug.log("  bitrate : "+_bitRate+" Kb/s",Debug.L0_INFORMATIONAL);
				Debug.log("  width : "+_videoWidth,Debug.L0_INFORMATIONAL);
				Debug.log("  height : "+_videoHeight,Debug.L0_INFORMATIONAL);
				Debug.log("  preload seconds : "+_secondsToPreload+" s",Debug.L0_INFORMATIONAL);
			}
			
			var event:MediaEvent = new MediaEvent(MediaEvent.METADATA);
			event.metadata = p_metadata;
			dispatchEvent(event);
			
			_streamReady();
		}
		
		protected function _netStreamStatus(p_event:NetStatusEvent):void
		{
			var event:MediaEvent = new MediaEvent(MediaEvent.NETSTREAM_STATUS);
			event.netStatusCode = p_event.info.code;
			dispatchEvent(event);
			
			switch ( p_event.info.code )
			{
				case NetStatusEventCode.NETSTREAM_PLAY_STREAMNOTFOUND:
					
					_log(MediaEvent.LOAD_ERROR,Debug.L1_EVENT);
					
					_setState(MediaState.ERROR_IDLE);
					
					dispatchEvent(new MediaEvent(MediaEvent.LOAD_ERROR));
					
					break;
					
				case NetStatusEventCode.NETSTREAM_PLAY_STOP:
					
					if ( _allowCompleteEvent && _state == MediaState.PLAYING && _positionSecs >= Math.floor(_durationSecs) )
					{
						_flvComplete();
					}
					
					break;
			}
		}
		
		protected function _streamReady():void
		{	
			if ( _ready )
			{
				return;
			}
			
			_ready = true;
			
			if ( autoPlay )
			{
				_setState(MediaState.PLAYING);
			}
			else
			{
				_setState(MediaState.PAUSED);
			}
			
			_log(MediaEvent.READY,Debug.L1_EVENT);
			
			dispatchEvent(new MediaEvent(MediaEvent.READY));
			
			_thread.start();
		}
		
		protected function _netStreamCuePoint(p_cuePoint:Object):void
		{	
			var cuePointEvent:MediaEvent = new MediaEvent(MediaEvent.CUE_POINT);
			cuePointEvent.cuePoint = p_cuePoint;
			dispatchEvent(cuePointEvent);
		}
		
		protected function _applyNewVolume(p_value:Number):void
		{	
			var soundTransform:SoundTransform = _netStream.soundTransform;
			soundTransform.volume = p_value;
			_netStream.soundTransform = soundTransform;
			
			var event:MediaEvent = new MediaEvent(MediaEvent.VOLUME_CHANGE);
			event.volume = p_value;
			
			dispatchEvent(event);
		}
		
		protected function _setState(p_value:String):void
		{
			if ( p_value == _state )
			{
				return;
			}
			
			_state = p_value;
			
			_log(MediaEvent.STATE_CHANGE+" "+_state,Debug.L1_EVENT);
			
			var event:MediaEvent = new MediaEvent(MediaEvent.STATE_CHANGE);
			event.state = _state;
			dispatchEvent(event);
		}
		
		protected function _log(p_value:*,p_level:uint=0):void
		{
			if ( _isVerbose )
			{
				Debug.log("VideoMedia "+_fileName+" "+p_value,p_level);
			}
		}
		
		protected function _initVars():void
		{
			_bitRate = 0;
			_videoWidth = 0;
			_videoHeight = 0;
			_allowCompleteEvent = false;
			_isPreloaded = false;
			_preloadProgress = 0;
			_positionSecs = 0;
			_loadProgress = 0;
			_durationSecs = 0;
			_uri = "";
			_ready = false;
			_isLoaded = false;
			_mp4MetaDataLoaded = false;
			_standardMetaDataLoaded = false;
			_fileExtension = "";
		}
		
		protected function _isStreamClosed():Boolean
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
		
		protected function _isStreamPlaying():Boolean
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