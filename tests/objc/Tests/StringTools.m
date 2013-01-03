//
//  StringTools
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "StringTools.h"

@implementation StringTools

+ (NSMutableString*) urlEncode:(NSMutableString*)s{
	return [s stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}
+ (NSMutableString*) urlDecode:(NSMutableString*)s{
	return [s stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSMutableString*) htmlEscape:(NSMutableString*)s quotes:(BOOL)quotes{
	if (quotes==nil) quotes=nil;
	s = [[[[[[s componentsSeparatedByString:@"&"].join:@"&amp;"] componentsSeparatedByString:@"<"].join:@"&lt;"] componentsSeparatedByString:@">"].join:@"&gt;"];
	return ( (quotes) ? [[[[s componentsSeparatedByString:@"\""].join:@"&quot;"] componentsSeparatedByString:@"'"].join:@"&#039;"] : s);
}
+ (NSMutableString*) htmlUnescape:(NSMutableString*)s{
	return [[[[[[[[[[s componentsSeparatedByString:@"&gt;"].join:@">"] componentsSeparatedByString:@"&lt;"].join:@"<"] componentsSeparatedByString:@"&quot;"].join:@"\""] componentsSeparatedByString:@"&#039;"].join:@"'"] componentsSeparatedByString:@"&amp;"].join:@"&"];
}
+ (BOOL) startsWith:(NSMutableString*)s start:(NSMutableString*)start{
	return slength >= startlength && [s substringWithRange:0 len:startlength] == start;
}
+ (BOOL) endsWith:(NSMutableString*)s end:(NSMutableString*)end{
	int elen = endlength;
	int slen = slength;
	return slen >= elen && [s substringWithRange:slen - elen len:elen] == end;
}
+ (BOOL) isSpace:(NSMutableString*)s pos:(int)pos{
	int c = [s characterAtIndex:pos];
	return c >= 9 && c <= 13 || c == 32;
}
+ (NSMutableString*) ltrim:(NSMutableString*)s{
	int l = slength;
	int r = 0;
	while (r < l && [StringTools isSpace:s pos:r]) r++;
	if (r > 0) return [s substringWithRange:r len:l - r]
	else return s;
	return nil;
}
+ (NSMutableString*) rtrim:(NSMutableString*)s{
	int l = slength;
	int r = 0;
	while (r < l && [StringTools isSpace:s pos:l - r - 1]) r++;
	if (r > 0) return [s substringWithRange:0 len:l - r]
	else return s;
	return nil;
}
+ (NSMutableString*) trim:(NSMutableString*)s{
	return [StringTools ltrim:[StringTools rtrim:s]];
}
+ (NSMutableString*) lpad:(NSMutableString*)s c:(NSMutableString*)c l:(int)l{
	if (clength <= 0) return s;
	while (slength < l) s = c + s;
	return s;
}
+ (NSMutableString*) rpad:(NSMutableString*)s c:(NSMutableString*)c l:(int)l{
	if (clength <= 0) return s;
	while (slength < l) s = s + c;
	return s;
}
+ (NSMutableString*) replace:(NSMutableString*)s sub:(NSMutableString*)sub by:(NSMutableString*)by{
	return [s replaceOccurrencesOfString:sub withString:by options:nil range:nil];
}
+ (NSMutableString*) hex:(int)n digits:(int)digits{
	if (digits==nil) digits=nil;
	
	NSMutableString *s = @"";
	
	NSMutableString *hexChars = @"0123456789ABCDEF";
	do {
		s = [[hexChars characterAtIndex:n & @"15"] stringByAppendingString:s];
		n >>>= 4;
	}while (n > 0);
	if (digits != nil) while (slength < digits) s = [@"0" stringByAppendingString:s];
	return s;
}

@end
