//
//  EReg
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "EReg.h"

@implementation NSRegularExpression ( EReg )

@synthesize r;
@synthesize last;
@synthesize global;
- (BOOL) match:(NSMutableString*)s{
	BOOL p = YES;
	if (p) self.last = s
	else self.last = nil;
	return p;
}
- (NSMutableString*) matched:(int)n{
	
	NSMutableString *m = nil;
	return m;
}
- (NSMutableString*) matchedLeft{
	id p = nil;
	return [self last substringWithRange:0 len:p GFA2 .pos];
}
- (NSMutableString*) matchedRight{
	id p = nil;
	int sz = p GFA2 .pos + p GFA2 .len;
	return [self last substringWithRange:sz len:self lastlength - sz];
}
- (id) matchedPos{
	return nil;
}
- (NSMutableArray*) split:(NSMutableString*)s{
	int pos = 0;
	int len = slength;
	
	NSMutableArray *a = [[NSMutableArray alloc] init];
	BOOL first = YES;
	do {
		id p = nil;
		if (p GFA2 .len == 0 && !first) {
			if (p GFA2 .pos == slength) break;
			p GFA2 .pos += 1;
		}
		[a push:[s substringWithRange:pos len:p GFA2 .pos - pos]];
		int tot = p GFA2 .pos + p GFA2 .len - pos;
		pos += tot;
		len -= tot;
		first = NO;
	}while (self.global);
	[a push:[s substringWithRange:pos len:len]];
	return a;
}
- (NSMutableString*) replace:(NSMutableString*)s by:(NSMutableString*)by{
	
	StringBuf *b = [[StringBuf alloc] init];
	int pos = 0;
	int len = slength;
	
	NSMutableArray *a = [by componentsSeparatedByString:@"$"];
	BOOL first = YES;
	do {
		id p = nil;
		if (p GFA2 .len == 0 && !first) {
			if (p GFA2 .pos == slength) break;
			p GFA2 .pos += 1;
		}
		b.b += [s substringWithRange:pos len:p GFA2 .pos - pos];
		if (a.length > 0) b.b += [Std string:[a objectAtIndex:0]];
		int i = 1;
		while (i < a.length) {
			
			NSMutableString *k = [a objectAtIndex:i];
			id c = [k characterAtIndex:0];
			if (c >= 49 && c <= 57) {
				id p1 = nil;
				if (p1 == nil) {
					[b.b appendString:@"$"];
					b.b += [Std string:k];
				}
				else {
					b.b += [s substringWithRange:p1 GFA2 .pos len:p1 GFA2 .len];
					b.b += [k substringWithRange:1 len:klength - 1];
				}
			}
			else if (c == nil) {
				[b.b appendString:@"$"];
				i++;
				
				NSMutableString *k2 = [a objectAtIndex:i];
				if (k2 != nil && k2length > 0) b.b += [Std string:k2];
			}
			else b.b += [Std string:[@"$" stringByAppendingString:k]];
			i++;
		}
		int tot = p GFA2 .pos + p GFA2 .len - pos;
		pos += tot;
		len -= tot;
		first = NO;
	}while (self.global);
	b.b += [s substringWithRange:pos len:len];
	return b.b;
}
- (NSMutableString*) customReplace:(NSMutableString*)s f:(SEL*)f{
	
	StringBuf *buf = [[StringBuf alloc] init];
	while (YES) {
		if (![self match:s]) break;
		buf.b += [Std string:[self matchedLeft]];
		buf.b += [Std string:[f:self]];
		s = [self matchedRight];
	}
	buf.b += [Std string:s];
	return buf.b;
}
- (id) init:(NSMutableString*)r opt:(NSMutableString*)opt{
	self = [super init];
	
	NSMutableArray *a = [opt componentsSeparatedByString:@"g"];
	self.global = a.length > 1;
	if (self.global) opt = [a join:@""];
	self.r = nil;
	return self;
}

@end
