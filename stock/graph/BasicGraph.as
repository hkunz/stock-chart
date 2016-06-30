package stock.graph
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import stock.font.FontCast;
	import stock.graph.DataPoint;
	import stock.graph.Graph;
	import stock.graph.GraphInterval;
	import stock.graph.GraphType;
	
	public class BasicGraph extends Graph
	{
		private var _mcGraphicGuides:MovieClip;
		private var _mcNumericLabels:MovieClip;
		private var _mcDataPoints:MovieClip;
		
		public function BasicGraph()
		{
			//trace("BasicGraph::BasicGraph");
			_nGraphInterval = 0;
			_iDataPoints = 0;
			_mcGraphicGuides = new MovieClip();
			_mcDataPoints = new MovieClip();
			this.addChild(_mcGraphicGuides);
			this.addChild(_mcDataPoints);
		}
		
		public function createGraphBackground():void
		{
			//trace("BasicGraph::createGraphBackground");
			var oGraphics:Object = this.graphics;
			oGraphics.lineStyle(3, 0xCCCCCC, 1.0);
			oGraphics.beginFill(0xFFFFFF, 1.0);
			oGraphics.moveTo(0,0);
			oGraphics.lineTo(_iWidth,0);
			oGraphics.lineStyle(3, 0xCCCCCC, 0);
			oGraphics.lineTo(_iWidth,_iHeight);
			oGraphics.lineStyle(3, 0xCCCCCC, 1.00);
			oGraphics.lineTo(0,_iHeight);
			oGraphics.lineStyle(3, 0xCCCCCC, 0);
			oGraphics.lineTo(0,0);
			oGraphics.endFill();
		}

		override protected function createGraphContent():void
		{
			//trace("BasicGraph::createGraphContent");
			var nRange:Number = Math.round((_nMaxPoint - _nMinPoint)*1000)*0.001;
			var iLineDivisions:uint = nRange / _nGraphInterval + 2;			
			var nRemainder:Number = Math.round((_nMinPoint%_nGraphInterval)*1000)*0.001;
			_nMinGraphPoint = _nMinPoint - nRemainder;
			_nMaxGraphPoint = _nMinGraphPoint + iLineDivisions*_nGraphInterval;
			if(_nMaxGraphPoint > GraphInterval.MAX) iLineDivisions = 2;
			createGraphGuides(iLineDivisions);
			//plotDataPoints("_nClose", 2, 0x555555, 0x0066FF, 1.0, 0.1);
			//plotDataPoints("_nOpen", 2, 0x0066FF);
			//plotDataPoints(GraphType.LINE_LOW, 2, 0xFF0000);
			//plotDataPoints(GraphType.LINE_HIGH, 2, 0x00FF00);
			//plotDataPoints(GraphType.LINE_CLOSE, 2, 0xFFFF33);
			//plotDataPoints(GraphType.SQUARE_MAX, 2, 0x000000, -1, 0.5);
		}
				
		protected function createGraphGuides(iLineDivisions:uint, fLabels:Boolean=true):MovieClip
		{
			//trace("BasicGraph::createGraphGuides");
			var fGraphExceeded:Boolean = (_nMaxGraphPoint > GraphInterval.MAX);
			if(fGraphExceeded) {iLineDivisions = 4; _nGraphInterval = GraphInterval.MAX*0.25;}
			var nMinLabel:Number = _nMinGraphPoint + _nGraphInterval;
			var iLinePxDist:uint = _iHeight/iLineDivisions;
			var iLine:uint = 1;
			var oGraphics:Object = _mcGraphicGuides.graphics;
			var iFloatFix:uint = 0;
			
			if(nMinLabel < 100) iFloatFix = 3;
			else if(nMinLabel < 5000) iFloatFix = 2;

			oGraphics.clear();
			oGraphics.lineStyle(1, 0xCCCCCC, 1.00);
			
			if(_mcNumericLabels) this.removeChild(_mcNumericLabels);
			_mcNumericLabels = null;
			_mcNumericLabels = new MovieClip();
			
			for(iLine = 0; iLine < iLineDivisions; iLine++)
			{
				var iLineY:uint = _iHeight - iLinePxDist*(iLine);
				if(fLabels == true)
				{
					var txLabel:TextField = new TextField();
					var nLabel:Number = (nMinLabel + (iLine-1)*_nGraphInterval);
					txLabel.text = nLabel.toFixed(iFloatFix);
					FontCast.castFontVerdana(txLabel, 0x555555, 11);
					txLabel.x = _iWidth - txLabel.width;
					txLabel.y = iLineY - txLabel.height;
					_mcNumericLabels.addChild(txLabel);
				}
				oGraphics.moveTo(0,iLineY);
				oGraphics.lineTo(_iWidth,iLineY);
				this.addChild(_mcNumericLabels);
			}
			
			return _mcGraphicGuides;
		}
				
		public function plotDataPoints(sGraphType:String,
												 iLineThick:uint=2,
												 iLineColor:uint=0,
												 iFillColor:int=-1,
												 iLineAlpha:Number=1.0,
												 iFillAlpha:Number=1.0):MovieClip
		{
			//trace("BasicGraph::plotDataPoints");
			if(_nMaxGraphPoint > GraphInterval.MAX) _nMaxGraphPoint = GraphInterval.MAX;
			var sType:String = (sGraphType.indexOf("_n")!=-1) ? GraphType.LINE : sGraphType;
			var cPoint:DataPoint = null;
			var nMaxRange:Number = _nMaxGraphPoint - _nMinGraphPoint;
			var nPropConst:Number = _iHeight/nMaxRange;
			var iDataPoints:uint = _aDataPoints.length;
			var iPoints:uint = ((_iDataPoints == 0) ? iDataPoints : (_iDataPoints+_iPointOffset));
			var iPadding:uint = 60;
			var nPointDistance:Number = (_iWidth-iPadding) / (iPoints-_iPointOffset-1);
			var iPoint:uint = 0;
			var nY:Number = 0;
			var nX:Number = 0;
			var mcPlotData:MovieClip = new MovieClip();
			var oGraphics:Object = mcPlotData.graphics;
			
			_mcDataPoints.addChild(mcPlotData);
			
			
			oGraphics.clear();
			oGraphics.moveTo(0,_iHeight);
			if(iFillColor > -1) oGraphics.beginFill(iFillColor, iFillAlpha);
			
			switch(sType)
			{
				case GraphType.LINE:
				{
					oGraphics.lineStyle(iLineThick, iLineColor, 0);
					for(iPoint = _iPointOffset; iPoint < iPoints; iPoint++)
					{
						if(iPoint >= iDataPoints) break;
						cPoint = _aDataPoints[iPoint];
						nY = _iHeight - ((cPoint[sGraphType] - _nMinGraphPoint) * nPropConst);
						oGraphics.lineTo(nX,nY);
						nX += nPointDistance;
						oGraphics.lineStyle(iLineThick, iLineColor, iLineAlpha);
					}
					break;
				}
				case GraphType.SQUARE_MAX:
				{
					for(iPoint = _iPointOffset+1; iPoint < iPoints; iPoint++)
					{
						if(iPoint >= iDataPoints) break;
						cPoint = _aDataPoints[iPoint];
						var nLow:Number = cPoint["_nLow"];
						var nHigh:Number = cPoint["_nHigh"];
						nY = _iHeight - ((nLow - _nMinGraphPoint) * nPropConst);
						oGraphics.lineTo(nX,nY);
						oGraphics.lineStyle(iLineThick, iLineColor, iLineAlpha);
						nX += nPointDistance*0.5;
						oGraphics.lineTo(nX,nY);
						nY = _iHeight - ((nHigh - _nMinGraphPoint) * nPropConst);
						oGraphics.lineTo(nX,nY);
						nX += nPointDistance*0.5;
						oGraphics.lineTo(nX,nY);
						oGraphics.lineStyle(iLineThick, iLineColor, iLineAlpha);
					}
					break;
				}
			}

			oGraphics.lineStyle(iLineThick, iLineColor, 0);
			oGraphics.lineTo(nX-nPointDistance,_iHeight);
			oGraphics.lineTo(0,_iHeight);
			if(iFillColor > -1) oGraphics.endFill();
			return mcPlotData;
		}
		
		protected function clearGraphicGuides():void {_mcGraphicGuides.graphics.clear();}
		protected function removeNumericLabels():void
		{
			if(_mcNumericLabels) this.removeChild(_mcNumericLabels);
			_mcNumericLabels = null;
		}
		
		public function removeDataPoints(mcPlotData:MovieClip):void
		{
			_mcDataPoints.removeChild(mcPlotData);
			mcPlotData = null;
		}
	}
}