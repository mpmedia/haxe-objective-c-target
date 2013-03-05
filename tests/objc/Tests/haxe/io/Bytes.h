//
//  Bytes
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "../../haxe/io/Bytes.h"
#import "../../Array.h"
#import "../../haxe/io/Error.h"
#import "../../String.h"
#import "../../StringBuf.h"

@interface Bytes : HXObject

+ (Bytes*) alloc:(int)length;
+ (Bytes*) ofString:(NSMutableString*)s;
+ (Bytes*) ofData:(NSMutableArray*)b;
+ (int) fastGet:(NSMutableArray*)b pos:(int)pos;
@property (nonatomic) int length;
@property (nonatomic, strong) NSMutableArray *b;
- (int) get:(int)pos;
- (void) set:(int)pos v:(int)v;
- (void) blit:(int)pos src:(Bytes*)src srcpos:(int)srcpos len:(int)len;
- (Bytes*) sub:(int)pos len:(int)len;
- (int) compare:(Bytes*)other;
- (NSMutableString*) readString:(int)pos len:(int)len;
- (NSMutableString*) toString;
- (NSMutableString*) toHex;
- (NSMutableArray*) getData;
- (id) init:(int)length b:(NSMutableArray*)b;

@end

