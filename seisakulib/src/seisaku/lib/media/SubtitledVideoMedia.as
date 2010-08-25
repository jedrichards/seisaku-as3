package seisaku.lib.media
{
	import seisaku.lib.events.MediaEvent;
	import seisaku.lib.util.MathUtils;
	
	public class SubtitledVideoMedia extends VideoMedia
	{
		protected var _subtitles:Array;
		protected var _currentSubtitle:Number;
		
		public function SubtitledVideoMedia(p_isVerbose:Boolean=false,p_startHidden:Boolean=false)
		{
			_subtitles = new Array();
			_currentSubtitle = -1;
			
			super(p_isVerbose,p_startHidden);
		}
		
		public function addSubtitleRange(p_start:Number,p_end:Number):void
		{
			_subtitles.push([p_start,p_end]);
		}
		
		override protected function _auditPosition():void
		{
			super._auditPosition();
			
			//var newSubtitle:Number = -1;
			
			for ( var i:Number=0; i<_subtitles.length; i++ )
			{
				var inRange:Boolean = MathUtils.inRange(_positionSecs,_getSubtitleStartByIndex(i),_getSubtitleEndByIndex(i));
				
				if ( inRange && _currentSubtitle == i )
				{
					break;
				}
				
				if ( _currentSubtitle != i && inRange )
				{
					_currentSubtitle = i;
					
					var enterEvent:MediaEvent = new MediaEvent(MediaEvent.ENTER_SUBTITLE);
					enterEvent.subtitleIndex = _currentSubtitle;
					dispatchEvent(enterEvent);
				}
				
				if ( _currentSubtitle == i && !inRange )
				{
					var exitEvent:MediaEvent = new MediaEvent(MediaEvent.EXIT_SUBTITLE);
					exitEvent.subtitleIndex = i;
					dispatchEvent(exitEvent);
					
					_currentSubtitle = -1;
				}
			}
		}
		
		private function _getSubtitleStartByIndex(p_index:Number):Number
		{
			return _subtitles[p_index][0] as Number;
		}
		
		private function _getSubtitleEndByIndex(p_index:Number):Number
		{
			return _subtitles[p_index][1] as Number;
		}
	}
}