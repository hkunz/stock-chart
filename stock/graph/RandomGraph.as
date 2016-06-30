package stock.graph
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import stock.events.GraphEvent;
	import stock.graph.BasicGraph;
	import stock.graph.DataPoint;
	import stock.graph.GraphInterval;
	import stock.parser.DataPointsParser;
	
	final public class RandomGraph extends BasicGraph
	{
		private var _mcHighPlot:MovieClip;
		private var _mcLowPlot:MovieClip;
		private var _mcOpenPlot:MovieClip;
		private var _mcClosePlot:MovieClip;
		private var _mcSquarePlot:MovieClip;
		private var _oAutoGenTimer:Timer;
		private var _fConstChange:Boolean;
		private var _nPrevGraphMax:Number;
		private var _nPrevGraphMin:Number;
		private var _fAutoInterval:Boolean;
		
		private static var PERCENT_CHANGE_TOLERANCE:Number = 7;
		private static var PERCENT_LOW_HIGH_TOLERANCE:Number = 10;
		private static var TREND:Number = 0; //Percent Improvement
		
		public function RandomGraph()
		{
			//trace("RandomGraph::RandomGraph");
			_fConstChange = true;
			_fAutoInterval = true;
			setDataPointsLimit(10);
			_aDataPoints = new Array();
		}
		
		public function initRandomDataPoint(nStartValue:Number=100):void
		{
			//trace("RandomGraph::initRandomDataPoint");
			var iPointOffset:uint = 0;
			var iDataPointsLimit:uint = 0;
			var nLoHiTolerance:Number = PERCENT_LOW_HIGH_TOLERANCE*0.01;
			var nNextValue:Number = nStartValue*nLoHiTolerance;
			var nLow:Number = nStartValue - nStartValue*nLoHiTolerance;
			var nHigh:Number = nStartValue + nStartValue*nLoHiTolerance;
			_aDataPoints["StartValue"] = nStartValue;
			_aDataPoints.push(new DataPoint(nStartValue, nStartValue, nLow, nHigh));
		}
		
		override protected function createGraphContent():void
		{
			//trace("BasicGraph::createGraphContent");
			var iLineLimit:uint = 20;
			var nRange:Number = Math.round((_nMaxPoint - _nMinPoint)*1000)*0.001;
			var iLineDivisions:uint = nRange / _nGraphInterval + 2;

			if(iLineDivisions > iLineLimit && _fAutoInterval == false)
			{
				_fAutoInterval = true;
				var cGraphEvent:GraphEvent = new GraphEvent(GraphEvent.INAPPLICABLE_INTERVAL);
				this.dispatchEvent(cGraphEvent);
				return;
			}
			
			
			var nRemainder:Number = Math.round((_nMinPoint%_nGraphInterval)*1000)*0.001;
			_nMinGraphPoint = _nMinPoint - nRemainder;
			_nMaxGraphPoint = _nMinGraphPoint + iLineDivisions*_nGraphInterval;

			
			if(_nMaxGraphPoint > GraphInterval.MAX) iLineDivisions = 2;
			
			if(_nPrevGraphMax != _nMaxGraphPoint || _nPrevGraphMin != _nMinGraphPoint)
			{
				createGraphGuides(iLineDivisions);
				_nPrevGraphMax = _nMaxGraphPoint;
				_nPrevGraphMin = _nMinGraphPoint;
			}
		}
		
		public function startAutoGenerate(iMs:uint=0):void
		{
			//trace("RandomGraph::startAutoGenerate");
			if(iMs > 0)
			{
				if(_oAutoGenTimer)
				{
					_oAutoGenTimer.stop();
					_oAutoGenTimer.removeEventListener(TimerEvent.TIMER, onAutoGenerate);
					_oAutoGenTimer = null;
				}
				_oAutoGenTimer = new Timer(iMs);
				_oAutoGenTimer.addEventListener(TimerEvent.TIMER, onAutoGenerate);
			}
			if(_oAutoGenTimer)
			{
				//call 2 times for 2 points to initially form 1 line
				onAutoGenerate(null);
				onAutoGenerate(null);
				_oAutoGenTimer.start();
			}
		}
		
		public function stopAutoGenerate():void
		{
			_oAutoGenTimer.stop();
		}
		
		public function createInstantRandomGraph(iPoints:uint):void
		{
			//trace("RandomGraph::createRandomDataPoints");
			var iPoint:uint = 0;
			
			for(iPoint; iPoint < iPoints; iPoint++)
			{
				var cPoint:DataPoint = generateRandomDataPoint();
				var nClose:Number = cPoint["_nClose"];
				if(nClose > 0 && nClose < GraphInterval.MAX)
				{
					_aDataPoints.push(cPoint);
				}
			}
			if(_aDataPoints.length < _iDataPoints) _iDataPoints = _aDataPoints.length;
			createBasicGraph(_aDataPoints);
			
			var cGraphEvent:GraphEvent = new GraphEvent(GraphEvent.CREATE_COMPLETE);
			this.dispatchEvent(cGraphEvent);
		}
		
		public function generateRandomDataPoint():DataPoint
		{
			//trace("RandomGraph::generateRandomDataPoint");
			var nTolerance:Number = PERCENT_CHANGE_TOLERANCE;
			var nHiLoTolerance:Number = PERCENT_LOW_HIGH_TOLERANCE;
			var nChange:Number = 0.01*(Math.random()*nTolerance*2 - nTolerance + TREND);
			var nHiChange:Number = 0.01*(Math.random()*nHiLoTolerance);
			var nLoChange:Number = 0.01*(Math.random()*nHiLoTolerance);
			var iDataPoints:uint = _aDataPoints.length;
			var oLastDataPoint:DataPoint = _aDataPoints[iDataPoints-1];
			var nLastValue:Number = oLastDataPoint["_nClose"];
			var nChangeBasis:Number;
			if(_fConstChange) nChangeBasis = _aDataPoints["StartValue"];
			else nChangeBasis = nLastValue;
			var nNxClose:Number = nLastValue + nChangeBasis*nChange;
			var nNxLow:Number = nNxClose - nNxClose*nLoChange;
			var nNxHigh:Number = nNxClose + nNxClose*nHiChange;
			if(nNxLow < 0) return (new DataPoint(0, 0));
			else if(nNxHigh > GraphInterval.MAX) return (new DataPoint(0, GraphInterval.MAX));
			else return (new DataPoint(0, nNxClose, nNxLow, nNxHigh));
		}
		
		private function onAutoGenerate(oEvent:TimerEvent):void
		{
			//trace("StockTrade::onAutoGenerate");			
			createBasicGraph(_aDataPoints);
			_aDataPoints.push(generateRandomDataPoint());
		}
		
		private function createBasicGraph(aPoints:Array):void
		{
			//trace("StockTrade::createChart");
			
			var iPointOffset:uint = 0;
			var iDataPointsLimit:uint = _iDataPoints;

			if(aPoints.length > _iDataPoints)
			{
				delete aPoints[0];
				aPoints.splice(0,1);
			}
			
			var cHighPoint:DataPoint = DataPointStatus.getHighRange(aPoints, iDataPointsLimit, iPointOffset);
			var cLowPoint:DataPoint = DataPointStatus.getLowRange(aPoints, iDataPointsLimit, iPointOffset);
			var nLowMin:Number = cLowPoint["_nLow"];
			var nLowMax:Number = cLowPoint["_nHigh"];
			var nHighMin:Number = cHighPoint["_nLow"];
			var nHighMax:Number = cHighPoint["_nHigh"];
			var nMin:Number = Math.round(((nLowMin < nHighMin) ? nLowMin : nHighMin)*1000)*0.001;
			var nMax:Number = Math.round(((nHighMax > nLowMax) ? nHighMax : nLowMax)*1000)*0.001;
			var nRange:Number = nMax - nMin;
			var nInterval:Number = _nGraphInterval;
			
			if(_fAutoInterval == true) nInterval = GraphInterval.getInterval(nRange, GraphInterval.AUTO);

			setDataPoints(aPoints);
			setDataPointsRange(nMin,nMax);
			setDataPointsLimit(iDataPointsLimit,iPointOffset);
			_nGraphInterval = nInterval;
			
			if(nMin < 0.0005)
			{
				var cGraphEvent1:GraphEvent = new GraphEvent(GraphEvent.MIN_VALUE_EXCEEDED);
				stopAutoGenerate();
				this.dispatchEvent(cGraphEvent1);
			}

			else if(nMax > GraphInterval.MAX)
			{
				var cGraphEvent2:GraphEvent = new GraphEvent(GraphEvent.MAX_VALUE_EXCEEDED);
				stopAutoGenerate();
				this.dispatchEvent(cGraphEvent2);
			}

			clearGraph();
			createGraphContent();
			//create();
			_mcHighPlot = plotDataPoints(GraphType.LINE_HIGH, 2, 0x00FF00);//, 0x00FF00, 1, 0.1);
			_mcSquarePlot = plotDataPoints(GraphType.SQUARE_MAX, 2, 0xFFFF33, -1, 0.4);
			_mcClosePlot = plotDataPoints(GraphType.LINE_CLOSE, 3, 0x0066FF, 0x00FF00, 1, 0.1);
			_mcLowPlot = plotDataPoints(GraphType.LINE_LOW, 2, 0xFF0000); //, 0xFF0000, 1, 0.2);
			
			var cGraphEventChange:GraphEvent = new GraphEvent(GraphEvent.GRAPH_CHANGE);
			this.dispatchEvent(cGraphEventChange);
		}
		
		public function clearGraph():void
		{
			if(_mcLowPlot) removeDataPoints(_mcLowPlot);
			if(_mcHighPlot) removeDataPoints(_mcHighPlot);
			if(_mcClosePlot) removeDataPoints(_mcClosePlot);
			if(_mcSquarePlot) removeDataPoints(_mcSquarePlot);

			_mcLowPlot = null;
			_mcHighPlot = null;
			_mcClosePlot = null;
			_mcSquarePlot = null;
		}
		
		public function reset():void
		{
			var iPoints:uint = _aDataPoints.length;
			var iLoop:uint = 0;
			for(iLoop; iLoop < iPoints; iLoop++)
			{
				delete _aDataPoints[iLoop];
			}
			_aDataPoints = null;
			_aDataPoints = new Array();
			removeNumericLabels();
			clearGraphicGuides();
			_nPrevGraphMax = 0;
			_nPrevGraphMin = 0;
		}
		
		public function initTimer():void
		{
			if(_oAutoGenTimer) _oAutoGenTimer.stop();
			_oAutoGenTimer = null;
			_oAutoGenTimer = new Timer(0);
		}
		
		public function setConstGraphChange(fStartBased:Boolean):void {_fConstChange = fStartBased;}
		//public function isAutoGenerateActive():Boolean {return _oAutoGenTimer.running;}
		public function setAutoGenerateSpeed(iMs:uint):void {_oAutoGenTimer.delay = iMs;}
		public function setTrend(nTrend:Number):void	{TREND = nTrend;}
		public function setPercentChangeTolerance(nTolerance:Number):void {PERCENT_CHANGE_TOLERANCE = nTolerance;}
		public function setPercentHiLoTolerance(nTolerance:Number):void {PERCENT_LOW_HIGH_TOLERANCE = nTolerance;}
		
		override public function setGraphInterval(nInterval:Number):void
		{
			if(nInterval == 0) _fAutoInterval = true;
			else _fAutoInterval = false;
			super.setGraphInterval(nInterval);
		}
	}
}