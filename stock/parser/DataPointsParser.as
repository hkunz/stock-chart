package stock.parser
{
	import flash.xml.*;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.display.MovieClip;

	public final class DataPointsParser
	{
		private var _cLoader:URLLoader;
		private var _sFile:String;
		private var _pfLoadComplete:Function;
		
		public function DataPointsParser()
		{
			//trace("DataPointsParser::DataPointsParser");
			_cLoader = new URLLoader();
			_pfLoadComplete = null;
		}
		
		public function setFilePath(sFile:String):void
		{
			//trace("DataPointsParser::setFilePath(" + sFile + ")");
			_sFile = sFile;
		}
		
		public function setLoadComplete(pfCallback:Function):void
		{
			_pfLoadComplete = pfCallback;
		}
		
		public function loadXmlData():void
		{
			//trace("DataPointsParser::loadXmlData");
			var cLoadReq:URLRequest = new URLRequest(_sFile);
			//_cLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			//_cLoader.addEventListener(Event.OPEN, onXmlStreamOpened);
			//_cLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusEvent);
			//_cLoader.addEventListener(ProgressEvent.PROGRESS, onXmlPartialDataReceive);
			//_cLoader.addEventListener(IOErrorEvent.IO_ERROR, onXmlDataLoadError);
			_cLoader.addEventListener(Event.COMPLETE, onXmlDataLoad);
			setDataFormat();
			_cLoader.load(cLoadReq); //Sends and loads data from the specified URL.
			//_cLoader.close(); //Closes the load operation in progress.
		}
		
		private function setDataFormat():void
		{
			//trace("DataPointsParser::setDataFormat");
			//dataFormat : String = "text"
			//Controls whether the downloaded data is received as text (URLLoaderDataFormat.TEXT),
			//raw binary data (URLLoaderDataFormat.BINARY), or
			//URL-encoded variables (URLLoaderDataFormat.VARIABLES).
			_cLoader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		private function onHttpStatusEvent(oEvent:HTTPStatusEvent):void
		{
			//trace("DataPointsParser::onHttpStatusEvent");
			//oEvent.type = HTTPStatusEvent.HTTP_STATUS
			//Dispatched if a call to URLLoader.load() attempts to access
			//data over HTTP and the current Flash Player environment is able
			//to detect and return the status code for the request.
			//trace("Status: " + oEvent.status);
			//trace("HTTPStatusEvent Props: " + oEvent.toString());
		}
		
		private function onSecurityError(oEvent:SecurityErrorEvent):void
		{
			//trace("DataPointsParser::onSecurityError");
			//oEvent.type = SecurityErrorEvent.SECURITY_ERROR
			//Dispatched if a call to URLLoader.load() attempts to load data
			//from a server outside the security sandbox.
			//trace("SecurityErrorEvent Props: " + oEvent.toString());
		}
		
		private function onXmlPartialDataReceive(oEvent:ProgressEvent):void
		{
			//trace("DataPointsParser::onXmlPartialDataReceive");
			//oEvent.type = ProgressEvent.PROGRESS
			//Dispatched when data is received as the download operation progresses.
			var cUrlLoader:URLLoader = URLLoader(oEvent.target);
			var nBytesLoaded:uint = cUrlLoader.bytesLoaded;
			var nBytesTotal:uint = cUrlLoader.bytesTotal;
			var nPercLoad:Number = (nBytesLoaded / nBytesTotal)*100;
			//trace("ProgressEvent Props: " + oEvent.toString());
		}
		
		private function onXmlStreamOpened(oEvent:Event):void
		{
			//trace("DataPointsParser::onXmlStreamOpened");
			//oEvent.type = Event.OPEN
			//Dispatched when the download operation commences
			//following a call to the URLLoader.load() method.
			//trace("Event Props: " + oEvent.toString());
		}
		
		private function onXmlDataLoadError(oEvent:IOErrorEvent):void
		{
			//trace("DataPointsParser::onXmlDataLoadError");
			//oEvent.type = IOErrorEvent.IO_ERROR
			//Dispatched if a call to URLLoader.load() results
			//in a fatal error that terminates the download.
			//trace("IOErrorEvent Props: " + oEvent.toString());
		}
		
		public function onXmlDataLoad(oEvent:Event):void
		{
			//trace("DataPointsParser::onXmlDataLoad");
			var cXmlData:XML = null;
			//oEvent.type = Event.COMPLETE
			//Dispatched after all the received data is decoded
			//and placed in the data property of the URLLoader object.
			//trace("Event Props: " + oEvent.toString());
			try
			{
				cXmlData = new XML(oEvent.target.data);
				try
				{
					_pfLoadComplete.apply(this, [cXmlData]);
				}
				catch(oErr:Error)
				{
					trace("Error: " + oErr);
				}
			}
			catch (oTypeError:TypeError)
			{
				trace("Error: Could not parse the XML");
				trace(oTypeError.message);
			} 
		}
	}
}