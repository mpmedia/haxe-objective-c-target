//
//  Timer
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "../haxe/Timer.h"

@implementation Timer

+ (Timer*) delay:(SEL)f time_ms:(int)time_ms{
	
	NSMutableArray *f1 = [[NSMutableArray alloc] initWithObjects:f, nil];
	
	NSMutableArray *t = [[NSMutableArray alloc] initWithObjects:[[Timer alloc] init:time_ms], nil];
	[t objectAtIndex:0].run = ^+ (void) {
		[[t objectAtIndex:0] stop];
		[[f1 objectAtIndex:0]];
	}
	return [t objectAtIndex:0];
}
+ (id) measure:(SEL)f pos:(id)pos{
	// Simulated optional arguments
	if (pos == nil) pos = nil;
	
	float t0 = [Timer stamp];
	id r = [f];
	[Log trace:[[Timer stamp] - t0 stringByAppendingString:(NSMutableString*)@"s"] infos:pos];
	return r;
}
+ (float) stamp{
	return [Sys time];
}
@synthesize nstimer;
@synthesize _id;
- (void) stop{
	if (self._id == nil) return;
	[self.nstimer invalidate];
	self.nstimer = nil;
	self._id = nil;
}
// Defining a dynamic method
- (void) run{
	[Log trace:(NSMutableString*)@"run" infos:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Timer.hx",@"109",@"haxe.Timer",@"run",nil] forKeys:[NSArray arrayWithObjects:@"fileName",@"lineNumber",@"className",@"methodName",nil]]];
}
@synthesize property_run;

- (id) init:(int)time_ms{
	self = [super init];
	self.nstimer = [NSTimer timerWithTimeInterval:time_ms target:self selector:-FClosure--MethDynamic- userInfo:nil repeats:YES];
	return self;
}

@end
