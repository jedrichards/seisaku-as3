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
 
package seisaku.lib.net
{	
	/**
	 * Full list of constants referencing net status event code strings.
	 */
	public class NetStatusEventCode
	{	
		public static const NETSTREAM_BUFFER_EMPTY:String = "NetStream.Buffer.Empty";
		public static const NETSTREAM_BUFFER_FULL:String = "NetStream.Buffer.Full";
		public static const NETSTREAM_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";
		public static const NETSTREAM_FAILED:String = "NetStream.Failed";
		public static const NETSTREAM_PUBLISH_START:String = "NetStream.Publish.Start";
		public static const NETSTREAM_PUBLISH_BADNAME:String = "NetStream.Publish.BadName";
		public static const NETSTREAM_PUBLISH_IDLE:String = "NetStream.Publish.Idle";
		public static const NETSTREAM_UNPUBLISH_SUCCESS:String = "NetStream.Unpublish.Success";
		public static const NETSTREAM_PLAY_START:String = "NetStream.Play.Start";
		public static const NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";
		public static const NETSTREAM_PLAY_FAILED:String = "NetStream.Play.Failed";
		public static const NETSTREAM_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";
		public static const NETSTREAM_PLAY_RESET:String = "NetStream.Play.Reset";
		public static const NETSTREAM_PLAY_PUBLISHNOTIFY:String = "NetStream.Play.PublishNotify";
		public static const NETSTREAM_PLAY_UNPUBLISHNOTIFY:String = "NetStream.Play.UnpublishNotify";
		public static const NETSTREAM_PLAY_INSUFFICIENTBW:String = "NetStream.Play.InsufficientBW";
		public static const NETSTREAM_PLAY_FILESTRUCTUREINVALID:String = "NetStream.Play.FileStructureInvalid";
		public static const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "NetStream.Play.NoSupportedTrackFound";
		public static const NETSTREAM_PAUSE_NOTIFY:String = "NetStream.Pause.Notify";
		public static const NETSTREAM_UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";
		public static const NETSTREAM_RECORD_START:String = "NetStream.Record.Start";
		public static const NETSTREAM_RECORD_NOACCESS:String = "NetStream.Record.NoAccess";
		public static const NETSTREAM_RECORD_STOP:String = "NetStream.Record.Stop";
		public static const NETSTREAM_RECORD_FAILED:String = "NetStream.Record.Failed";
		public static const NETSTREAM_SEEK_FAILED:String = "NetStream.Seek.Failed";
		public static const NETSTREAM_SEEK_INVALIDTIME:String = "NetStream.Seek.InvalidTime";
		public static const NETSTREAM_SEEK_NOTIFY:String = "NetStream.Seek.Notify";
		public static const NETCONNECTION_CALL_BADVERSION:String = "NetConnection.Call.BadVersion";
		public static const NETCONNECTION_CALL_FAILED:String = "NetConnection.Call.Failed";
		public static const NETCONNECTION_CALL_PROHIBITED:String = "NetConnection.Call.Prohibited";
		public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const NETCONNECTION_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";
		public static const NETCONNECTION_CONNECT_APPSHUTDOWN:String = "NetConnection.Connect.AppShutdown";
		public static const NETCONNECTION_CONNECT_INVALIDAPP:String = "NetConnection.Connect.InvalidApp";
		public static const SHAREDOBJECT_FLUSH_SUCCESS:String = "SharedObject.Flush.Success";
		public static const SHAREDOBJECT_FLUSH_FAILED:String = "SharedObject.Flush.Failed";
		public static const SHAREDOBJECT_BADPERSISTENCE:String = "SharedObject.BadPersistence";
		public static const SHAREDOBJECT_URIMISMATCH:String = "SharedObject.UriMismatch";
	}
}