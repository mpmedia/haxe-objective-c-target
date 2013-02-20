//
//  CallStack
//  Test
//
//  Source generated by Haxe Objective-C target
//

typedef enum{
	CFunction,
	Module,
	FilePos,
	Method,
	Lambda
} StackItem;


#import "../Array.h"
#import "../String.h"
#import "../StringBuf.h"
#import "../haxe/CallStack.h"
#import "../Std.h"

@interface CallStack : HXObject

+ (NSMutableArray*) exceptionStack;
+ (NSMutableString*) toString:(NSMutableArray*)stack;
+ (void) itemToString:(StringBuf*)b s:(CallStack*)s;

@end
