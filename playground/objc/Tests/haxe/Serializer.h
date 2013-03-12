//
//  Serializer
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "../haxe/Serializer.h"
#import "../StringBuf.h"
#import "../Std.h"
#import "../StringTools.h"
#import "../Reflect.h"
#import "../Type.h"
#import "../Math.h"
#import "../Class.h"
#import "../String.h"
#import "../Array.h"
#import "../List.h"
#import "../Date.h"
#import "../haxe/ds/StringMap.h"
#import "../haxe/ds/IntMap.h"
#import "../haxe/ds/ObjectMap.h"
#import "../haxe/io/Bytes.h"
#import "../Enum.h"

@interface Serializer : NSObject

+ (BOOL) USE_CACHE:(BOOL)val;
+ (BOOL) USE_ENUM_INDEX:(BOOL)val;
+ (NSMutableString*) BASE64:(NSMutableString*)val;
+ (NSMutableString*) run:(id)v;
@property (nonatomic, strong) StringBuf *buf;
@property (nonatomic, strong) NSMutableArray *cache;
@property (nonatomic, strong) StringMap *shash;
@property (nonatomic) int scount;
@property (nonatomic) BOOL useCache;
@property (nonatomic) BOOL useEnumIndex;
- (NSMutableString*) toString;
- (void) serializeString:(NSMutableString*)s;
- (BOOL) serializeRef:(id)v;
- (void) serializeFields:(id)v;
- (void) serialize:(id)v;
- (void) serializeException:(id)e;
- (id) init;

@end
