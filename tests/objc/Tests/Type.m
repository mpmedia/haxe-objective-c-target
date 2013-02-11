//
//  Type
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "Type.h"

@implementation Type

+ (Class*) getClass:(id)o{
	if (o == nil || ![Reflect isObject:o]) return nil;
	id c = [o __GetClass];
	{
		
		NSMutableString *_g = [c toString];
		switch (_g){
			case (NSMutableString*)@"__Anon":{
				return nil}break;
			case (NSMutableString*)@"Class":{
				return nil}break;
		}
	}
	return c;
}
+ (Enum*) getEnum:(EnumValue*)o{
	if (o == nil) return nil;
	return [o __GetClass];
}
+ (Class*) getSuperClass:(Class*)c{
	if (c == nil) return nil;
	return [c superclass];
}
+ (NSMutableString*) getClassName:(Class*)c{
	if (c == nil) return nil;
	return NSStringFromClass([c class]);
}
+ (NSMutableString*) getEnumName:(Enum*)e{
	return [e __ToString];
}
+ (Class*) resolveClass:(NSMutableString*)name{
	
	Class *result = NSClassFromString ( name );
	return result;
}
+ (Enum*) resolveEnum:(NSMutableString*)name{
	
	Class *result = [TAbstractDecl Resolve:name];
	if (result != nil && ![result __IsEnum]) return nil;
	return result;
}
+ (id) createInstance:(Class*)cl args:(NSMutableArray*)args{
	if (cl != nil) return [[cl alloc] initFromArray:args];
	return nil;
}
+ (id) createEmptyInstance:(Class*)cl{
	return [cl alloc];
}
+ (id) createEnum:(Enum*)e constr:(NSMutableString*)constr params:(NSMutableArray*)params{
	// Simulated optional arguments
	if (params == nil) params = nil;
	
	if ([e mConstructEnum] != nil) return [e mConstructEnum:constr :params];
	return nil;
}
+ (id) createEnumIndex:(Enum*)e index:(int)index params:(NSMutableArray*)params{
	// Simulated optional arguments
	if (params == nil) params = nil;
	
	
	NSMutableString *c = [[Type getEnumConstructs:e] objectAtIndex:index];
	if (c == nil) @throw [index stringByAppendingString:(NSMutableString*)@" is not a valid enum constructor index"];;
	return [Type createEnum:e constr:c params:params];
}
+ (NSMutableArray*) getInstanceFields:(Class*)c{
	return [c GetInstanceFields];
}
+ (NSMutableArray*) getClassFields:(Class*)c{
	return [c GetClassFields];
}
+ (NSMutableArray*) getEnumConstructs:(Enum*)e{
	return [e GetClassFields];
}
+ (Type*) typeof:(id)v{
	if (v == nil) return  TNull;
	return  TNull;
}
+ (BOOL) enumEq:(id)a b:(id)b{
	return a == b;
}
+ (NSMutableString*) enumConstructor:(EnumValue*)e{
	return [e __Tag];
}
+ (NSMutableArray*) enumParameters:(EnumValue*)e{
	
	NSMutableArray *result = (NSMutableArray*)[e __EnumParams];
	return ( (result == nil) ? [[NSMutableArray alloc] initWithObjects:, nil] : result);
}
+ (int) enumIndex:(EnumValue*)e{
	return [e __Index];
}
+ (NSMutableArray*) allEnums:(Enum*)e{
	
	NSMutableArray *names = (NSMutableArray*)[e GetClassFields];
	
	NSMutableArray *enums = (NSMutableArray*)[[NSMutableArray alloc] init];
	{
		int _g = 0;
		while (_g < names.length) {
			
			NSMutableString *name = [names objectAtIndex:_g];
			++_g;
			@try {
				id result = [e mConstructEnum:name :nil];
				[enums push:result];
			}
			@catch (NSException *invalidArgCount) {
			}
		}
	}
	return enums;
}

@end
