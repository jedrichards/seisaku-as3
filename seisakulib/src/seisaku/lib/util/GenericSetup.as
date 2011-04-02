package seisaku.lib.util
{
	import com.greensock.OverwriteManager;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.ScalePlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	/**
	 * Static class containing a single static method which initialises common Seisaku-Lib utilities
	 * and performs tasks often required at the start of a FLA based AS3 project.
	 */
	public class GenericSetup
	{	
		/**
		 * Execute generic setup tasks.
		 * 
		 * @param p_root Reference to the root DisplayObjectContainer.
		 */
		public static function init(p_root:DisplayObjectContainer,p_stageAlign:String="TL"):void
		{
			p_root.stage.quality = StageQuality.BEST;
			p_root.stage.showDefaultContextMenu = false;
			p_root.stage.scaleMode = StageScaleMode.NO_SCALE;
			p_root.stage.align = p_stageAlign;
			p_root.stage.stageFocusRect = false;
			
			FlashVars.init(p_root.loaderInfo);
			Debug.init(true,true);
			LibraryUtils.init(p_root.loaderInfo.applicationDomain);
			
			TweenPlugin.activate([AutoAlphaPlugin,TintPlugin,ScalePlugin]);
			OverwriteManager.init(OverwriteManager.AUTO);
		}
	}
}