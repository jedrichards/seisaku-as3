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
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * A set of static methods for working with XML objects.
	 */
	public class XMLUtils
	{
		/**
		 * Return an XML node by its unique ID attribute value.
		 * 
		 * @param p_xml XML instance to search
		 * @param p_id ID attribute value
		 */
		public static function getNodeByID(p_xml:XML,p_id:String):XML
		{
			var list:XMLList = p_xml..*.(attribute("id")==p_id);
			
			if ( list.length() == 0 )
			{
				Debug.log("XMLUtils warning: node with id \""+p_id+"\" not found",Debug.L2_WARNING);
			}
			
			if ( list.length() > 1 )
			{
				Debug.log("XMLUtils warning: node id \""+p_id+"\" is not unique",Debug.L2_WARNING);
			}
			
			return list[0] as XML;
		}
		
		/**
		 * Find an XML node by its unique ID attribute value and return its contents as a string.
		 * 
		 * @param p_xml XML instance to search
		 * @param p_id ID attribute value
		 * @param p_default Default value to return if node to found
		 */
		public static function getStringByNodeID(p_xml:XML,p_id:String,p_default:String=""):String
		{			
			var result:String = p_default;
			
			var xml:XML = getNodeByID(p_xml,p_id);
			
			if ( xml )
			{
				result = xml.toString();
			}

			return result;
		}
		
		public static function getColourByNodeID(p_xml:XML,p_id:String):uint
		{
			return uint("0x"+getStringByNodeID(p_xml,p_id));
		}
		
		/**
		 * Find an XML node by its unique ID attribute value and return its contents as a number.
		 * 
		 * @param p_xml XML instance to search
		 * @param p_id ID attribute value
		 * @param p_default Default value to return if node to found
		 */
		public static function getNumberByNodeID(p_xml:XML,p_id:String,p_default:Number=0):Number
		{
			return Number(getStringByNodeID(p_xml,p_id,String(p_default)));
		}
		
		public static function nodeToString(p_xml:*):String
		{
			var s:String = p_xml.toString();
			
			return p_xml.toString();
		}
		
		public static function nodeToNumber(p_xml:*):Number
		{
			return parseFloat(p_xml.toString());
		}
		
		public static function nodeToColour(p_xml:*):uint
		{
			return MathUtils.stringToHex(p_xml.toString());
		}
		
		public static function nodeToInteger(p_xml:*):int
		{
			return parseInt(p_xml.toString());
		}
		
		public static function nodeToBoolean(p_xml:*):Boolean
		{
			var s:String = XMLUtils.nodeToString(p_xml);
			
			return s == "true" || s == "1" ? true : false;
		}
		
		public static function nodeToPoint(p_xml:*):Point
		{
			var temp:Array = p_xml.toString().split(",");
			
			if ( temp.length == 2 && ArrayUtils.isNumeric(temp) )
			{
				return new Point(temp[0],temp[1]);
			}
			else
			{
				return new Point(0,0);
			}
		}
		
		public static function nodeToRect(p_xml:*):Rectangle
		{
			var temp:Array = p_xml.toString().split(",");
			
			if ( temp.length == 4 && ArrayUtils.isNumeric(temp) )
			{
				return new Rectangle(temp[0],temp[1],temp[2],temp[3]);
			}
			else
			{
				return new Rectangle(0,0,0,0);
			}
		}
	}
}