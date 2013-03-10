//
//  IntMap
//  Test
//
//  Source generated by Haxe Objective-C target
//

#import "../../haxe/ds/IntMap.h"

@implementation NSMutableDictionary ( IntMap )

- (void) set:(int)key value:(id)value{
	[self setObject:value forKey:[NSString stringWithFormat:@"%i",key]];
}
- (id) get:(int)key{
	return [self objectForKey:[NSString stringWithFormat:@"%i",key]];
}
- (BOOL) exists:(int)key{
	return [self objectForKey:[NSString stringWithFormat:@"%i",key]] != nil;
}
- (BOOL) remove:(int)key{
	if ([self exists:key]) {
		[self removeObjectForKey:[NSString stringWithFormat:@"%i",key]];
		return YES;
	}
	return NO;
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
