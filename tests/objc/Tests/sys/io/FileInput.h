//
//  FileInput
//  App name
//
//  Source generated by Haxe Objective-C target
//



#import "Bytes.h"
#import "FileSeek.h"
#import "Input.h"

@interface FileInput : Input 

@property (nonatomic) id __f;
- (int) readByte;
- (int) readBytes:(Bytes*)s p:(int)p l:(int)l;
- (void) close;
- (void) seek:(int)p pos:(FileSeek*)pos;
- (int) tell;
- (BOOL) eof;
- (id) new:(id)f;

@end

