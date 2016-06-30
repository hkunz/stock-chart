package stock.events
{
	import flash.events.Event;

	public class GraphEvent extends Event
	{
		public static const MAX_VALUE_EXCEEDED:String = "maxValueExceeded";
		public static const MIN_VALUE_EXCEEDED:String = "minValueExceeded";
		public static const CREATE_COMPLETE:String = "createComplete";
		public static const INAPPLICABLE_INTERVAL:String = "inapplicableInterval";
		public static const GRAPH_CHANGE:String = "graphChange";
		
		public function GraphEvent(sType:String, fBubbles:Boolean=false, fCancelable:Boolean=false)
		{
			super(sType, fBubbles, fCancelable);
		}
		
		public override function clone():Event
		{
			return new GraphEvent(type, bubbles, cancelable);
		}
	}
}