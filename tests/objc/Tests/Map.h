//
//  Map
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "haxe/ds/IntMap.h"
#import "haxe/ds/HashMap.h"
#import "haxe/ds/_HashMap/HashMapImpl.h"
#import "haxe/ds/ObjectMap.h"
#import "Map.h"

@interface MapImpl : NSObject


+ (void) set:(id)this1 key:(id)key value:(id)value;
+ (id) get:(id)this1 key:(id)key;
+ (BOOL) exists:(id)this1 key:(id)key;
+ (BOOL) remove:(id)this1 key:(id)key;
+ (id) keys:(id)this1;
+ (id) iterator:(id)this1;
+ (NSMutableString*) toString:(id)this1;
+ (StringMap*) toStringMap:(id)t;
+ (IntMap*) toIntMap:(id)t;
+ (HashMap*) toHashMap:(id)t;
+ (ObjectMap*) toObjectMap:(id)t;
+ (Map*) fromStringMap:(StringMap*)map;
+ (Map*) fromIntMap:(IntMap*)map;
+ (Map*) fromHashMap:(HashMap*)map;
+ (Map*) fromObjectMap:(ObjectMap*)map;

@end

