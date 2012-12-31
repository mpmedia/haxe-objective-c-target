//
//  List
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "List.h"

@implementation List

@synthesize h;
@synthesize q;
@synthesize length;
- (void) add:(id)item{
	
	NSMutableArray *x = [[NSMutableArray alloc] initWithObjects:item, nil]];
	if (self.h == nil) self.h = x
	else [self.q objectAtIndex:1] = x;
	self.q = x;
	self.length++;
}
- (void) push:(id)item{
	
	NSMutableArray *x = [[NSMutableArray alloc] initWithObjects:item, self.h, nil]];
	self.h = x;
	if (self.q == nil) self.q = x;
	self.length++;
}
- (id) first{
	return ( (self.h == nil) ? nil : [self.h objectAtIndex:0]);
}
- (id) last{
	return ( (self.q == nil) ? nil : [self.q objectAtIndex:0]);
}
- (id) pop{
	if (self.h == nil) return nil;
	id x = [self.h objectAtIndex:0];
	self.h = [self.h objectAtIndex:1];
	if (self.h == nil) self.q = nil;
	self.length--;
	return x;
}
- (BOOL) isEmpty{
	return self.h == nil;
}
- (void) clear{
	self.h = nil;
	self.q = nil;
	self.length = 0;
}
- (BOOL) remove:(id)v{
	
	NSMutableArray *prev = nil;
	
	NSMutableArray *l = self.h;
	while (l != nil) {
		if ([l objectAtIndex:0] == v) {
			if (prev == nil) self.h = [l objectAtIndex:1]
			else [prev objectAtIndex:1] = [l objectAtIndex:1];
			if (self.q == l) self.q = prev;
			self.length--;
			return YES;
		}
		prev = l;
		l = [l objectAtIndex:1];
	}
	return NO;
}
- (id) iterator{
	return (id)typedef struct {
	h:self.h; hasNext:^(id){
		return self.h != nil;
	}; next:^(id){
		if (self.h == nil) return nil;
		id x = [self.h objectAtIndex:0];
		self.h = [self.h objectAtIndex:1];
		return x;
	}
	} structName;
}
- (NSMutableString*) toString{
	
	StringBuf *s = [[StringBuf alloc] init];
	BOOL first = YES;
	
	NSMutableArray *l = self.h;
	[s.b appendString:@"{"];
	while (l != nil) {
		if (first) first = NO
		else [s.b appendString:@", "];
		s.b += [Std string:[Std string:[l objectAtIndex:0]]];
		l = [l objectAtIndex:1];
	}
	[s.b appendString:@"}"];
	return s.b;
}
- (NSMutableString*) join:(NSMutableString*)sep{
	
	StringBuf *s = [[StringBuf alloc] init];
	BOOL first = YES;
	
	NSMutableArray *l = self.h;
	while (l != nil) {
		if (first) first = NO
		else s.b += [Std string:sep];
		s.b += [Std string:[l objectAtIndex:0]];
		l = [l objectAtIndex:1];
	}
	return s.b;
}
- (List*) filter:(Function*)f{
	
	List *l2 = [[List alloc] init];
	
	NSMutableArray *l = self.h;
	while (l != nil) {
		id v = [l objectAtIndex:0];
		l = [l objectAtIndex:1];
		if ([f:v]) [l2 add:v];
	}
	return l2;
}
- (List*) map:(Function*)f{
	
	List *b = [[List alloc] init];
	
	NSMutableArray *l = self.h;
	while (l != nil) {
		id v = [l objectAtIndex:0];
		l = [l objectAtIndex:1];
		[b add:[f:v]];
	}
	return b;
}
- (id) init{
	self = [super init];
	self.length = 0;
	return self;
}

@end
