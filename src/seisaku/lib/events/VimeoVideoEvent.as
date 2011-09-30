package seisaku.lib.events
{
	import flash.events.Event;

	public class VimeoVideoEvent extends Event
	{
		public static const PLAYER_READY:String = "playerReady";
		public static const PLAYER_LOAD_ERROR:String = "playerLoadError";
		
		public static const VIDEO_SELECTED:String = "videoSelected";
		public static const VIDEO_LOAD_STARTED:String = "videoLoadStarted";
		public static const VIDEO_LOAD_PROGRESS:String = "videoLoadProgress";
		public static const VIDEO_LOAD_COMPLETE:String = "videoLoadComplete";
		
		public function VimeoVideoEvent(p_type:String,p_bubbles:Boolean=false,p_cancelable:Boolean=false)
		{
			super(p_type,p_bubbles,p_cancelable);
		}

		override public function clone():Event
		{
			var e:VimeoVideoEvent = new VimeoVideoEvent(type,bubbles,cancelable);
			
			return e;
		}
	}
}
