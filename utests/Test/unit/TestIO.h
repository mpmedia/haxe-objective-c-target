//
//  TestIO
//  Test
//
//  Source generated by Haxe Objective-C target
//



#import "../Std.h"
#import "../Array.h"
#import "../haxe/io/Bytes.h"
#import "../haxe/io/BytesOutput.h"
#import "../String.h"
#import "../haxe/io/BytesInput.h"
#import "../unit/Test.h"

@interface TestIO : Test 

- (void) test;
- (void) excv:(SEL)f e:(id)e pos:(id)pos;
- (void) check:(BOOL)endian;
- (void) testBytesBounds;
- (id) init;

@end

