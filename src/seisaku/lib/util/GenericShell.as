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
	
	/**
	 * Main document class shell, loads in a sub module SWF that contains the main application
	 * functionality.
	 */
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
			_preloaderView = new ProgressBar(200,2,0x000000,0xcccccc,1,1);
			addChild(_preloaderView);
			
			DisplayObjectUtils.centerInStage(_preloaderView,stage,true);
		}
		
		protected function _updatePreloaderViewProgress(p_progress:Number):void
		{
			if ( _preloaderView )
			{
				ProgressBar(_preloaderView).setProgress(p_progress);
			}
		}
		
		protected function _loadSubModule():void
		{
			var subModuleSWFPath:String = _defaultSubModuleSWFPath;
			
			if ( FlashVars.valueExists(_subModuleSWFPathFlashVarName) )
			{
				Debug.log("genericShell: sub module SWF path flashvar found");
				
				subModuleSWFPath = FlashVars.getValue(_subModuleSWFPathFlashVarName);
			}
			else
			{
				Debug.log("genericShell: sub module SWF path flashvar not found");
			}
			
			Debug.log("genericShell: loading sub module SWF from path \""+subModuleSWFPath+"\"");
			
			_loader.load(new URLRequest(subModuleSWFPath));
		}
		
		protected function _loaderProgress(p_e:ProgressEvent):void
		{
			_updatePreloaderViewProgress(p_e.bytesLoaded/p_e.bytesTotal);
		}
		
		protected function _loaderComplete(p_e:Event):void
		{
			Debug.log("genericShell: sub module SWF load complete");
			
			_updatePreloaderViewProgress(1);
		}
		
		protected function _addLoadedContentToStage():void
		{
			addChild(_loader.content);
		}
		
		protected function _loaderIOError(p_e:IOErrorEvent):void
		{
			Debug.log("genericShell: error loading sub module SWF",Debug.L3_CRITICAL);
		}
	}
}