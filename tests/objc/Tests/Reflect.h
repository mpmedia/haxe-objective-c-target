//
//  Reflect
//  Tests
//
//  Source generated by Haxe Objective-C target
//



#import "String.h"
#import "Array.h"
#import "Reflect.h"

@interface Reflect : NSObject

+ (id) __meta__:(id)val;
+ (BOOL) hasField:(id)o field:(NSMutableString*)field;
+ (id) field:(id)o field:(NSMutableString*)field;
+ (void) setField:(id)o field:(NSMutableString*)field value:(id)value;
+ (id) getProperty:(id)o field:(NSMutableString*)field;
+ (void) setProperty:(id)o field:(NSMutableString*)field value:(id)value;
+ (id) callMethod:(id)o func:(id)func args:(NSMutableArray*)args;
+ (NSMutableArray*) fields:(id)o;
+ (BOOL) isFunction:(id)f;
+ (int) compare:(id)a b:(id)b;
+ (BOOL) compareMethods:(id)f1 f2:(id)f2;
+ (BOOL) isObject:(id)v;
+ (BOOL) deleteField:(id)o f:(NSMutableString*)f;
+ (id) copy:(id)o;
+ (id) makeVarArgs:(SEL)f;

@end

