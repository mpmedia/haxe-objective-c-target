//
//  HashMap
//  Tests
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
+ (void) set:(id)this1 k:(id)k v:(id)v{
	[this1 keys.set:[k hashCode] value:k];
	[this1 values.set:[k hashCode] value:v];
}
+ (id) get:(id)this1 k:(id)k{
	return [this1 values.get:[k hashCode]];
}
+ (BOOL) exists:(id)this1 k:(id)k{
	return [this1 values.exists:[k hashCode]];
}
+ (BOOL) remove:(id)this1 k:(id)k{
	[this1 values.remove:[k hashCode]];
	return [this1 keys.remove:[k hashCode]];
}
+ (id) keys:(id)this1{
	return [this1 keys.iterator];
}
+ (id) iterator:(id)this1{
	return [this1 values.iterator];
}
+ (id) toIMap:(id)this1{
	return this1;
}

@end
