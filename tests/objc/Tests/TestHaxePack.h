//
//  TestHaxePack
//  Tests
//
//  Source generated by Haxe Objective-C target
//


#import <Foundation/Foundation.h>

#import "haxe/Timer.h"
#import "haxe/crypto/Md5.h"
#import "haxe/crypto/Sha1.h"
#import "haxe/Resource.h"
#import "haxe/Log.h"
#import "haxe/CallStack.h"
#import "haxe/Serializer.h"
#import "haxe/Unserializer.h"
#import "haxe/Json.h"
#import "haxe/Template.h"

@interface TestHaxePack : NSObject

- (void) testTimer;
- (void) testTimerLoop;
- (void) testCrypto;
- (void) testResources;
- (void) testCallstack;
- (void) testSerialization;
- (id) init;

@end

