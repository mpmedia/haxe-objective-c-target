//
//  TestResource
//  Test
//
//  Source generated by Haxe Objective-C target
//

#import "../unit/TestResource.h"

@implementation TestResource

static NSMutableString* STR;
+ (NSMutableString*) STR {
	if (STR == nil) STR = [NSMutableString stringWithString:@"Héllo World !"];
	return STR;
}
+ (void) setSTR:(NSMutableString*)val {
	STR = val;
}
- (void) testResources{
	
	NSMutableArray *names = [Resource listNames];
	[self eq:names.length v2:2 pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"9",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	if ([names hx_objectAtIndex:0] == [NSMutableString stringWithString:@"res1.txt"]) [self eq:[names hx_objectAtIndex:1] v2:[NSMutableString stringWithString:@"res2.bin"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"11",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	else {
		[self eq:[names hx_objectAtIndex:0] v2:[NSMutableString stringWithString:@"res2.bin"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"13",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
		[self eq:[names hx_objectAtIndex:1] v2:[NSMutableString stringWithString:@"res1.txt"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"14",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	}
	[self eq:[Resource getString:[NSMutableString stringWithString:@"res1.txt"]] v2:-TMono- pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"16",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	[self eq:[[Resource getString:[NSMutableString stringWithString:@"res2.bin"]] substr:0 len:2] v2:[NSMutableString stringWithString:@"MZ"] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"22",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	[self eq:[[Resource getBytes:[NSMutableString stringWithString:@"res1.txt"]] compare:[Bytes ofString:-TMono-]] v2:0 pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"24",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
	
	Bytes *b = [Resource getBytes:[NSMutableString stringWithString:@"res2.bin"]];
	
	NSMutableArray *firsts = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:77], [NSNumber numberWithInt:90], [NSNumber numberWithInt:144], [NSNumber numberWithInt:0], [NSNumber numberWithInt:3], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:4], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:255], [NSNumber numberWithInt:255], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:184], nil];
	
	NSMutableArray *lasts = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:214], [NSNumber numberWithInt:82], [NSNumber numberWithInt:3], [NSNumber numberWithInt:26], [NSNumber numberWithInt:44], [NSNumber numberWithInt:78], [NSNumber numberWithInt:69], [NSNumber numberWithInt:75], [NSNumber numberWithInt:79], [NSNumber numberWithInt:0], [NSNumber numberWithInt:28], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
	{
		int _g1 = 0; int _g = firsts.length;
		while (_g1 < _g) {
			int i = _g1++;
			[self eq:[b.b hx_objectAtIndex:i] v2:[firsts hx_objectAtIndex:i] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"29",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
		}
	}
	{
		int _g1 = 0; int _g = lasts.length;
		while (_g1 < _g) {
			int i = _g1++;
			[self eq:[b.b hx_objectAtIndex:b.length - lasts.length + i] v2:[lasts hx_objectAtIndex:i] pos:[NSDictionary dictionaryWithObjectsAndKeys:@"TestResource.hx",@"fileName", @"31",@"lineNumber", @"unit.TestResource",@"className", @"testResources",@"methodName", nil]];
		}
	}
}
- (id) init{
	self = [super init];
	return self;
}

@end
