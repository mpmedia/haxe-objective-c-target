//
//  FileOutput
//  Tests
//
//  Source generated by Haxe Objective-C target
//



#import "../../haxe/io/Bytes.h"
#import "../../sys/io/FileSeek.h"
#import "../../haxe/io/Output.h"

@interface FileOutput : Output 

@property (nonatomic) id __f;
- (void) writeByte:(int)c;
- (int) writeBytes:(Bytes*)s p:(int)p l:(int)l;
- (void) flush;
- (void) close;
- (void) seek:(int)p pos:(FileSeek*)pos;
- (int) tell;
- (id) init:(id)f;

@end

