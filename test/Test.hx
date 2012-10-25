
import objc.ios.ui.UIApplicationDelegate;
import objc.ios.ui.UIResponder;
import objc.ios.ui.UIWebView;
import objc.ios.ui.UILabel;
import objc.ios.ui.UIWindow;
import objc.ios.ui.UIApplication;
import objc.ios.map.MKMapView;


class Test extends UIResponder, implements UIApplicationDelegate {
	
	public var window :UIWindow;
	public var interfaceVar1 :Int;// Generate a @property (nonatomic, strong) NSNumber *float1; + a @synthesizer
	public var interfaceVar2 :Float;
	public var width (getWidth, setWidth) :Int;// Generate a @property (nonatomic, getter=getWidth, setter=setWidth) + a @synthesizer
	
	public function new () {
		
	}
	
	public function applicationDidFinishLaunchingWithOptions (application:UIApplication, didFinishLaunchingWithOptions:NSDictionary) :Bool {
		trace ("Application launched");
		lotsOfArguments (1, 2, 3, 4);
		return true;
	}
	public function applicationDidBecomeActive (application:UIApplication) :Void {}
	public function applicationWillResignActive (application:UIApplication) :Void {}
	public function applicationHandleOpenURL (application:UIApplication, handleOpenURL:NSURL) :Bool {
		return true;
	}
		
	function tests () :Void {
		// declare some random variables
		var a = new Array<String>();
		var aa = [1, 2, 3, 4, 5];
		var b :Int = 5;
		var c :Float = 5.0;
		var d = "xyz";
		var e = true;
		var f :Int;
		var g :Int = cast (5.3, Int);
		var xy = a.length;
		a.push ( "6" );
		
/*		for (i in aa) {
			a.push (Std.string(i));
		}*/
		for (i in 0...5) {
			aa.push ( i );
		}
		
/*		switch (e) {
			case true : null;
			case false : null;
		}*/
		
		if (a.length > 3) {
			f = 3;
		}
		else {
			f = a.length;
		}
		f = a.length > 3 ? 3 : a.length;
		
		var x = new Test().add (1, 1);
		
		var webView = new UIWebView();
		var map = new MKMapView();
			map.frame = new CGRect (10, 10, 200, 200);
			//webView.initWithFrame();
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
	public function lotsOfArguments (arg1:Int, arg2:Int, arg3:Int, arg4:Int) :Void {}
	public function printHello () :Void {
		untyped __objc__("NSLog(@\"testing __objc__\")");
		trace("Hello from Haxe Objective-C");
	}
}
