//
//  main.m
//  app_delegate_class
//
//  Source generated by Haxe Objective-C target
//

#import ".h"

@implementation Hash

- (void) set:(NSMutableString*)key value:(id)value{
	[self setObject "-dynamic_param-" ];
}
- (id) get:(NSMutableString*)key{
	return [self objectForKey "-dynamic_param-" ];
}
- (BOOL) exists:(NSMutableString*)key{
	return [self objectForKey "-dynamic_param-" ] != nil;
}
- (BOOL) remove:(NSMutableString*)key{
	return [self removeObjectForKey "-dynamic_param-" ];
}
- (id) keys{
	
	NSMutableArray *a = [self allKeys];
	return [a iterator];
}
- (id) iterator{
	
	NSMutableArray *a = [self allValues];
	
	NSMutableArray *it = [[NSMutableArray alloc] initWithObjects:[a iterator], nil]];
	
	NSMutableArray *me = [[NSMutableArray alloc] initWithObjects:self, nil]];
	return struct {
	hasNext:^(BOOL){
		return [[it objectAtIndex:0] GFA2 .hasNext];
	};
next:^(id){
		return [[me objectAtIndex:0] __Internal GFA2 .__Field "-dynamic_param-" ];
	}} structName;
}
- (NSMutableString*) toString{
	return [self description];
}
- (id) new{
	self = [super init];
	return self;
}

@end
