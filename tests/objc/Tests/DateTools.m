//
//  DateTools
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "DateTools.h"

@implementation DateTools

+ (NSMutableString*) __format_get:(NSDate*)d e:(NSMutableString*)e{
	return ^(NSMutableString*)switch (e){
		case [NSMutableString stringWithString:@"%"]:{
			__r__ = [NSMutableString stringWithString:@"%"]}break;
		case [NSMutableString stringWithString:@"C"]:{
			__r__ = [StringTools lpad:[Std string:[Std _int:[d.getFullYear] / 100]] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"d"]:{
			__r__ = [StringTools lpad:[Std string:[d.getDate]] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"D"]:{
			__r__ = [DateTools __format:d f:[NSMutableString stringWithString:@"%m/%d/%y"]]}break;
		case [NSMutableString stringWithString:@"e"]:{
			__r__ = [Std string:[d.getDate]]}break;
		case [NSMutableString stringWithString:@"H"]:case [NSMutableString stringWithString:@"k"]:{
			__r__ = [StringTools lpad:[Std string:[d.getHours]] c:( (e == [NSMutableString stringWithString:@"H"]) ? [NSMutableString stringWithString:@"0"] : [NSMutableString stringWithString:@" "]) l:2]}break;
		case [NSMutableString stringWithString:@"I"]:case [NSMutableString stringWithString:@"l"]:{
			__r__ = ^(NSMutableString*)int hour = [d.getHours] % 12
			__r__2 = [StringTools lpad:[Std string:( (hour == 0) ? 12 : hour)] c:( (e == [NSMutableString stringWithString:@"I"]) ? [NSMutableString stringWithString:@"0"] : [NSMutableString stringWithString:@" "]) l:2]
			return __r__2{
				
				NSMutableString* __r__2}
			}()}break;
		case [NSMutableString stringWithString:@"m"]:{
			__r__ = [StringTools lpad:[Std string:[d.getMonth] + 1] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"M"]:{
			__r__ = [StringTools lpad:[Std string:[d.getMinutes]] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"n"]:{
			__r__ = [NSMutableString stringWithString:@"\n"]}break;
		case [NSMutableString stringWithString:@"p"]:{
			__r__ = ( ([d.getHours] > 11) ? [NSMutableString stringWithString:@"PM"] : [NSMutableString stringWithString:@"AM"])}break;
		case [NSMutableString stringWithString:@"r"]:{
			__r__ = [DateTools __format:d f:[NSMutableString stringWithString:@"%I:%M:%S %p"]]}break;
		case [NSMutableString stringWithString:@"R"]:{
			__r__ = [DateTools __format:d f:[NSMutableString stringWithString:@"%H:%M"]]}break;
		case [NSMutableString stringWithString:@"s"]:{
			__r__ = [Std string:[Std _int:[d.getTime] / 1000]]}break;
		case [NSMutableString stringWithString:@"S"]:{
			__r__ = [StringTools lpad:[Std string:[d.getSeconds]] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"t"]:{
			__r__ = [NSMutableString stringWithString:@"\t"]}break;
		case [NSMutableString stringWithString:@"T"]:{
			__r__ = [DateTools __format:d f:[NSMutableString stringWithString:@"%H:%M:%S"]]}break;
		case [NSMutableString stringWithString:@"u"]:{
			__r__ = ^(NSMutableString*)int t = [d.getDay]
			__r__3 = ( (t == 0) ? [NSMutableString stringWithString:@"7"] : [Std string:t])
			return __r__3{
				
				NSMutableString* __r__3}
			}()}break;
		case [NSMutableString stringWithString:@"w"]:{
			__r__ = [Std string:[d.getDay]]}break;
		case [NSMutableString stringWithString:@"y"]:{
			__r__ = [StringTools lpad:[Std string:[d.getFullYear] % 100] c:[NSMutableString stringWithString:@"0"] l:2]}break;
		case [NSMutableString stringWithString:@"Y"]:{
			__r__ = [Std string:[d.getFullYear]]}break;
		default:{
			__r__ = ^(NSMutableString*)@throw [[[NSMutableString stringWithString:@"Date.format %"] stringByAppendingString:e] stringByAppendingString:[NSMutableString stringWithString:@"- not implemented yet."]];
			return __r__4{
				
				NSMutableString* __r__4}
			}()}break;
	}
	return __r__{
		
		NSMutableString* __r__}
	}();
}
+ (NSMutableString*) __format:(NSDate*)d f:(NSMutableString*)f{
	
	StringBuf *r = [[StringBuf alloc] init];
	int p = 0;
	while (YES) {
		int np = [f.indexOf:[NSMutableString stringWithString:@"%"] startIndex:p];
		if (np < 0) break;
		{
			int len = np - p;
			r.b += ( (len == nil) ? [f.substr:p len:nil] : [f.substr:p len:len]);
		}
		r.b += [Std string:[DateTools __format_get:d e:[f.substr:np + 1 len:1]]];
		p = np + 2;
	}
	{
		int len = f.length - p;
		r.b += ( (len == nil) ? [f.substr:p len:nil] : [f.substr:p len:len]);
	}
	return r.b;
}
+ (NSMutableString*) format:(NSDate*)d f:(NSMutableString*)f{
	return [DateTools __format:d f:f];
}
+ (NSDate*) delta:(NSDate*)d t:(float)t{
	return [NSDatefromTime:[d.getTime] + t];
}
+ (NSMutableArray*) DAYS_OF_MONTH:(NSMutableArray*)val {
	static NSMutableArray *_val;
	if (val == nil) { if (_val == nil) _val = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:31], [NSNumber numberWithInt:28], [NSNumber numberWithInt:31], [NSNumber numberWithInt:30], [NSNumber numberWithInt:31], [NSNumber numberWithInt:30], [NSNumber numberWithInt:31], [NSNumber numberWithInt:31], [NSNumber numberWithInt:30], [NSNumber numberWithInt:31], [NSNumber numberWithInt:30], [NSNumber numberWithInt:31], nil]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (int) getMonthDays:(NSDate*)d{
	int month = [d.getMonth];
	int year = [d.getFullYear];
	if (month != 1) return [-TMono- objectAtIndex:month];
	BOOL isB = year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
	return ( (isB) ? 29 : 28);
}
+ (float) seconds:(float)n{
	return n * 1000.0;
}
+ (float) minutes:(float)n{
	return n * 60.0 * 1000.0;
}
+ (float) hours:(float)n{
	return n * 60.0 * 60.0 * 1000.0;
}
+ (float) days:(float)n{
	return n * 24.0 * 60.0 * 60.0 * 1000.0;
}
+ (id) parse:(float)t{
	float s = t / 1000;
	float m = s / 60;
	float h = m / 60;
	return [NSMutableDictionary dictionaryWithObjectsAndKeys:
	[t % 1000 copy], @"ms",
	[[Std _int:s % 60] copy], @"seconds",
	[[Std _int:m % 60] copy], @"minutes",
	[[Std _int:h % 24] copy], @"hours",
	[[Std _int:h / 24] copy], @"days",
	nil];
}
+ (float) make:(id)o{
	return o ms + 1000.0 *  (o seconds + 60.0 *  (o minutes + 60.0 *  (o hours + 24.0 * o days)));
}

@end
