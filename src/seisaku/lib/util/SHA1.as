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
	/**
	 * AS3 implementation of the Secure Hash Algorithm, SHA-1. SHA-1 produces a 160bit
	 * digest from a message with a maximum length of (2^64−1)bits.
	 */
	public class SHA1
	{
		/**
		 * Return a 160bit digest from a source message.
		 * 
		 * @param p_src Source message string, maximum length (2^64−1)bits
		 */
		public static function hexSHA1(p_src:String):String
		{
			return binb2hex(_coreSHA1(_str2binb(p_src),p_src.length*8));
		}
		
		private static function _coreSHA1(p_a:Array,p_len:Number):Array
		{
			p_a[p_len >> 5] |= 0x80 << (24-p_len%32);
			p_a[((p_len+64 >> 9) << 4)+15] = p_len;
			
			var w:Array = new Array(80), a:Number = 1732584193;
			var b:Number = -271733879, c:Number = -1732584194;
			var d:Number = 271733878, e:Number = -1009589776;
			
			for (var i:Number = 0; i<p_a.length; i += 16)
			{
				var olda:Number = a, oldb:Number = b;
				var oldc:Number = c, oldd:Number = d, olde:Number = e;
				
				for (var j:Number = 0; j<80; j++)
				{
					if (j<16) {
						w[j] = p_a[i+j];
					}
					else
					{
						w[j] = _rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
					}
					
					var t:Number = _safeAdd(_safeAdd(_rol(a,5),_sha1ft(j,b,c,d)),_safeAdd(_safeAdd(e,w[j]),_sha1kt(j)));
					
					e = d;
					d = c;
					c = _rol(b,30);
					b = a;
					a = t;
				}
				
				a = _safeAdd(a,olda);
				b = _safeAdd(b,oldb);
				c = _safeAdd(c,oldc);
				d = _safeAdd(d,oldd);
				e = _safeAdd(e,olde);
			}
			
			return new Array(a,b,c,d,e);
		}
	
		private static function _sha1ft(p_t:Number,p_b:Number,p_c:Number,p_d:Number):Number
		{
			if (p_t<20)
			{
				return (p_b & p_c) | ((~p_b) & p_d);
			}
			
			if (p_t<40)
			{
				return p_b ^ p_c ^ p_d;
			}
			 
			if (p_t<60)
			{
				return (p_b & p_c) | (p_b & p_d) | (p_c & p_d);	
			}
			
			return p_b ^ p_c ^ p_d;
		}
	
		private static function _sha1kt(p_t:Number):Number
		{
			return (p_t<20) ? 1518500249 : (p_t<40) ? 1859775393 : (p_t<60) ? -1894007588 : -899497514;
		}
	
		private static function _safeAdd(p_x:Number,p_y:Number):Number
		{
			var lsw:Number = (p_x & 0xFFFF)+(p_y & 0xFFFF);
			var msw:Number = (p_x >> 16)+(p_y >> 16)+(lsw >> 16);
			
			return (msw << 16) | (lsw & 0xFFFF);
		}
	
		private static function _rol(p_num:Number,p_cnt:Number):Number
		{
			return (p_num << p_cnt) | (p_num >>> (32-p_cnt));
		}
	
		private static function _str2binb(p_str:String):Array
		{
			var bin:Array = new Array();
			
			var mask:Number = (1 << 8)-1;
			
			for (var i:Number = 0; i<p_str.length*8; i += 8)
			{
				bin[i >> 5] |= (p_str.charCodeAt(i/8) & mask) << (24-i%32);
			}
			
			return bin;
		}
	
		private static function binb2hex(p_binarray:Array):String
		{
			var str:String = new String("");
			
			var tab:String = new String("0123456789abcdef");
			
			for (var i:Number = 0; i<p_binarray.length*4; i++)
			{
				str += tab.charAt((p_binarray[i >> 2] >> ((3-i%4)*8+4)) & 0xF) + tab.charAt((p_binarray[i >> 2] >> ((3-i%4)*8)) & 0xF);
			}
			
			return str;
		}	
	}
}