package seisaku.lib.media
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.describeType;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.events.VimeoVideoEvent;
	import seisaku.lib.util.Debug;
	import seisaku.lib.util.MathUtils;
	import seisaku.lib.util.StringUtils;
	
	public class VimeoVideo extends HideableSprite
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
			_loader.load(new URLRequest(uri));
		}
		
		private function _loaderComplete(e:Event):void
		{
			_container.addChild(e.target.loader.content);
			
			_moogaloop = e.target.loader.content;
			
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
				
				dispatchEvent(new VimeoVideoEvent(VimeoVideoEvent.PLAYER_LOADED));
			}
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
		
		public function loadVideo(id:int):void
		{
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