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
 
package seisaku.lib.puremvc
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import seisaku.lib.util.ObjectUtils;
	
	/**
	 * Simple PureMVC proxy class to any flashvar data passed into a SWF. Supply the root
	 * LoaderInfo's params object as the data source of the proxy.
	 */
	public class FlashVarsProxy extends Proxy implements IProxy
	{
		public function FlashVarsProxy(p_proxyName:String,p_params:Object)
		{
			super(p_proxyName,p_params);
		}
		
		public function valueExists(p_name:String):Boolean
		{
			return ( getStringValue(p_name) == null ) ? false : true; 
		}
		
		public function getStringValue(p_name:String):String
		{	
			return data[p_name];
		}
		
		public function getNumberValue(p_name:String):Number
		{
			return Number(data[p_name]);
		}
		
		public function hasContents():Boolean
		{
			return ObjectUtils.numProps(data) > 0 ? true : false;
		}
	}
}