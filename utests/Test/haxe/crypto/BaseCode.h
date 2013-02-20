//
//  BaseCode
//  Test
//
//  Source generated by Haxe Objective-C target
//



#import "../../haxe/io/Bytes.h"
#import "../../Array.h"
#import "../../Std.h"
#import "../../String.h"

@interface BaseCode : HXObject

@property (nonatomic, strong) Bytes *base;
@property (nonatomic) int nbits;
@property (nonatomic, strong) NSMutableArray *tbl;
- (Bytes*) encodeBytes:(Bytes*)b;
- (void) initTable;
- (Bytes*) decodeBytes:(Bytes*)b;
- (NSMutableString*) encodeString:(NSMutableString*)s;
- (NSMutableString*) decodeString:(NSMutableString*)s;
- (id) init:(Bytes*)base;

@end
