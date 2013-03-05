//
//  StringBuf
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "Std.h"
#import "String.h"

@interface StringBuf : HXObject

@property (nonatomic, strong) NSMutableString *b;
- (void) add:(id)x;
- (void) addChar:(int)c;
- (void) addSub:(NSMutableString*)s pos:(int)pos len:(int)len;
- (NSMutableString*) toString;
- (id) init;

@end

