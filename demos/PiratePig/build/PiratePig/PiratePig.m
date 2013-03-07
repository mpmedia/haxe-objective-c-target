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
	self.view.backgroundColor = [UIColor whiteColor];
	self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSMutableString stringWithString:@"background_tile.png"]]];
	CGRect bs = self.background.frame;
	bs.size.width = self.window.frame.size.width;
	self.background.frame = bs;
	self.footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSMutableString stringWithString:@"center_bottom.png"]]];
	CGRect bs1 = self.footer.frame;
	bs1.origin.x = self.window.frame.size.width / 2 - bs1.size.width / 2;
	bs1.origin.y = self.window.frame.size.height - bs1.size.height;
	self.footer.frame = bs1;
	self.game = [[PiratePigGame alloc] init];
	self.game.frame = self.view.frame;
	[self.game resize:320 newHeight:480];
	[self.view addSubview:self.background];
	[self.view addSubview:self.footer];
	[self.view addSubview:self.game];
	self.viewController = [[UIViewController alloc] init];
	self.viewController.view = self.view;
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}
- (void) initialize{
}
- (void) construct{
}
- (void) applicationDidBecomeActive:(UIApplication*)application{
}
- (void) applicationWillResignActive:(UIApplication*)application{
}

@end
