//
//  EReg
//  Tests
//
//  Source generated by Haxe Objective-C target
//



#import "Array.h"
#import "StringBuf.h"
#import "Std.h"

@interface NSRegularExpression ( EReg )

@property (nonatomic) id r;
@property (nonatomic, strong) NSMutableString *last;
@property (nonatomic) BOOL global;
- (BOOL) match:(NSMutableString*)s;
- (NSMutableString*) matched:(int)n;
- (NSMutableString*) matchedLeft;
- (NSMutableString*) matchedRight;
- (id) matchedPos;
- (NSMutableArray*) split:(NSMutableString*)s;
- (NSMutableString*) replace:(NSMutableString*)s by:(NSMutableString*)by;
- (NSMutableString*) customReplace:(NSMutableString*)s f:(-Function-*)f;
- (id) init:(NSMutableString*)r opt:(NSMutableString*)opt;

@end

