package stock.font
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class FontCast
	{
		//private var oTextFormat:TextFormat;
		
		public function FontCast()
		{
			//trace("FontCast::FontCast");
			
		}
		
		public static function castFontVerdana(txText:TextField, iColor:uint=0, iSize:uint=12):void
		{
			var sText = txText.text;
			var oTextFormat:TextFormat = new TextFormat();
			oTextFormat.color = iColor;
			oTextFormat.font = "Verdana";
			oTextFormat.size = iSize;
			oTextFormat.bold = true;
			txText.autoSize = TextFieldAutoSize.LEFT;
			txText.antiAliasType = AntiAliasType.ADVANCED;
			txText.defaultTextFormat = oTextFormat;
			txText.text = sText;
		}
		
		//public static function castFontArial(txText:TextField, iColor:uint=0, iSize:uint=12):void
	}
}