/*
 * Seisaku-Lib AS3
 *
 * Project home: https://github.com/jedrichards/seisakulib
 * Website: http://www.seisaku.co.uk
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