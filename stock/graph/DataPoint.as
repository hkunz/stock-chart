package stock.graph
{
	//import;
	
	public class DataPoint extends Object
	{
		public var _nOpen:Number;
		public var _nHigh:Number;
		public var _nLow:Number;
		public var _nClose:Number;
		public var _iVolume:uint;
		public var _oTime:Date;
		
		public function DataPoint(nOpen:Number=0,
											nClose:Number=0,
											nLow:Number=0,
											nHigh:Number=0,
											iVolume:uint=0,
											oTime:Date=null)
		{
			//trace("DataPoint::DataPoint");
			_nOpen = nOpen;
			_nHigh = nHigh;
			_nLow = nLow;
			_nClose = nClose;
			_iVolume = iVolume;
			_oTime = oTime;
		}
		
		public function getTime():Date
		{
			return _oTime;
		}
	}
}