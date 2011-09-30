package seisaku.lib.display.text
{
	import com.greensock.easing.EaseLookup;
	
	import seisaku.lib.display.HideableSprite;
	import seisaku.lib.util.StringUtils;
	
	public class MultiParagraphText extends HideableSprite
	{
		private var _text:String;
		private var _spacing:uint;
		private var _style:TextStyle;
		
		public function MultiParagraphText(p_text:String,p_spacing:uint,p_style:TextStyle,p_startHidden:Boolean=false)
		{
			_text = p_text;
			_spacing = p_spacing;
			_style = p_style;
			
			super(p_startHidden);
		}
		
		override protected function _createChildren():void
		{
			super._createChildren();
			
			var paragraphs:Array = _text.split("</p><p>");
			
			for ( var i:uint=0; i<paragraphs.length; i++ )
			{
				var paragraphText:String = paragraphs[i] as String;
				
				paragraphText = StringUtils.findReplace(paragraphText,"<p>","");
				paragraphText = StringUtils.findReplace(paragraphText,"</p>","");
				
				var paragraph:Text = new Text(paragraphText,_style);
				paragraph.y = _holder.height == 0 ? 0 : Math.round(_holder.height) + _spacing;
				addChildToHolder(paragraph);
			}
		}
	}
}