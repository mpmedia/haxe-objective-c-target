//
//  Timer
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "../haxe/Timer.h"
#import "../haxe/Log.h"
#import "../Sys.h"
#import "../objc/foundation/NSTimer.h"

@interface Timer : NSObject

+ (Timer*) delay:(SEL)f time_ms:(int)time_ms;
+ (id) measure:(SEL)f pos:(id)pos;
+ (float) stamp;
@property (nonatomic, strong) NSTimer *nstimer;
@property (nonatomic) int _id;
- (void) stop;
// Defining a dynamic method
- (void) run;
@property (nonatomic,copy) void(^property_run)();
- (id) init:(int)time_ms;

@end

