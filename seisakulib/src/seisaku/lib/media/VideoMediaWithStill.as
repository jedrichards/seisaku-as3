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
	import seisaku.lib.display.HideableExternalAsset;
	import seisaku.lib.events.HideableExternalAssetEvent;
	import seisaku.lib.events.MediaEvent;
	
	/**
	 * Subclass of VideoMedia that supports displaying an external image as
	 * a placeholder for the video before the video is loaded. This placeholder
	 * can be set to automatically show and hide itself on interaction with the
	 * video media.
	 */
	public class VideoMediaWithStill extends VideoMedia
	{
		private var _still:HideableExternalAsset;
		
		public var autoHideStill:Boolean;
		public var autoShowStill:Boolean;
		
		public function VideoMediaWithStill(p_isVerbose:Boolean=false, p_startHidden:Boolean=false)
		{
			autoHideStill = true;
			autoShowStill = true;
			
			super(p_isVerbose,p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			_still = new HideableExternalAsset("",false,true,false,true);
			_still.addEventListener(HideableExternalAssetEvent.FULLY_LOADED,_stillFullyLoaded);
			addChildToHolder(_still);
		}

		private function _stillFullyLoaded(event:HideableExternalAssetEvent):void
		{
			dispatchEvent(new MediaEvent(MediaEvent.STILL_LOADED));
		}
		
		public function addStill(p_stillPath:String):void
		{
			_still.load(p_stillPath);
		}
		
		override protected function _setState(p_value:String):void
		{
			super._setState(p_value);
			
			if ( _state == MediaState.PLAYING && autoHideStill )
			{
				_still.hide();
			}
			
			if ( _state == MediaState.STOPPED_COMPLETE && autoShowStill )
			{
				_still.show();
			}
		}
		
		public function hideStill():void
		{
			_still.hide();
		}
		
		public function showStill():void
		{
			_still.show();
		}
	}
}