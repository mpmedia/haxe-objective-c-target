//import Date;
import objc.ios.ui.UIWebView;
//import objc.ios.ui.UILabel;

@:orientation("portrait")

class Test extends UIWebView, implements TestInterface, implements Interface2 {
	
	public var interfaceVar1 :Int;// Generate a @property (nonatomic, strong) NSNumber *float1; + a @synthesizer
	public var interfaceVar2 :Float;
	public var width (getWidth, setWidth) :Int;// Generate a @property (nonatomic, getter=getWidth, setter=setWidth) + a @synthesizer
	
	public static function main(){
		
		// declare some random variables
		var a = new Array<String>();
		var aa = [1, 2, 3, 4, 5];
		var b :Int = 5;
		var c :Float = 5.0;
		var d = "xyz";
		var e = true;
		var f :Int;
		var g :Int = cast (5.3, Int);
		
		for (i in aa) {
			a.push (Std.string(i));
		}
		
		switch (e) {
			case true : null;
			case false : null;
		}
		
		if (a.length > 3) {
			f = 3;
		}
		else {
			f = a.length;
		}
		
		var x = new Test().add (1, 1);
		
/*		var webView = new UIWebView();
			webView.initWithFrame();*/
	}
	
	function getWidth():Int{return 0;}
	function setWidth(v:Int):Int{return 0;}
	
	
	// Interface methods
	public function add (a:Int, b:Int) :Int {
		return a+b;
	}
	public function minus (a:Int, b:Int) :Int {
		return a-b;
	}
	public function printHello () :Void {
		untyped __objc__("NSLog(@\"testing __objc__\")");
		trace("Hello from Haxe Objective-C");
	}
}
