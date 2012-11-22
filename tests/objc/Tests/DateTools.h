

#import "String.h"
#import "Date.h"
#import "StringTools.h"
#import "Std.h"
#import "DateTools.h"
#import "Int.h"
#import "StringBuf.h"
#import "Array.h"
#import "Float.h"

@interface DateTools : NSObject

+ (NSMutableString*) __format_get:(NSDate*)d e:(NSMutableString*)e;
+ (NSMutableString*) __format:(NSDate*)d f:(NSMutableString*)f;
+ (NSMutableString*) format:(NSDate*)d f:(NSMutableString*)f;
+ (NSDate*) delta:(NSDate*)d t:(float)t;
+ (NSMutabeArray*) DAYS_OF_MONTH:(NSMutabeArray*)val;
+ (int) getMonthDays:(NSDate*)d;
+ (float) seconds:(float)n;
+ (float) minutes:(float)n;
+ (float) hours:(float)n;
+ (float) days:(float)n;
+ (id) parse:(float)t;
+ (float) make:(id)o;

@end
