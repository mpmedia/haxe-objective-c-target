//
//  AppDelegate
//  HelloWorld
//
//  Source generated by Haxe Objective-C target
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;
@synthesize view;
@synthesize label;
@synthesize map;
@synthesize but;
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)didFinishLaunchingWithOptions{
	self.window = [[UIWindow alloc] init];
	
	UIScreen *screen = [UIScreen mainScreen];
	self.window.frame = screen.bounds;
	self.view = [[UIView alloc] init];
	self.view.frame = CGRectMake (0,0,self.window.frame.size.width,self.window.frame.size.height);
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor darkGrayColor];
	self.label = [[UILabel alloc] init];
	self.label.frame = CGRectMake (0,350,self.view.frame.size.width,50);
	self.label.textColor = [UIColor yellowColor];
	self.label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	self.label.font = [UIFont boldSystemFontOfSize:30];
	self.label.text = (NSMutableString*)@"Hello world!";
	[self.view addSubview:self.label];
	self.map = [[CustomMapView alloc] init];
	self.map.frame = CGRectMake (10,10,300,300);
	[self.view addSubview:self.map];
	self.but = [[UIButton alloc] init];
	self.but.frame =  CGRectMake(0, 430, 320, 30);
	[self.but setTitle:(NSMutableString*)@"Locate London" forState: UIControlStateNormal];
	[self.but setTitle:(NSMutableString*)@"...Locate London..." forState: UIControlStateHighlighted];
	[self.view addSubview:self.but];
	self.viewController = [[UIViewController alloc] init];
	self.viewController.view = self.view;
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}
- (void) locateLondon{
	[self.map locateLondon];
}
- (void) applicationDidBecomeActive:(UIApplication*)application{
}
- (void) applicationWillResignActive:(UIApplication*)application{
}

@end
