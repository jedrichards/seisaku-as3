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
 
package seisaku.lib.media
{	
	/**
	 * Custom error class for the Media classes.
	 */
	public class MediaError extends Error
	{
		/**
		 * This error message is encountered when you try to load in media on a media instance
		 * that already has an open media stream.
		 */
		public static const MEDIA_OPEN_MSG:String = "There is already an active stream.";
		
		/**
		 * This error message is encountered when you try and execute an operation (play, pause etc.) 
		 * on a media instance that does not have a currently open media stream.
		 */
		public static const MEDIA_CLOSED_MSG:String = "The stream is already closed.";
		
		/**
		 * This error message is encountered when you try and play a media instance that is already in the
		 * playing state.
		 */
		public static const MEDIA_PLAYING:String = "The stream is already playing.";
		
		/**
		 * This error message is encountered when you try and pause a media instance that is already in the
		 * paused state.
		 */
		public static const MEDIA_PAUSED:String = "The stream is already paused.";
		
		public function MediaError(p_message:String="",p_id:int=0)
		{
			super(p_message,p_id);
		}
	}
}