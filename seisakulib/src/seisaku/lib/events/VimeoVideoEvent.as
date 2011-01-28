package seisaku.lib.events
{
	import flash.events.Event;

	public class VimeoVideoEvent extends Event
	{
		public static const PLAYER_LOADED:String = "playerLoaded";
		public static const PLAYER_LOAD_ERROR:String = "playerLoadError";
		
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
