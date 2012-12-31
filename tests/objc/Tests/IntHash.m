//
//  IntHash
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "IntHash.h"

@implementation IntHash

- (void) set:(int)key value:(id)value{
	[self setObject "-dynamic_param-" ];
}
- (id) get:(int)key{
	return [self objectForKey "-dynamic_param-" ];
}
- (BOOL) exists:(int)key{
	return [self objectForKey "-dynamic_param-" ] != nil;
}
- (BOOL) remove:(int)key{
	return [self removeObjectForKey "-dynamic_param-" ];
}
- (id) keys{
	
	NSMutableArray *a = [self allKeys];
	return [a iterator];
}
- (id) iterator{
	
	NSMutableArray *a = [self allValues];
	return [a iterator];
}
- (NSMutableString*) toString{
	return [self description];
}
- (id) init{
	self = [super init];
	return self;
}

@end
