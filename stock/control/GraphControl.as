package stock.control
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import stock.events.GraphEvent;
	import stock.graph.Graph;
	import stock.graph.RandomGraph;
	
	public class GraphControl extends Sprite
	{
		private var _mcSummary:Summary;
		private var _cGraph:RandomGraph;
		private var _rdgGraphChg:RadioButtonGroup;
		private var _rdgInterval:RadioButtonGroup;
		
		//GraphControl components:
		/*
		private var _btnStart:Button;
		private var _btnReset:Button;
		private var _txStartValue:TextInput;
		private var _txCustomInterval:TextInput;
		private var _txPercClose:TextInput;
		private var _txPercHiLo:TextInput;
		private var _txDataPtsLimit:TextInput;
		private var _txAutoGenSpeed:TextInput;
		private var _txGraphTrend:TextInput;
		private var _sdrGraphTrend:Slider;
		private var _sdrAutoGenSpeed:Slider;
		private var _sdrPercClose:Slider;
		private var _sdrPercHiLo:Slider;
		private var _sdrDataPtsLimit:Slider;
		private var _rdPercStartValue:RadioButton;
		private var _rdPercPrevClose:RadioButton;
		private var _rdAutoInterval:RadioButton;
		private var _rdCustomInterval:RadioButton;
		private var _btnCreateInstantGraph:Button;
		*/
		private static const SPEED_INTERVAL:Number = 50;
		private static const DEFAULT_PERC_HILO_CHANGE:uint = 5;
		private static const DEFAULT_CLOSE_CHANGE:uint = 3;
		private static const DEFAULT_SPEED:uint = 500;
		private static const DEFAULT_START_PRICE:Number = 100;
		private static const MIN_START_PRICE:Number = 0.005;
		
		public function GraphControl()
		{
			//trace("GraphControl::GraphControl");
			
		}
		
		public function createSummaryText():void
		{
			_mcSummary = new Summary();
			_mcSummary.x = (this.stage.stageWidth - _mcSummary.width)*0.5 - this.x;
			_mcSummary.y = ((this.stage.stageHeight-this.height) - _mcSummary.height)*0.5 + 150;
			this.addChild(_mcSummary);
		}
		
		private function removeSummaryText():void
		{

			if(_mcSummary) this.removeChild(_mcSummary);
			_mcSummary = null;
		}
		
		public function takeControlOf(cGraph:RandomGraph):void
		{
			//trace("GraphControl::addControl");
			_cGraph = cGraph;
			_cGraph.initTimer();
			_cGraph.addEventListener(GraphEvent.MAX_VALUE_EXCEEDED, onGraphMaxExceeded);
			_cGraph.addEventListener(GraphEvent.MIN_VALUE_EXCEEDED, onGraphMinExceeded);
			_cGraph.addEventListener(GraphEvent.CREATE_COMPLETE, onGraphCreateComplete);
			_cGraph.addEventListener(GraphEvent.INAPPLICABLE_INTERVAL, onGraphIntervalTooSmall);
			_cGraph.addEventListener(GraphEvent.GRAPH_CHANGE, onGraphChange);
		}
		
		private function onGraphMaxExceeded(oEvent:GraphEvent):void
		{
			//trace("GraphControl::onGraphMaxExceeded");
			_btnStart.label = "Start";
			_btnStart.enabled = false;
		}
		
		private function onGraphMinExceeded(oEvent:GraphEvent):void
		{
			//trace("GraphControl::onGraphMinExceeded");
			_btnStart.label = "Start";
			_btnStart.enabled = false;
		}
		
		public function initControl():void
		{
			//trace("GraphControl::initControl");

			_txStartValue.text = DEFAULT_START_PRICE.toString();
			_txStartValue.restrict = "0-9.";
			_txStartValue.addEventListener(Event.CHANGE, onStartValueTextChange);
			_txStartValue.maxChars = 6;
			
			_btnReset.label = "Reset";
			_btnReset.addEventListener(MouseEvent.CLICK, onResetButtonClick);
			
			_btnStart.addEventListener(MouseEvent.CLICK, onButtonStartClick);
			_btnStart.label = "Start";
			
			_sdrAutoGenSpeed.liveDragging = true;
			_sdrAutoGenSpeed.minimum = 50;
			_sdrAutoGenSpeed.maximum = 1000;
			_sdrAutoGenSpeed.addEventListener(SliderEvent.CHANGE, onSpeedGenerationChange);
			_sdrAutoGenSpeed.snapInterval = 50;
			
			_sdrGraphTrend.liveDragging = true;
			_sdrGraphTrend.minimum = -10;
			_sdrGraphTrend.maximum = +10;
			_sdrGraphTrend.addEventListener(SliderEvent.CHANGE, onTrendSliderChange);
			_sdrGraphTrend.snapInterval = 1;
			
			_sdrPercClose.liveDragging = true;
			_sdrPercClose.minimum = 0;
			_sdrPercClose.maximum = 30;
			_sdrPercClose.addEventListener(SliderEvent.CHANGE, onPercentChangeToleranceSliderChange);
			_sdrPercClose.snapInterval = 1;
			
			_sdrPercHiLo.liveDragging = true;
			_sdrPercHiLo.minimum = 0;
			_sdrPercHiLo.maximum = 30;
			_sdrPercHiLo.addEventListener(SliderEvent.CHANGE, onPercentHiLoToleranceSliderChange);
			_sdrPercHiLo.snapInterval = 1;
			
			_sdrDataPtsLimit.liveDragging = true;
			_sdrDataPtsLimit.minimum = 5;
			_sdrDataPtsLimit.maximum = 100;
			_sdrDataPtsLimit.addEventListener(SliderEvent.CHANGE, onDataPointsLimitSliderChange);
			_sdrDataPtsLimit.snapInterval = 1;
			
			_rdgGraphChg = new RadioButtonGroup("GraphPercChange");
			_rdgGraphChg.addEventListener(Event.CHANGE, onGraphPercChangeMode);
			_rdPercStartValue.label = "Start Price";
			_rdPercStartValue.width = 130;
			_rdPercStartValue.group = _rdgGraphChg;
			_rdPercStartValue.value = true;
			_rdPercPrevClose.label = "Previous Close";
			_rdPercStartValue.width = 130;
			_rdPercPrevClose.group = _rdgGraphChg;
			_rdPercPrevClose.value = false;
			
			_rdgInterval = new RadioButtonGroup("IntervalMode");
			_rdgInterval.addEventListener(Event.CHANGE, onIntervalModeChange);
			_rdAutoInterval.label = "Auto";
			_rdAutoInterval.group = _rdgInterval;
			_rdAutoInterval.value = true;
			_rdCustomInterval.label = "Custom";
			_rdCustomInterval.group = _rdgInterval;
			_rdCustomInterval.value = false;
			
			_btnCreateInstantGraph.label = "Instant Create";
			_btnCreateInstantGraph.addEventListener(MouseEvent.CLICK, onInstantGraphButtonClick);
			
			_txDataPtsLimit.maxChars = 3;
			_txDataPtsLimit.restrict = "0-9";
			_txDataPtsLimit.addEventListener(Event.CHANGE, onDataPtsLimitTextChange);
			
			_txPercClose.maxChars = 2;
			_txPercClose.restrict = "0-9";
			_txPercClose.addEventListener(Event.CHANGE, onPercentChangeToleranceTextChange);
			
			_txPercHiLo.maxChars = 2;
			_txPercHiLo.restrict = "0-9";
			_txPercHiLo.addEventListener(Event.CHANGE, onPercentHiLoToleranceTextChange);
			
			_txCustomInterval.restrict = "0-9.";
			_txCustomInterval.addEventListener(Event.CHANGE, onCustomIntervalTextChange);
			
			_txGraphTrend.enabled = false;
			_txGraphTrend.maxChars = 2;
			_txGraphTrend.restrict = "0-9-";
			_txGraphTrend.addEventListener(Event.CHANGE, onTrendTextChange);
			
			_txAutoGenSpeed.enabled = false;
			
		}
		
		public function initControlDefaults():void
		{
			//trace("GraphControl::initControlDefaults");
			_rdPercStartValue.selected = true;
			_sdrAutoGenSpeed.value = 500;
			_sdrDataPtsLimit.value = 50;
			_sdrGraphTrend.value = 0;
			_sdrPercHiLo.value = DEFAULT_PERC_HILO_CHANGE;
			_sdrPercClose.value = DEFAULT_CLOSE_CHANGE;
			_rdAutoInterval.selected = true;
			
			_txPercHiLo.text = _sdrPercHiLo.value.toString();
			_txPercClose.text = _sdrPercClose.value.toString();
			_txAutoGenSpeed.text = _sdrAutoGenSpeed.value.toString();
			_txDataPtsLimit.text = _sdrDataPtsLimit.value.toString();
			_txGraphTrend.text = _sdrGraphTrend.value.toString();
			_txStartValue.text = DEFAULT_START_PRICE.toString();
			_txCustomInterval.enabled = _rdCustomInterval.selected;
			_txCustomInterval.text = DEFAULT_START_PRICE.toString();
		}
		
		public function initGraphInputs():void
		{
			//trace("GraphControl::initGraphInputs");
			var nStartValue:Number = Number(_txStartValue.text);		
			if(isNaN(nStartValue) || nStartValue == 0 || nStartValue < MIN_START_PRICE)
			{
				nStartValue = DEFAULT_START_PRICE;
				_txStartValue.text = nStartValue.toString();
				castFontColor(_txStartValue, 0x000000);
				_txCustomInterval.text = nStartValue.toString();
			}

			var fAuto:Boolean = _rdAutoInterval.selected;
			var nInterval:Number = (fAuto) ? 0 : Number(_txCustomInterval.text);
			if(isNaN(nInterval)) nInterval = 0;
			_cGraph.setGraphInterval(nInterval);
			_cGraph.initRandomDataPoint(nStartValue);
			_cGraph.setAutoGenerateSpeed(_sdrAutoGenSpeed.value);
			_cGraph.setPercentHiLoTolerance(_sdrPercHiLo.value);
			_cGraph.setPercentChangeTolerance(_sdrPercClose.value);
			_cGraph.setDataPointsLimit(_sdrDataPtsLimit.value);
			_cGraph.setTrend(_sdrGraphTrend.value);
		}
		
		private function onResetButtonClick(oEvent:MouseEvent):void
		{
			//trace("GraphControl::onResetButtonClick");
			var iDataPoints:uint = _cGraph.getDataPoints().length;
			if(iDataPoints > 1)
			{
				_cGraph.stopAutoGenerate();
				_cGraph.clearGraph();
				_cGraph.reset();
				onButtonStopClick(null);
				_txStartValue.enabled = true;
				_btnStart.label = "Start";
				_btnStart.enabled = true;
				_btnCreateInstantGraph.enabled = true;
				createSummaryText();
			}
			initControlDefaults();
		}
		
		private function onGraphPercChangeMode(oEvent:Event):void
		{
			//trace("GraphControl::onGraphPercChangeMode");
			var rdgChange:RadioButtonGroup = oEvent.target as RadioButtonGroup;
			var fConstChange:Boolean = rdgChange.selectedData as Boolean;
			_cGraph.setConstGraphChange(fConstChange);
		}
		
		private function onIntervalModeChange(oEvent:Event):void
		{
			//trace("GraphControl::onIntervalModeChange");
			var rdgInterval:RadioButtonGroup = oEvent.target as RadioButtonGroup;
			var fAuto:Boolean = rdgInterval.selectedData as Boolean;
			var nValue:Number = Number(_txCustomInterval.text);
			_txCustomInterval.enabled = !fAuto;
			if(isNaN(nValue) || fAuto) nValue = 0;
			_cGraph.setGraphInterval(nValue);
		}
		
		private function onSpeedGenerationChange(oEvent:SliderEvent):void
		{
			//trace("GraphControl::onSpeedGenerationChange");
			var oSlider:Slider = oEvent.target as Slider;
			var iSliderValue:uint = oSlider.value;

			_txAutoGenSpeed.text = iSliderValue.toString();
			//var fActive:Boolean = _cGraph.isAutoGenerateActive();
			//if(false == fActive) _cGraph.setAutoGenerateSpeed(iSpeed);
			//else _cGraph.startAutoGenerate(iSpeed);
			_cGraph.setAutoGenerateSpeed(iSliderValue);
		}
		
		private function onTrendSliderChange(oEvent:SliderEvent):void
		{
			//trace("GraphControl::onTrendSliderChange");
			var oSlider:Slider = oEvent.target as Slider;
			var iSliderValue:int = oSlider.value;
			_txGraphTrend.text = iSliderValue.toFixed(1);
			_cGraph.setTrend(iSliderValue);
		}

		private function onTrendTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onTrendTextChange");
			var txTrend:TextInput = oEvent.target as TextInput;
			var nValue:Number = Number(txTrend.text);
			_cGraph.setTrend(nValue);
		}
		
		private function onCustomIntervalTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onCustomIntervalTextChange");
			var txCustomInterval:TextInput = oEvent.target as TextInput;
			var nValue:Number = Number(txCustomInterval.text);
			castFontColor(txCustomInterval, 0x000000);
			if(isNaN(nValue) == false)
			{
				_cGraph.setGraphInterval(nValue);
			}
		}
		
		private function onGraphIntervalTooSmall(oEvent:GraphEvent):void
		{
			trace("GraphControl::onGraphIntervalTooSmall");
			castFontColor(_txCustomInterval, 0xFF0000);
		}
		
		private function onPercentChangeToleranceSliderChange(oEvent:SliderEvent):void
		{
			//trace("GraphControl::onPercentChangeToleranceSliderChange");
			var oSlider:Slider = oEvent.target as Slider;
			var iValue:uint = oSlider.value;
			_txPercClose.text = iValue.toString();
			_cGraph.setPercentChangeTolerance(iValue);
		}
		
		private function onPercentChangeToleranceTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onPercentChangeToleranceTextChange");
			var txPercChg:TextInput = oEvent.target as TextInput;
			var iValue:Number = uint(txPercChg.text);
			_cGraph.setPercentChangeTolerance(iValue);
		}
		
		private function onPercentHiLoToleranceSliderChange(oEvent:SliderEvent):void
		{
			//trace("GraphControl::onPercentHiLoToleranceSliderChange");
			var oSlider:Slider = oEvent.target as Slider;
			var iValue:uint = oSlider.value;
			_txPercHiLo.text = iValue.toString();
			_cGraph.setPercentHiLoTolerance(iValue);
		}
		
		private function onPercentHiLoToleranceTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onPercentHiLoToleranceTextChange");
			var txPercHiLoChg:TextInput = oEvent.target as TextInput;
			var iValue:Number = uint(txPercHiLoChg.text);
			_cGraph.setPercentHiLoTolerance(iValue);
		}
		
		private function onStartValueTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onStartValueTextChange");
			var txStartValue:TextInput = oEvent.target as TextInput;
			var nValue:Number = Number(txStartValue.text);
			var iColor:uint = 0x000000;
			if(isNaN(nValue) == false)
			if(nValue < MIN_START_PRICE) iColor = 0xFF0000;
			_txCustomInterval.text = txStartValue.text;
			castFontColor(txStartValue, iColor);
		}
		
		private function onDataPointsLimitSliderChange(oEvent:SliderEvent):void
		{
			//trace("GraphControl::onPercentHiLoToleranceSliderChange");
			var oSlider:Slider = oEvent.target as Slider;
			var iValue:uint = oSlider.value;
			_txDataPtsLimit.text = iValue.toString();
			_cGraph.setDataPointsLimit(iValue);
		}
		
		private function onDataPtsLimitTextChange(oEvent:Event):void
		{
			//trace("GraphControl::onDataPtsLimitTextChange");
			var txDataPts:TextInput = oEvent.target as TextInput;
			var iValue:uint = uint(txDataPts.text);
			_cGraph.setDataPointsLimit(iValue);
		}
		
		private function onButtonStartClick(oEvent:MouseEvent):void
		{
			//trace("GraphControl::onButtonStartClick");
			var nStartValue:Number = _txStartValue.text as Number;
			var iDataPoints:uint = _cGraph.getDataPoints().length;
			if(iDataPoints <= 1)	initGraphInputs();
			
			var fHasListener:Boolean = _btnStart.hasEventListener(MouseEvent.CLICK);
			if(true == fHasListener) _btnStart.removeEventListener(MouseEvent.CLICK, onButtonStartClick);
			_btnStart.addEventListener(MouseEvent.CLICK, onButtonStopClick);
			_btnStart.label = "Pause";
			_cGraph.startAutoGenerate(_sdrAutoGenSpeed.value);
			_txStartValue.enabled = false;
			_btnCreateInstantGraph.enabled = false;
			removeSummaryText();
		}
		
		private function onButtonStopClick(oEvent:MouseEvent):void
		{
			//trace("GraphControl::onButtonStopClick");
			var fHasListener:Boolean = _btnStart.hasEventListener(MouseEvent.CLICK);
			if(true == fHasListener) _btnStart.removeEventListener(MouseEvent.CLICK, onButtonStopClick);
			_btnStart.addEventListener(MouseEvent.CLICK, onButtonStartClick);
			_btnStart.label = "Resume";
			_cGraph.stopAutoGenerate();
		}
		
		private function onInstantGraphButtonClick(oEvent:MouseEvent):void
		{
			//trace("GraphControl::onInstantGraphButtonClick");
			var iDataPoints:uint = uint(_txDataPtsLimit.text);
			_cGraph.reset();
			initGraphInputs();
			_cGraph.setDataPointsLimit(iDataPoints);
			_cGraph.createInstantRandomGraph(iDataPoints);
			removeSummaryText();
		}
		
		private function castFontColor(txText:TextInput, iColor:uint):void
		{
			var oTxtFmt:TextFormat = new TextFormat();
			oTxtFmt.color = iColor;
			txText.setStyle("textFormat", oTxtFmt);
		}
		
		private function onGraphChange(oEvent:GraphEvent):void
		{
			//trace("GraphControl::onGraphChange");
			/*
			if(_rdCustomInterval.selected)
			{
				var nValue:Number = Number(_txCustomInterval.text);
				if(isNaN(nValue) == false)
				{
					var oTxtFmt:TextFormat = _txCustomInterval.getStyle("textFormat") as TextFormat;
					if(oTxtFmt == false)
					if(oTxtFmt.color == "0xFF0000") castFontColor(_txCustomInterval, 0x000000);
					_cGraph.setGraphInterval(nValue);
				}
			}
			*/
		}
		
		private function onGraphCreateComplete(oEvent:GraphEvent):void
		{
			//trace("GraphControl::onGraphCreateComplete");
			
		}
	}
}