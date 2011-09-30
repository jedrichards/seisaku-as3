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
 
package seisaku.lib.util {
	
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A set of static methods for working with objects.
	 */
	public class ObjectUtils
	{	
		/**
		 * Duplicate a generic object.
		 * 
		 * @param p_o Generic object to copy.
		 * 
		 * @return A duplicate instance of the original object, not a reference.
		 */
		public static function copy(p_o:Object):Object
		{	
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(p_o);
			buffer.position = 0;
			
			return buffer.readObject() as Object;
		}
		
		/**
		 * Duplicate an instance and retain type. Note that the returned object
		 * should be cast back into the relevant type.
		 * 
		 * @param p_o Typed object to copy.
		 * @param p_class Class reference.
		 * 
		 * @return A duplicate instance of the original object, not a reference.
		 */
		public static function copyTyped(p_o:*,p_class:Class):*
		{	
			registerClassAlias(getClassPath(p_o),p_class);
			
			return copy(p_o) as p_class;
		}
		
		/**
		 * Create an instance of an arbitrary class as identified by its classname.
		 * 
		 * @param p_className Class name as a string.
		 */
		public static function createClassByClassName(p_className:String):*
		{			
			var c:Class = Class(getDefinitionByName(p_className));
			
			return new c();
		}
		
		/**
		 * Returns a formatted string containing a representation of
		 * the contents of an object. Any nested generic objects are
		 * recursively introspected.
		 * 
		 * @param p_o Object to introspect.
		 * @param p_initTabs Initial amount of tabs to indent results.
		 * 
		 * @return A formatted string representing object's contents.
		 */
		public static function introspect(p_o:Object,p_initTabs:String=""):String
		{	
			var temp:String = p_initTabs+"["+getClassName(p_o)+"]\n";
			
			var recurse:Function;
			
			recurse = function(p_item:*,p_tabs:String):void
			{	
				for (var i:String in p_item)
				{
					var className:String = getClassName(p_item[i]);
					if ( className == "Object" )
					{ 
						temp += p_tabs+"["+className+"] "+i+"\n";
						
						recurse(p_item[i],p_tabs+"  ");
					}
					else
					{
						temp += p_tabs+"["+className+"] "+i+" : "+p_item[i]+"\n";
					}
				}
			}
			
			recurse(p_o,p_initTabs+"  ");
				
			if ( temp.lastIndexOf("\n") == temp.length-1 )
			{
				temp = temp.slice(0,temp.length-1);
			}
			
			return temp;
		}
		
		/**
		 * Return the unqualified class name of an instance, i.e. the class name only,
		 * without the package path.
		 * 
		 * @param p_o Arbitrary instance.
		 */
		public static function getClassName(p_o:*):String
		{	
			var a:Array = getQualifiedClassName(p_o).split("::");
			
			return a[a.length-1] as String;
		}
		
		/**
		 * Return the package path of an instance, or an empty string if the object
		 * has no package path.
		 * 
		 * @param p_o Arbitrary instance.
		 */
		public static function getPackagePath(p_o:*):String
		{	
			var a:Array = getQualifiedClassName(p_o).split("::");
			
			return ( a.length > 1 ) ? a[0] : "";
		}
		
		/**
		 * Return the full class path (package path and class name) of an instance.
		 * 
		 * @param p_o Arbitrary instance.
		 */
		public static function getClassPath(p_o:*):String
		{	
			var sPackagePath:String = getPackagePath(p_o);
			
			var sClassPath:String = ( sPackagePath == "" ) ? getClassName(p_o) : sPackagePath+"."+getClassName(p_o);
			
			return sClassPath;
		}
		
		/**
		 * Enumerates the number of publically accessible properties contained within an object.
		 * 
		 * @param p_o Object to inspect.
		 */
		public static function numProps(p_o:*):uint
		{	
			var count:uint = 0;
			
			for ( var i:String in p_o )
			{
				count++;
			}
			
			return count;
		}
	}
}