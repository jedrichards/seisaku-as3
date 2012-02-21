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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.VimeoVideoEvent;
	import seisaku.lib.time.IThread;
	import seisaku.lib.time.Thread;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.StringUtils;
	
	/**
	 * Wrapper for the Vimeo AS3 Moogaloop video player. Based on the VimeoPlayer 
	 * demonstrated at https://github.com/vimeo/player-api/tree/master/actionscript.
	 */
	public class VimeoVideo extends HideableSprite implements IThread
	{
		private var _init:Boolean;
		private var _playerLoaded:Boolean;
		
		private var _container:Sprite;
		private var _moogaloop:Object;
		private var _mask:Shape;
		
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _loadTimer:Timer;
		private var _loader:Loader;
		
		private var _oAuthKey:String;
		private var _fpVersion:int;
		
		private var _thread:Thread;
		
		private var _currentVideoLoaded:Boolean;
		private var _currentVideoLoadStarted:Boolean;
		
		public function VimeoVideo(p_oAuthKey:String,p_width:int=400,p_height:int=300,p_fpVersion:int=10,p_startHidden:Boolean=false)
		{
			if ( !_init )
			{
				_init = true;
				
				Security.allowDomain("*");
				Security.loadPolicyFile("http://vimeo.com/moogaloop/crossdomain.xml");
			}

			_oAuthKey = p_oAuthKey;
			_videoWidth = p_width;
			_videoHeight = p_height;
			_fpVersion = p_fpVersion;
			
			_thread = new Thread(this);
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_mask = new Shape();
			addChildToHolder(_mask);
			
			_redrawMask();
			
			_container = new Sprite();
			_container.mask = _mask;
			addChildToHolder(_container);
		}
		
		public function loadPlayer(p_clipID:int=19209879,p_title:uint=0,p_byline:uint=0,p_portrait:uint=0,p_colour:String="4ebaff",p_hdOff:uint=0):void
		{
			if ( _playerLoaded )
			{
				return;
			}
			
			_resetVars();
			
			_playerLoaded = true;
			
			var uri:String = "http://api.vimeo.com/moogaloop_api.swf";
			
			uri = StringUtils.appendToQueryString(uri,"oauth_key",_oAuthKey);
			uri = StringUtils.appendToQueryString(uri,"clip_id",p_clipID);
			uri = StringUtils.appendToQueryString(uri,"width",_videoWidth);
			uri = StringUtils.appendToQueryString(uri,"height",_videoHeight);
			uri = StringUtils.appendToQueryString(uri,"fp_version",_fpVersion);
			uri = StringUtils.appendToQueryString(uri,"fullscreen","0");
			uri = StringUtils.appendToQueryString(uri,"title",p_title);
			uri = StringUtils.appendToQueryString(uri,"byline",p_byline);
			uri = StringUtils.appendToQueryString(uri,"portrait",p_portrait);
			uri = StringUtils.appendToQueryString(uri,"color",p_colour);
			uri = StringUtils.appendToQueryString(uri,"hd_off",p_hdOff);

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_loaderComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,_loaderIOError);
			_loader.load(new URLRequest(uri));
		}
		
		private function _loaderIOError(p_event:IOErrorEvent):void
		{
			Debug.log("vimeoVideo: Error loading Moogaloop API SWF. "+p_event.text,Debug.L2_WARNING);
			
			dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.PLAYER_LOAD_ERROR));
		}
		
		private function _loaderComplete(p_e:Event):void
		{
			Debug.log("vimeoVideo: Moogaloop API SWF loaded, waiting for it to init ...");
			
			_container.addChild(_loader.content);
			
			_moogaloop = _loader.content;
			
			_loadTimer = new Timer(200);
			_loadTimer.addEventListener(TimerEvent.TIMER,_playerLoadedCheck);
			_loadTimer.start();
		}
		
		private function _playerLoadedCheck(p_event:TimerEvent):void
		{
			if ( _moogaloop.player_loaded )
			{
				_loadTimer.stop();
				_loadTimer.removeEventListener(TimerEvent.TIMER, _playerLoadedCheck);
				
				_moogaloop.disableMouseMove();
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
				dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.PLAYER_READY));
				
				dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.VIDEO_SELECTED));
				
				_thread.start();
			}
		}
		
		public function run():void
		{
			var bytesLoaded:Number = _moogaloop.api_getBytesLoaded();
			var bytesTotal:Number = _moogaloop.api_getBytesTotal();
			
			//trace(bytesLoaded+" / "+bytesTotal);
			
			if ( bytesLoaded > 0 )
			{
				if ( !_currentVideoLoadStarted )
				{
					_currentVideoLoadStarted = true;
					
					dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.VIDEO_LOAD_STARTED));
				}
				
				if ( bytesLoaded < bytesTotal )
				{
					dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.VIDEO_LOAD_PROGRESS));
				}
				
				if ( !_currentVideoLoaded && bytesLoaded == bytesTotal )
				{
					_currentVideoLoaded = true;
					
					dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.VIDEO_LOAD_COMPLETE));
				}
			}
		}
		
		private function _resetVars():void
		{
			_currentVideoLoaded = false;
			_currentVideoLoadStarted = false;
		}
		
		private function setDimensions(w:int,h:int):void
		{
			_videoWidth  = w;
			_videoHeight = h;
		}

		private function mouseMove(e:MouseEvent):void {
			
			var pos:Point = this.parent.localToGlobal(new Point(this.x, this.y));
			
			if ( e.stageX >= pos.x && e.stageX <= pos.x + this._videoWidth && e.stageY >= pos.y && e.stageY <= pos.y + this._videoHeight )
			{
				_moogaloop.mouseMove(e);
			}
			else {
				_moogaloop.mouseOut();
			}
		}
		
		private function _redrawMask():void
		{	
			_mask.graphics.beginFill(0x000000,1);
			_mask.graphics.drawRect(0,0,_videoWidth,_videoHeight);
			_mask.graphics.endFill();
		}
		
		public function play():void
		{
			_moogaloop.api_play();
		}
		
		public function pause():void
		{
			_moogaloop.api_pause();
		}
		
		public function getDuration():int
		{
			return _moogaloop.api_getDuration();
		}
		
		public function seekTo(time:int):void
		{
			_moogaloop.api_seekTo(time);
		}
		
		public function changeColor(p_hex:String):void
		{
			_moogaloop.api_changeColor(p_hex);
		}
		
		public function getVideoLoadProgress():Number
		{
			return _moogaloop.api_getBytesLoaded() / _moogaloop.api_getBytesTotal();
		}
		
		public function loadVideo(id:int):void
		{
			_resetVars();
			
			dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.VIDEO_SELECTED));
			
			_moogaloop.api_loadVideo(id);
		}
		
		public function unloadVideo():void
		{
			_moogaloop.api_unload();
		}
		
		public function resize(p_videoWidth:int,p_videoHeight:int):void
		{
			_videoWidth = p_videoWidth;
			_videoHeight = p_videoHeight;
			
			_moogaloop.api_setSize(p_videoWidth,p_videoHeight);
			
			_redrawMask();
		}
	}
}