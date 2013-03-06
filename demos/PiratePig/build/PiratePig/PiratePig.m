//
//  PiratePig
//  PiratePig
//
//  Source generated by Haxe Objective-C target
//

#import "PiratePig.h"

@implementation PiratePig


@synthesize window;
@synthesize viewController;
@synthesize view;
@synthesize background;
@synthesize footer;
@synthesize game;
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)didFinishLaunchingWithOptions{
	[Log trace:[NSMutableString stringWithString:@"Start"] infos:[NSDictionary dictionaryWithObjectsAndKeys:@"PiratePig.hx",@"fileName", @"34",@"lineNumber", @"PiratePig",@"className", @"application",@"methodName", nil]];
	self.window = [[UIWindow alloc] init];
	
	UIScreen *screen = [UIScreen mainScreen];
	self.window.frame = screen.bounds;
	self.view = [[UIView alloc] init];
	self.view.frame = CGRectMake (0,0,self.window.frame.size.width,self.window.frame.size.height);
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor darkGrayColor];
	[self initialize];
	[self construct];
	self.viewController = [[UIViewController alloc] init];
	self.viewController.view = self.view;
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}
- (void) construct{
	[self.view addSubview:self.background];
	[self.view addSubview:self.footer];
	[self.view addSubview:self.game];
}
- (void) initialize{
	self.background = [[[UIImageView alloc] init] initWithImage:[UIImage imageNamed:[NSMutableString stringWithString:@"background_tile.png"]]];
	self.footer = [[[UIImageView alloc] init] initWithImage:[UIImage imageNamed:[NSMutableString stringWithString:@"center_bottom.png"]]];
	self.game = [[PiratePigGame alloc] init];
}
- (void) applicationDidBecomeActive:(UIApplication*)application{
}
- (void) applicationWillResignActive:(UIApplication*)application{
}

@end
