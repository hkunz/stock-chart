//
//  Test
//
//  Created by Harry Kunz on 2010-XX-XX.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package stock
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.xml.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import stock.control.GraphControl;
	import stock.graph.DataPoint;
	import stock.graph.DataPointStatus;
	import stock.graph.Graph;
	import stock.graph.BasicGraph;
	import stock.graph.RandomGraph;
	import stock.graph.GraphInterval;
	import stock.graph.GraphType;
	import stock.parser.DataPointsParser;
	
	public class StockTrade extends Sprite
	{
		private var _cDataPointsParser:DataPointsParser;
		private var _cGraph:Graph;
		private var _cGraphControl:GraphControl;
		
		/*******************************************************************************
			Function Description: Document Class 
			@
		*******************************************************************************/
		public function StockTrade()
		{
			//trace("StockTrade::StockTrade");
			this.addEventListener(Event.ADDED_TO_STAGE, onStageReady);
		}
		
		private function onStageReady(oEvent:Event):void
		{
			//trace("StockTrade::onStageReady");
			var fUseXmlDataPoints:Boolean = false; //true;
			/*
			Set this flag to true to create a BasicGraph and load
			points data from a sample XML file from "data" directory
			else set it to false to create a random graph
			*/
			
			
			if(fUseXmlDataPoints) loadDataPoints();
			else //else create a random graph with controls
			{
				createRandomGraph();
				createGraphControl();
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onStageReady);
		}
		
		private function createRandomGraph():void
		{
			//trace("StockTrade::createRandomGraph");
			var nW:uint = 680;
			var nH:uint = 320;
			var cRandomGraph:RandomGraph = new RandomGraph();
			cRandomGraph.x = 10;
			cRandomGraph.y = stage.stageHeight - nH - 25;
			cRandomGraph.setDimensions(nW,nH);
			cRandomGraph.createGraphBackground();
			this.addChild(cRandomGraph);
			_cGraph = cRandomGraph;
		}
		
		private function createGraphControl():void
		{
			//trace("StockTrade::createGraphControl");
			_cGraphControl = new GraphControl();
			_cGraphControl.x = 10;
			_cGraphControl.y = 10;
			_cGraphControl.takeControlOf(RandomGraph(_cGraph));
			_cGraphControl.initControl();
			_cGraphControl.initControlDefaults();
			this.addChild(_cGraphControl);
			_cGraphControl.createSummaryText();
		}
		
		private function createBasicGraph(aPoints:Array):void
		{
			//trace("StockTrade::createChart");
			var cBasicGraph:BasicGraph = new BasicGraph();
			var nW:uint = 700;
			var nH:uint = 400;
			var iPointOffset:uint = 0;
			var iDataPointsLimit:uint = 0; //use all data points

			_cGraph = cBasicGraph;
			
			cBasicGraph.x = 0;
			cBasicGraph.y = stage.stageHeight - nH;
			cBasicGraph.setDimensions(nW,nH);
			cBasicGraph.createGraphBackground();
			this.addChild(cBasicGraph);
			
			var cHighPoint:DataPoint = DataPointStatus.getHighRange(aPoints, iDataPointsLimit, iPointOffset);
			var cLowPoint:DataPoint = DataPointStatus.getLowRange(aPoints, iDataPointsLimit, iPointOffset);
			var nLowMin:Number = cLowPoint["_nLow"];
			var nLowMax:Number = cLowPoint["_nHigh"];
			var nHighMin:Number = cHighPoint["_nLow"];
			var nHighMax:Number = cHighPoint["_nHigh"];
			var nMin:Number = (nLowMin < nHighMin) ? nLowMin : nHighMin;
			var nMax:Number = (nHighMax > nLowMax) ? nHighMax : nLowMax;
			var nRange:Number = nMax - nMin;
			var nAutoInterval:Number = GraphInterval.getInterval(nRange, GraphInterval.AUTO);
			
			cBasicGraph.setDataPoints(aPoints);
			cBasicGraph.setDataPointsRange(nMin,nMax);
			cBasicGraph.setDataPointsLimit(iDataPointsLimit,iPointOffset);
			cBasicGraph.setGraphInterval(nAutoInterval);
			cBasicGraph.create();
			
			//_cGraph.plotDataPoints(GraphType.LINE_LOW, 2, 0xFF0000);
			cBasicGraph.plotDataPoints(GraphType.LINE_HIGH, 2, 0x0066FF);
			//_cGraph.plotDataPoints(GraphType.LINE_CLOSE, 2, 0xFFFF33);
			//_cGraph.plotDataPoints(GraphType.SQUARE_MAX, 2, 0x000000, -1, 0.5);
			
		}
		
		private function parseDataPoints(oXml:XML):Array
		{
			//trace("StockTrade::parseDataPoints");
			var aDataPoints:Array = new Array();
			var oPointList:XMLList = oXml["Point"];
			var iDataPoints:uint = oPointList.length();
			var iIndex:uint = 0;
			
			for(iIndex = 0; iIndex < iDataPoints; iIndex++)
			{
				var oNode:XML = oPointList[iIndex];
				var nOpen:Number = oNode.@O;
				var nClose:Number = oNode.@C;
				var nLow:Number = oNode.@L;
				var nHigh:Number = oNode.@H;
				var iVolume:uint = oNode.@V;
				var oTime:Date = null; //oNode.@T;
				aDataPoints.push(new DataPoint(nOpen,nClose,nLow,nHigh,iVolume,oTime));
			}
			return aDataPoints;
		}
		
		private function loadDataPoints():void
		{
			//trace("StockTrade::loadDataPoints");
			_cDataPointsParser = new DataPointsParser();
			_cDataPointsParser.setFilePath("data/PointsData.xml");
			_cDataPointsParser.setLoadComplete(onDataPointsLoad);
			_cDataPointsParser.loadXmlData();
		}
		
		private function onDataPointsLoad(oXml:XML):void
		{
			//trace("StockTrade::onDataPointsLoad: " + oXml);
			var aDataPoints:Array = parseDataPoints(oXml);
			createBasicGraph(aDataPoints);
		}
		
		public function destroy():void
		{
			//trace("StockTrade::destroy");
		}
	}
}