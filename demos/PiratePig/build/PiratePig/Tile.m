//
//  Tile
//  PiratePig
//
//  Source generated by Haxe Objective-C target
//

#import "Tile.h"

@implementation Tile

@synthesize column;
@synthesize moving;
@synthesize removed;
@synthesize row;
@synthesize type;
- (void) initialize{
	self.moving = NO;
	self.removed = NO;
	self.alpha = 1;
}
- (void) moveTo:(float)duration targetX:(float)targetX targetY:(float)targetY{
	self.moving = YES;
	[UIView beginAnimations:[NSMutableString stringWithString:@"move_to"] context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	self.alpha = 1;
	CGRect rect = self.frame;
	rect.origin.x = targetX;
	rect.origin.y = targetY;
	self.frame = rect;
	[UIView commitAnimations];
}
- (void) remove:(BOOL)animate{
	// Optional arguments
	if (!animate) animate = YES;
	
	self.userInteractionEnabled = NO;
	[self.superview insertSubview:self atIndex:0];
	[UIView beginAnimations:[NSMutableString stringWithString:@"fade_out"] context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	self.alpha = 0;
	CGRect rect = self.frame;
	rect.origin.x = rect.origin.x - rect.size.width / 2;
	rect.origin.y = rect.origin.y - rect.size.height / 2;
	self.frame = rect;
	[UIView commitAnimations];
	self.removed = YES;
}
- (void) animationDidStop:(NSMutableString*)animationID finished:(float)finished context:(id)context{
	if ([animationID isEqualToString:[NSMutableString stringWithString:@"fade_out"]]) [self removeFromSuperview];
	else if ([animationID isEqualToString:[NSMutableString stringWithString:@"move_to"]]) self.moving = NO;
}
- (id) init:(NSMutableString*)imagePath{
	self = [super init];
	[Log trace:[[NSMutableString stringWithString:@"new tile "] stringByAppendingString:imagePath] infos:[NSDictionary dictionaryWithObjectsAndKeys:@"Tile.hx",@"fileName", @"18",@"lineNumber", @"Tile",@"className", @"new",@"methodName", nil]];
	
	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
	[self addSubview:image];
	self.frame =  CGRectMake(image.frame.origin.x, image.frame.origin.y, image.frame.size.width, image.frame.size.height);
	self.backgroundColor = [UIColor redColor];
	self.userInteractionEnabled = YES;
	return self;
}

@end
