package stock.font
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.display.Stage;

	public class FontEmbed extends Sprite
	{
		[Embed(source="C:/WINDOWS/Fonts/AGENCYB.TTF", fontFamily="HarryFont", fontStyle = "Regular", mimeType="application/x-font-truetype")];
		public var asdf:Class;
		var tf:TextField;

		public function FontEmbed()
		{
			AddText(30, 0x000000, 400,  20, 20);
		}
		public function AddText(_size:int, _color:uint, _TextWidth:int, Xpos:int, Ypos:int):void
		{
			tf = new TextField();
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.multiline = true;
			tf.selectable = false;
			tf.wordWrap = true;
			tf.width = _TextWidth;

			var format:TextFormat = new TextFormat();
			format.font = "HarryFont";
			format.color = _color;
			format.size = _size;
			format.letterSpacing = 2;// spacing between each character
			format.leading = 10;// distance between each lines

			tf.defaultTextFormat = format;
			tf.text = "Hello World! This font is Walkway Black which is not in this fla but is in the local folder(Fonts) it searches for the font runtime";
			addChild(tf);
			//trace(tf);
			//trace(tf.text);
			tf.x = Xpos;
			tf.y = Ypos;
		}
	}
}