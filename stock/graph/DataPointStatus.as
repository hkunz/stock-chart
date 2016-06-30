package stock.graph
{
	import stock.graph.DataPoint;
	
	public class DataPointStatus
	{
		public static function getCloseRange(aDataPoints:Array,
														 iLimit:uint=0,
														 iOffset:uint=0):DataPoint
		{
			//trace("DataPointStatus::getCloseRange");
			var cDataPoint = null;
			cDataPoint = getRange(aDataPoints, "_nClose", iLimit, iOffset);
			return cDataPoint;
		}
		
		public static function getOpenRange(aDataPoints:Array,
														iLimit:uint=0,
														iOffset:uint=0):DataPoint
		{
			//trace("DataPointStatus::getOpenRange");
			var cDataPoint = null;
			cDataPoint = getRange(aDataPoints, "_nOpen", iLimit, iOffset);
			return cDataPoint;
		}
		
		public static function getHighRange(aDataPoints:Array,
														iLimit:uint=0,
														iOffset:uint=0):DataPoint
		{
			//trace("DataPointStatus::getOpenRange");
			var cDataPoint = null;
			cDataPoint = getRange(aDataPoints, "_nHigh", iLimit, iOffset);
			return cDataPoint;
		}
		
		public static function getLowRange(aDataPoints:Array,
														iLimit:uint=0,
														iOffset:uint=0):DataPoint
		{
			//trace("DataPointStatus::getOpenRange");
			var cDataPoint = null;
			cDataPoint = getRange(aDataPoints, "_nLow", iLimit, iOffset);
			return cDataPoint;
		}
		
		private static function getRange(aDataPoints:Array,
													sProp:String,
													iLimit:uint=0,
													iOffset:uint=0):DataPoint
		{
			//trace("DataPointStatus::getRange");
			var iDataPoints:uint = aDataPoints.length;
			var iPoints:uint = ((iLimit == 0) ? iDataPoints : iLimit) + iOffset;
			var cPoint:DataPoint = aDataPoints[iOffset];
			var nLow:Number = cPoint[sProp]; //sProp: _nClose/_nOpen
			var nHigh:Number = nLow;
			var nCurClose:Number;
			var iIndex:uint = 0;
			for(iIndex = iOffset; iIndex < iPoints; iIndex++)
			{
				
				if(iIndex >= iDataPoints) break;
				cPoint = aDataPoints[iIndex];
				nCurClose = cPoint[sProp]; //sProp: _nClose/_nOpen
				if(nLow > nCurClose) nLow = nCurClose;
				if(nHigh < nCurClose) nHigh = nCurClose;
			}
			return (new DataPoint(0,0,nLow, nHigh));
		}
		
		//public static function getRangeVolume(aDataPoints:Array):uint
	}
}