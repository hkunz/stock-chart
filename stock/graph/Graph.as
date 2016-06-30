package stock.graph
{
	import flash.display.Sprite;
	import stock.graph.DataPoint;
	
	public class Graph extends Sprite
	{
		protected var _iWidth:uint;
		protected var _iHeight:uint;
		protected var _nMaxPoint:Number;
		protected var _nMinPoint:Number;
		protected var _nMaxGraphPoint:Number;
		protected var _nMinGraphPoint:Number;
		protected var _nGraphInterval:Number;
		protected var _aDataPoints:Array;
		protected var _iDataPoints:uint;
		protected var _iPointOffset:uint;
		
		public function Graph()
		{
			//trace("Graph::Graph");
	
		}
		
		public function setDimensions(iWidth:uint, iHeight:uint):void
		{
			//trace("BasicGraph::setDimensions(" + iWidth + "," + iHeight + ")");
			_iWidth = iWidth;
			_iHeight = iHeight;
		}
		
		public function create():void
		{
			//trace("SquareTrendGraph::create");
			//createGraphBackground();
			createGraphContent();
		}
		
		public function setDataPointsRange(nMin:Number, nMax:Number):void {_nMinPoint=nMin;_nMaxPoint=nMax;}
		public function setDataPoints(aPoints:Array):void {_aDataPoints = aPoints;}
		public function getDataPoints():Array {return _aDataPoints;}
		public function setGraphInterval(nInterval:Number):void {_nGraphInterval = nInterval;}
		public function setDataPointsLimit(iDataPoints:uint, iOffset:uint=0):void {_iDataPoints=iDataPoints;_iPointOffset=iOffset;}
		protected function createGraphContent():void {}
	}
}