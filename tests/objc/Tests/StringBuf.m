//
//  StringBuf
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "StringBuf.h"

@implementation StringBuf

@synthesize b;
- (void) add:(id)x{
	self.b += [Std string:x];
}
- (void) addChar:(int)c{
	self.b += [NSMutableString fromCharCode:c];
}
- (void) addSub:(NSMutableString*)s pos:(int)pos len:(int)len{
	// Simulated optional arguments
	if (len == nil) len = nil;
	
	self.b += [s substr:pos len:len];
}
- (NSMutableString*) toString{
	return self.b;
}
- (id) init{
	self = [super init];
	self.b = (NSMutableString*)@"";
	return self;
}

@end
