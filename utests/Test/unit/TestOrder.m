//
//  TestOrder
//  Test
//
//  Source generated by Haxe Objective-C target
//

#import "../unit/TestOrder.h"

@implementation TestOrder

- (void) testUsing{
	[self eq:[Using3 usingTest:[NSMutableString stringWithString:@"foo"]] v2:[NSMutableString stringWithString:@"3"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestOrder.hx",@"fileName", @"17",@"lineNumber", @"unit.TestOrder",@"className", @"testUsing",@"methodName", nil]];
	
	TestOrder *c =  C1;
	{
		-TMono-++;
		[self eq:[NSMutableString stringWithString:@"TEnum(unit.E2,[])"] v2:[NSMutableString stringWithString:@"TEnum(unit.E2,[])"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestOrder.hx",@"fileName", @"21",@"lineNumber", @"unit.TestOrder",@"className", @"testUsing",@"methodName", nil]];
	}
	[self eq:c v2: C1 pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestOrder.hx",@"fileName", @"22",@"lineNumber", @"unit.TestOrder",@"className", @"testUsing",@"methodName", nil]];
}
- (id) init{
	self = [super init];
	return self;
}

@end
