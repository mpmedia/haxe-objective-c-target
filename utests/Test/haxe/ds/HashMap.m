//
//  HashMap
//  Test
//
//  Source generated by Haxe Objective-C target
//

#import "../../haxe/ds/HashMap.h"

@implementation HashMapImpl

+ (id) _new{
	return [NSMutableDictionary dictionaryWithObjectsAndKeys:
	[[[IntMap alloc] init] copy], @"keys",
	[[[IntMap alloc] init] copy], @"values",
	nil];
}

@end
