package stock.graph
{
	public class GraphInterval
	{
		public static const AUTO:uint = 0;
		public static const TYPE_1:uint = 1;
		public static const TYPE_2:uint = 2;
		public static const MAX:Number = 10000000;
		
		public static function getInterval(nRange:Number, eType:uint):Number
		{
			//trace("GraphInterval::getInterval(" + nRange + "," + eType + ")");
			var nInterval:Number = 0;
			switch(eType)
			{
				case AUTO: nInterval = getAutoInterval(nRange); break;
				case TYPE_1: nInterval = getAutoInterval(nRange); break;
				case TYPE_2: nInterval = getAutoInterval(nRange); break;
				default: trace("Error: Invalid Interval Type: " + eType);
			}
			return nInterval;
		}
		
		private static function getAutoInterval(nRange:Number):Number
		{
			//trace("GraphInterval::getIntervalType1(" + nRange + ")");
			var iIndex:uint = 0;
			var aRanges:Array = [0.01, //0.002
										0.05, //0.01
										0.10, //0.02
										0.25, //0.05
										0.50, //0.10
										1.25, //0.25
										2.50, //0.5
										5.00, //1.00
										10, //2.00
										20, //4.00
										50, //10.00
										150, //25.00
										250, //50.00
										500, //100.00
										1250, //250.00
										2500,
										5000,
										12500,
										25000,
										50000,
										125000,
										250000,
										500000,
										1250000,
										2500000,
										5000000];
										
			var nInterval:Number = MAX;
			var iLoop:uint = aRanges.length;
			var nTestRange:Number = 0;
			var iLoops:uint = 0;
			
			if(nRange < 1.25) iIndex = 0;
			else if(nRange < 10) iIndex = 5;
			else if(nRange < 1250) iIndex = 8;
			else if(nRange < 50000) iIndex = 14;
			else if(nRange < 12500000) iIndex = 18;
			
			for(iIndex; iIndex < iLoop; iIndex++)
			{
				nTestRange = aRanges[iIndex];
				if(nRange < nTestRange)
				{
					nInterval = nTestRange / 5;
					break;
				}
				iLoops++;
			}

			//nInterval = Math.round(nInterval*1000)/1000;
			return nInterval;
		}
	}
}