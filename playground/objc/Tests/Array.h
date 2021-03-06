//
//  Array
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "Array.h"

@interface NSMutableArray ( Array )

@property (nonatomic) int length;
- (NSMutableArray*) concat:(NSMutableArray*)a;
- (NSMutableArray*) copy;
- (void) insert:(int)pos x:(id)x;
- (NSMutableString*) join:(NSMutableString*)sep;
- (NSMutableString*) toString;
- (id) pop;
- (int) push:(id)x;
- (void) unshift:(id)x;
- (BOOL) remove:(id)x;
- (void) reverse;
- (id) shift;
- (NSMutableArray*) slice:(int)pos end:(int)end;
- (void) sort:(SEL)f;
- (NSMutableArray*) splice:(int)pos len:(int)len;
- (id) iterator;
- (NSMutableArray*) map:(SEL)f;
- (NSMutableArray*) filter:(SEL)f;
- (id) init;

@end

