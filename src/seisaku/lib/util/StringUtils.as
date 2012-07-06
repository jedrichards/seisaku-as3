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
	import flash.system.Capabilities;
	
	/**
	 * A set of static methods for working with strings.
	 */
	public class StringUtils
	{
		private static var _guidCouter:Number = 0;
		
		/**
		 * Check for a generally well-formed email address, not fool proof.
		 * 
		 * @param p_value A string representing the email address to check.
		 */
		public static function emailValid(p_value:String):Boolean
		{	
			var numChars:Number = p_value.length;
			var invalidChars:String = " \"\\£()[];:";
			
			if ( numChars < 6 || numChars > 320 )
			{
				return false;
			}
			
			for ( var i:uint=0; i<numChars; i++ )
			{
				if ( contains(invalidChars,p_value.charAt(i)) )
				{
					return false;
				}
			}
			
			if ( contains(p_value,"..") )
			{
				return false;
			}
			
			if ( countOf(p_value,"@") != 1 )
			{
				return false;
			}
			
			if ( contains(p_value,"@.") || contains(p_value,".@") )
			{
				return false;
			}
			
			var atIndex:int = p_value.indexOf("@");
			if ( atIndex < 1 || (atIndex > numChars-5) )
			{
				return false;
			}
			
			var lastStopIndex:int = p_value.lastIndexOf(".");
			if ( atIndex > lastStopIndex )
			{
				return false;
			}
			
			if ( p_value.lastIndexOf(".") > p_value.length-3 )
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Intelligently clip a string down to a certain number of characters.
		 * 
		 * @param p_target String to clip.
		 * @param p_length Length at which to clip.
		 * @param p_trailChars Optional argument specifying any trailing characters, e.g. "...".
		 */
		public static function clip(p_target:String,p_length:Number,p_trailChars:String=""):String
		{
			return ( (p_target.length > p_length) ? p_target.substring(0,p_target.substring(0,p_length).lastIndexOf(" "))+p_trailChars : p_target);
		}
		
		/**
		 * Find and replace within a string.
		 * 
		 * @param p_target Source string to search through.
		 * @param p_term String to find.
		 * @param p_replace Replacement string.
		 */
		public static function findReplace(p_target:String,p_term:String,p_replace:String):String
		{	
			return ( p_term == p_replace ) ? p_target : p_target.split(p_term).join(p_replace);
		}
		
		/**
		 * Return the isolated file extension from a filename.
		 * 
		 * @param p_target String representing the full filename or URL.
		 */
		public static function fileExtension(p_target:String):String
		{	
			return ( p_target.lastIndexOf(".") == -1 ) ? "" : p_target.substring(p_target.lastIndexOf(".")+1,p_target.length).toLowerCase();
		}
		
		/**
		 * Isolate and return the filename from a URL.
		 * 
		 * @param p_target String representing the full URL.
		 */
		public static function fileName(p_target:String):String
		{	
			var temp:Array = p_target.split("/");
			
			var name:String;
			
			if ( temp.length < 2 )
			{
				name = temp[0];
			}
			else
			{
				name = temp[temp.length-1];
			}
			
			if ( name.indexOf(".") == -1 )
			{
				name = "";
			}
			
			return name;
		}
		
		/**
		 * Add escape slashes to a string.
		 * 
		 * @param p_target String to parse.
		 */
		public static function addSlashes(p_target:String):String
		{	
			return p_target.split('"').join('\\"').split("'").join("\\'");
		}
	
		/**
		 * Remove escape slashes from a string.
		 * 
		 * @param p_target String to parse.
		 */
		public static function stripSlashes(p_target:String):String
		{	
			return p_target.split("\\").join("");
		}
		
		/**
		 * Remove XML tags from a string.
		 * 
		 * @param p_target String to parse.
		 */
		public static function stripTags(p_target:String):String
		{
			return p_target.replace(/<\/?[^>]+>/igm,"");
		}
		
		/**
		 * Format a number of seconds into a string representation of minutes and seconds.
		 * 
		 * @param p_seconds Number of seconds.
		 * @param p_zeroPadMins Whether to zero pad the minutes.
		 * @param p_zeroPadSecs Whether to zero pad the seconds.
		 * @param p_divider String used to seperate mins and secs, defaults to ":".
		 */
		public static function formatSeconds(p_seconds:Number,p_zeroPadMins:Boolean=false,p_zeroPadSecs:Boolean=false,p_divider:String=":"):String
		{
			var mins:Number = Math.floor(p_seconds/60);
			var secs:Number = Math.floor(p_seconds-(mins*60));
			
			var minsString:String = (mins < 10 && p_zeroPadMins) ? "0" + String(mins) : String(mins);
			var secsString:String = (secs < 10 && p_zeroPadSecs) ? "0" + String(secs) : String(secs);
			
			return minsString + p_divider + secsString;
		}
		
		/**
		 * Return the host name only from a URI, i.e. "https://www.domain.com/uploadScript.php"
		 * becomes "apps.mydomain.com".
		 * 
		 * @param p_target Long URI.
		 */
		public static function host(p_target:String):String
		{	
			var temp:String = p_target.substr(p_target.indexOf("//",0)==-1?0:p_target.indexOf("//",0)+2,p_target.length);
			
			temp = temp.substr(0,temp.indexOf("/"));
			
			if ( temp.split(".").length <= 1)
			{
				temp = null;
			}
			
			return temp;
		}
		
		/**
		 * Append a random name/value pair to the end of a URI in order to
		 * prevent browser caching of externally loaded assets.
		 * 
		 * @p_target Target URI.
		 */
		public static function appendCacheBuster(p_target:String):String
		{	
			return appendToQueryString(p_target,"noCache",createGUID());
		}
		
		/**
		 * Append an arbitrary name/value to the end of a URI query string.
		 * 
		 * @p_target Target URI.
		 * @p_name Name of the name/value pair.
		 * @p_value Value of the name/value pair.
		 */
		public static function appendToQueryString(p_target:String,p_name:String,p_value:*):String
		{
			var pair:String = p_name+"="+p_value;
			
			if ( contains(p_target,"?") )
			{
				p_target += "&";
			}
			else
			{
				p_target += "?";
			}
			
			return p_target + pair;
		}
		
		/**
		 * Check to see if one string contains another.
		 * 
		 * @param p_target Host string.
		 * @param p_term Target string to search for.
		 */
		public static function contains(p_target:String,p_term:String):Boolean
		{	
			return p_target.indexOf(p_term) != -1;
		}
		
		/**
		 * Count the number of times a string occurs.
		 * 
		 * @param p_target Host string.
		 * @param p_term Target string to search for.
		 */
		public static function countOf(p_target:String,p_term:String,p_caseSensitive:Boolean=true):uint
		{	
			var temp:String = p_term.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g,"\\$1");
			
			var flags:String = (!p_caseSensitive) ? "ig" : "g";
			
			return p_target.match(new RegExp(temp,flags)).length;
		}
		
		/**
		 * Calc the Levenshtein distance (similarity/edit distance) between two strings.
		 * 
		 * @param p_term1 Start string.
		 * @param p_term2 End string.
		 */
		public static function levenshtein(p_term1:String,p_term2:String):uint
		{	
			if (p_term1 == null)
			{ 
				p_term1 = "";
			}
			
			if (p_term2 == null)
			{ 
				p_term2 = ""; 
			}
			
			if (p_term1 == p_term2)
			{
				return 0;
			}
			
			var a:Array = new Array();
			var cost:uint;
			var length1:uint = p_term1.length;
			var length2:uint = p_term2.length;
			var i:uint;
			var j:uint;
			
			if (length1 == 0)
			{ 
				return length2;
			}	
			
			if (length2 == 0)
			{ 
				return length1;
			}
			
			for (i=0; i<=length1; i++)
			{ 
				a[i] = new Array();
			}
			
			for (i=0; i<=length1; i++)
			{ 
				a[i][0] = i;
			}
			
			for (j=0; j<=length2; j++)
			{ 
				a[0][j] = j;
			}
			
			for (i=1; i<=length1; i++)
			{
				var s_i:String = p_term1.charAt(i-1);
				
				for (j=1; j<=length2; j++)
				{
					var t_j:String = p_term2.charAt(j-1);
					if (s_i == t_j)
					{
						cost = 0;
					}
					else
					{
						cost = 1;
					}
					a[i][j] = Math.min(a[i-1][j]+1,Math.min(a[i][j-1]+1,Math.min(a[i-1][j-1]+cost,a[i-1][j]+1)));
				}
			}
			
			return a[length1][length2];
		}
		
		/**
		 * Determine the similarity between two strings using their Levenshtein distance
		 * as a value between 0 and 1.
		 * 
		 * @param p_term1 Start string.
		 * @param p_term2 End string.
		 */
		public static function similarity(p_term1:String,p_term2:String):Number
		{	
			var lev:uint = levenshtein(p_term1,p_term2);
			var maxLength:uint = Math.max(p_term1.length,p_term2.length);
			
			if ( maxLength == 0 )
			{ 
				return 1;
			}
			else
			{ 
				return 1-(lev/maxLength);
			}
		}
		
		/**
		 * Determine the word count of a string.
		 * 
		 * @param p_target Host string.
		 */
		public static function wordCount(p_target:String):uint
		{
			return p_target.match(/\b\w+\b/g).length;
		}
		
		/**
		 * Determine whether the string is able to represent a number.
		 * 
		 * @param p_target String to test.
		 */
		public static function isNumeric(p_target:String):Boolean
		{
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			
			return regx.test(p_target);
		}
		
		/**
		 * Trim whitespaces from the start and end of a string.
		 * 
		 * @param p_target Host string.
		 */
		public static function trimWhitespace(p_target:String):String
		{	
			return p_target.replace(/^\s+|\s+$/g,"");
		}
		
		/**
		 * Remove extra whitespaces throughout the string, i.e. double spaces,
		 * extra line breaks, tabs etc.
		 * 
		 * @param p_target Host string.
		 */
		public static function cleanWhitespace(p_target:String):String
		{	
			var temp:String = trimWhitespace(p_target);
			
			return temp.replace(/\s+/g," ");
		}
		
		/**
		 * Remove whitespace characters (tab, newline, carriage return) from a string.
		 */
		public static function trim(p_target:String):String
		{
			var rex:RegExp = /(\t|\n|\r)/gi;
			p_target = p_target.replace(rex,'');
			return p_target;
		}
		
		/**
		 * Pad the start of the string with extra characters.
		 * 
		 * @param p_target Host string.
		 * @param p_sPadChar The character to use for padding.
		 * @param p_padCount Number of times to pad.
		 */
		public static function padLeft(p_target:String,p_padChar:String,p_padCount:uint):String
		{
			var temp:String = p_target;
			
			while ( temp.length < p_padCount )
			{ 
				temp = p_padChar + temp;
			}
			
			return temp;
		}
		
		/**
		 * Pad the end of the string with extra characters.
		 * 
		 * @param p_target Host string.
		 * @param p_padChar The character to use for padding.
		 * @param p_padCount Number of times to pad.
		 */
		public static function padRight(p_target:String,p_padChar:String,p_padCount:uint):String
		{
			var temp:String = p_target;
			
			while ( temp.length < p_padCount )
			{ 
				temp += p_padChar;
			}
			
			return temp;
		}
		
		/**
		 * Restrict a string to a sequence of valid characters. Use to
		 * strip punctuation, for example.
		 */
		public static function restrictTo(p_target:String,p_validChars:String=""):String
		{
			if ( p_validChars == "" )
			{
				p_validChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			}
			
			var restricted:String = "";
			
			for ( var i:uint=0; i<p_target.length; i++ )
			{
				if ( p_validChars.indexOf(p_target.charAt(i)) > -1 )
				{
					restricted += p_target.charAt(i);
				}
			}
			
			return restricted;
		}
		
		/**
		 * Finds URLs in a string and wraps in <a> tags.
		 * 
		 * @param p_target Target string to add links to.
		 * @param p_window Window target for the link.
		 */
		public static function addHTMLLinks(p_target:String,p_window:String="_blank"):String
		{
			return p_target.replace(/((https?|ftp|telnet|file):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)/g, "<a href='$1' target='"+p_window+"'>$1</a>");
		}
		
		/**
		 * Returns a 128bit GUID in the format XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX.
		 */
		public static function createGUID():String
		{
			var id1:Number = new Date().getTime();
			var id2:Number = Math.random();
			var salt:String = flash.system.Capabilities.serverString+(_guidCouter++);
			
			var sha1:String = SHA1.hexSHA1(id1+id2+salt);
			
			var guid:String = [sha1.substr(0,8),sha1.substr(8,4),sha1.substr(12,4),sha1.substr(16,4),sha1.substr(20,12)].join("-"); 
			
			return guid.toUpperCase();
		}
	}
}