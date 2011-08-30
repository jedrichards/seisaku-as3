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
 
package seisaku.lib.display.ui.mediacontrols
{
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.display.ui.Button;
	import seisaku.lib.display.ui.ProgressBar;
	import seisaku.lib.events.ButtonEvent;
	import seisaku.lib.events.MediaEvent;
	import seisaku.lib.media.IMedia;
	import seisaku.lib.media.MediaState;
	import seisaku.lib.util.DisplayObjectUtils;
	
	/**
	 * Set of generic controls for use with the media classes that extend IMedia. The
	 * controls are programmatically generated so do not rely on the presence of any
	 * visual assets to work properly. Useful for quickly applying controls to video or
	 * MP3 media during the prototyping phase.
	 * 
	 * @see seisaku.lib.media.FLVMedia
	 * @see seisaku.lib.media.MP3Media
	 */
	public class MediaControls extends HideableSprite
	{		
		private var _controlsHolder:HideableSprite;
		private var _background:Shape;
		private var _playPauseButton:MediaControlsPlayPauseButton;
		private var _rewindButton:MediaControlsRewindButton;
		private var _muteButton:MediaControlsMuteButton;
		private var _media:IMedia;
		private var _width:Number;
		private var _buttonHeight:Number;
		private var _padding:Number;
		private var _barsGlowShape:Shape;
		private var _loadProgress:ProgressBar;
		private var _playProgress:ProgressBar;
		private var _seekButton:Button;
		private var _isEnabled:Boolean;
		private var _disabledAlpha:Number;
		
		/**
		 * @param p_width Initial width for the media controls.
		 * @param p_startHidden Whether to create the HideableSprite on stage in a hidden state.
		 */
		public function MediaControls(p_width:Number=300,p_buttonHeight:Number=20,p_padding:Number=5,p_startHidden:Boolean=false)
		{
			_width = p_width;
			_buttonHeight = p_buttonHeight;
			_padding = p_padding;
			
			_isEnabled = true;
			_disabledAlpha = 0.3;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_controlsHolder = new HideableSprite();
			_controlsHolder.setHideAlpha(_disabledAlpha);
			_holder.addChild(_controlsHolder);
			
			_background = new Shape();
			DisplayObjectUtils.drawRect(_background.graphics,new Rectangle(0,0,_width,_buttonHeight+(_padding*2)),0x000000,0.7);
			_controlsHolder.addChildToHolder(_background);
			
			_playPauseButton = new MediaControlsPlayPauseButton();
			_playPauseButton.addEventListener(ButtonEvent.CLICK,_playPauseButtonClick);
			_playPauseButton.x = _padding;
			_playPauseButton.y = _padding;
			_playPauseButton.width = _buttonHeight;
			_playPauseButton.height = _buttonHeight;
			_controlsHolder.addChildToHolder(_playPauseButton);
			
			_rewindButton = new MediaControlsRewindButton();
			_rewindButton.addEventListener(ButtonEvent.CLICK,_rewindButtonClick);
			_rewindButton.x = _playPauseButton.x + _playPauseButton.width + _padding;
			_rewindButton.y = _padding;
			_rewindButton.width = _buttonHeight;
			_rewindButton.height = _buttonHeight;
			_controlsHolder.addChildToHolder(_rewindButton);
			
			_muteButton = new MediaControlsMuteButton();
			_muteButton.addEventListener(ButtonEvent.CLICK,_muteButtonClick);
			_muteButton.y = _padding;
			_muteButton.width = _buttonHeight;
			_muteButton.height = _buttonHeight;
			_muteButton.x = _width - _padding - _muteButton.width;
			_controlsHolder.addChildToHolder(_muteButton);
			
			var barWidth:Number = _width - ( _rewindButton.x + _rewindButton.width + _muteButton.width+ (_padding*3));
			
			_barsGlowShape = new Shape();
			_barsGlowShape.x = _rewindButton.x + _rewindButton.width + _padding;
			_barsGlowShape.y = _padding;
			DisplayObjectUtils.drawRect(_barsGlowShape.graphics,new Rectangle(0,0,barWidth,_buttonHeight));
			_barsGlowShape.filters = [new GlowFilter(0x000000,0.7,4,5,1.15,2,false,true)];
			_controlsHolder.addChildToHolder(_barsGlowShape);
			
			_loadProgress = new ProgressBar(barWidth,_buttonHeight,0xffffff,0x000000,0.25,0);
			_loadProgress.x = _barsGlowShape.x;
			_loadProgress.y = _barsGlowShape.y;
			_controlsHolder.addChildToHolder(_loadProgress);
			
			_playProgress = new ProgressBar(barWidth,_buttonHeight,0xffffff,0x000000,0.25,0);
			_playProgress.x = _barsGlowShape.x;
			_playProgress.y = _barsGlowShape.y;
			_controlsHolder.addChildToHolder(_playProgress);
			
			_seekButton = new Button();
			_seekButton.addEventListener(ButtonEvent.CLICK,_seekButtonClick,false,0,true);
			_seekButton.x = _barsGlowShape.x;
			_seekButton.y = _barsGlowShape.y;
			_seekButton.createHitSprite(0,0,barWidth,_buttonHeight);
			_controlsHolder.addChildToHolder(_seekButton);
		}
		
		/**
		 * Attach the controls to an IMedia instance.
		 * 
		 * @param p_media Media instance to control.
		 * @param p_position Position of the controls relative to the media.
		 */
		public function attachMedia(p_media:IMedia):void
		{			
			if ( _media )
			{
				_media.removeEventListener(MediaEvent.LOAD_PROGRESS,_mediaLoadProgress);
				_media.removeEventListener(MediaEvent.PLAY_PROGRESS,_mediaPlayProgress);
				_media.removeEventListener(MediaEvent.STATE_CHANGE,_mediaStateChange);
				_media.removeEventListener(MediaEvent.VOLUME_CHANGE,_mediaVolumeChange);
			}
			
			_media = p_media;
			
			_media.addEventListener(MediaEvent.LOAD_PROGRESS,_mediaLoadProgress,false,0,true);
			_media.addEventListener(MediaEvent.PLAY_PROGRESS,_mediaPlayProgress,false,0,true);
			_media.addEventListener(MediaEvent.STATE_CHANGE,_mediaStateChange,false,0,true);
			_media.addEventListener(MediaEvent.VOLUME_CHANGE,_mediaVolumeChange,false,0,true);
			
			if ( _media.getState() == MediaState.PLAYING )
			{
				_playPauseButton.showAltIcon(true);
			}
			else
			{
				_playPauseButton.showAltIcon(false);
			}
			
			if ( _media.getMuted() )
			{
				_muteButton.showAltIcon(true);
			}
			else
			{
				_muteButton.showAltIcon(false);
			}
			
			_loadProgress.snapToProgress(_media.getLoadProgress());
			
			_playProgress.snapToProgress(_media.getPosition());
		}
				
		/**
		 * Enable or disable interactiviy.
		 */
		public function setEnabled(p_value:Boolean):void
		{
			if ( _isEnabled == p_value )
			{
				return;
			}
			
			_isEnabled = p_value;
			
			_controlsHolder.setShowing(p_value);
			
			_controlsHolder.mouseChildren = _isEnabled;
			_controlsHolder.mouseEnabled = _isEnabled;
		}
		
		/**
		 * Specify the alpha value that the controls should assume whilst they
		 * are in a non-iteractive disabled state.
		 */	
		public function setDisabledAlpha(p_value:Number):void
		{
			_disabledAlpha = p_value;
			
			_controlsHolder.setHideAlpha(_disabledAlpha);
		}
				
		private function _seekButtonClick(p_event:ButtonEvent):void
		{
			_media.setPosition(_playProgress.mouseX/_playProgress.width);
		}
		
		private function _playPauseButtonClick(p_event:ButtonEvent):void
		{			
			if ( _media )
			{
				if ( _media.getState() == MediaState.PLAYING )
				{
					_media.pause();
				}
				else
				{
					_media.play();
				}
			}
		}
		
		private function _rewindButtonClick(p_event:ButtonEvent):void
		{
			if ( _media )
			{
				_media.setPosition(0);
			}
		}
		
		private function _muteButtonClick(p_event:ButtonEvent):void
		{
			if ( _media )
			{
				_media.setMuted(!_media.getMuted());
			}
		}
		
		private function _mediaStateChange(p_event:MediaEvent):void
		{
			if ( p_event.state == MediaState.PLAYING )
			{
				_playPauseButton.showAltIcon(true);
			}
			else
			{
				_playPauseButton.showAltIcon(false);
			}
		}
		
		private function _mediaVolumeChange(p_event:MediaEvent):void
		{
			if ( _media.getMuted() )
			{
				_muteButton.showAltIcon(true);
			}
			else
			{
				_muteButton.showAltIcon(false);
			}
		}
		
		private function _mediaPlayProgress(p_event:MediaEvent):void
		{
			_playProgress.setProgress(p_event.playProgress);
		}
		
		private function _mediaLoadProgress(p_event:MediaEvent):void
		{
			_loadProgress.setProgress(p_event.loadProgress);
			
			_seekButton.scaleX = p_event.loadProgress;
		}
	}
}