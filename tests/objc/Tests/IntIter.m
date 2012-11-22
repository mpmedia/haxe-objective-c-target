#import "IntIter.h"

@implementation IntIter

@synthesize min;
@synthesize max;
- (BOOL) hasNext{
	return self.min < self.max;
}
- (int) next{
	return self.min++;
}
- (id) new:(int)min max:(int)max{
	self = [super init];
	self.min = min;
	self.max = max;
	return self;
}

@end
