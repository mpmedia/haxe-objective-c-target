//
//  BytesBuffer
//  Tests
//
//  Source generated by Haxe Objective-C target
//



#import "../../objc/foundation/NSData.h"
#import "../../haxe/io/Bytes.h"
#import "../../haxe/io/Error.h"

@interface BytesBuffer : NSObject

@property (nonatomic, strong) NSMutableData *b;
- (void) addByte:(int)byte;
- (void) add:(Bytes*)src;
- (void) addBytes:(Bytes*)src pos:(int)pos len:(int)len;
- (Bytes*) getBytes;
- (id) init;

@end

