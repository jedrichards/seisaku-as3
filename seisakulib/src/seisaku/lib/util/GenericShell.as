package seisaku.lib.util
{
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.display.ui.ProgressBar;
	import seisaku.lib.events.HideableSpriteEvent;
	
	public class GenericShell extends Sprite
	{
		protected var _preloaderView:HideableSprite;
		protected var _loader:Loader;
		protected var _subModuleSWFPathFlashVarName:String;
		protected var _defaultSubModuleSWFPath:String;
		
		public function GenericShell()
		{
			GenericSetup.init(this);
		}
		
		protected function _init(p_defaultSubModuleSWFPath:String,p_subModuleSWFPathFlashVarName:String):void
		{
			_defaultSubModuleSWFPath = p_defaultSubModuleSWFPath;
			_subModuleSWFPathFlashVarName = p_subModuleSWFPathFlashVarName;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,_loaderIOError);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,_loaderComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,_loaderProgress);
			
			_createPreloaderView();
		}
		
		protected function _createPreloaderView():void
		{
			_preloaderView = new ProgressBar(200,2,0x000000,0xcccccc,1,1,true);
			addChild(_preloaderView);
			
			DisplayObjectUtils.centerInStage(_preloaderView,stage,true);
		}
		
		protected function _updatePreloaderViewProgress(p_progress:Number):void
		{
			ProgressBar(_preloaderView).setProgress(p_progress);
		}
		
		protected function _loadSubModule():void
		{
			var subModuleSWFPath:String = _defaultSubModuleSWFPath;
			
			if ( FlashVars.valueExists(_subModuleSWFPathFlashVarName) )
			{
				Debug.log("GenericShell: sub module SWF path flashvar found");
				
				subModuleSWFPath = FlashVars.getValue(_subModuleSWFPathFlashVarName);
			}
			else
			{
				Debug.log("GenericShell: sub module SWF path flashvar not found");
			}
			
			Debug.log("GenericShell: loading sub module SWF from path \""+subModuleSWFPath+"\"");
			
			_loader.load(new URLRequest(subModuleSWFPath));
		}
		
		protected function _loaderProgress(p_e:ProgressEvent):void
		{
			_updatePreloaderViewProgress(p_e.bytesLoaded/p_e.bytesTotal);
		}
		
		protected function _loaderComplete(p_e:Event):void
		{
			Debug.log("GenericShell: sub module SWF load complete");
			
			_updatePreloaderViewProgress(1);
		}
		
		protected function _addLoadedContentToStage():void
		{
			addChild(_loader.content);
		}
		
		protected function _loaderIOError(p_e:IOErrorEvent):void
		{
			Debug.log("GenericShell: error loading sub module SWF",Debug.L3_CRITICAL);
		}
	}
}