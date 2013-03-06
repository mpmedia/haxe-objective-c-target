//
//  Template
//  Tests
//
//  Source generated by Haxe Objective-C target
//

#import "../haxe/Template.h"

@implementation Template

+ (EReg*) splitter:(EReg*)val {
	static EReg *_val;
	if (val == nil) { if (_val == nil) _val = [[EReg alloc] init:[NSMutableString stringWithString:@"(::[A-Za-z0-9_ ()&|!+=/><*.\"-]+::|\\$\\$([A-Za-z0-9_-]+)\\()"] opt:[NSMutableString stringWithString:@""]]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (EReg*) expr_splitter:(EReg*)val {
	static EReg *_val;
	if (val == nil) { if (_val == nil) _val = [[EReg alloc] init:[NSMutableString stringWithString:@"(\\(|\\)|[ \r\n\t]*\"[^\"]*\"[ \r\n\t]*|[!+=/><*.&|-]+)"] opt:[NSMutableString stringWithString:@""]]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (EReg*) expr_trim:(EReg*)val {
	static EReg *_val;
	if (val == nil) { if (_val == nil) _val = [[EReg alloc] init:[NSMutableString stringWithString:@"^[ ]*([^ ]+)[ ]*$"] opt:[NSMutableString stringWithString:@""]]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (EReg*) expr_int:(EReg*)val {
	static EReg *_val;
	if (val == nil) { if (_val == nil) _val = [[EReg alloc] init:[NSMutableString stringWithString:@"^[0-9]+$"] opt:[NSMutableString stringWithString:@""]]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (EReg*) expr_float:(EReg*)val {
	static EReg *_val;
	if (val == nil) { if (_val == nil) _val = [[EReg alloc] init:[NSMutableString stringWithString:@"^([+-]?)(?=\\d|,\\d)\\d*(,\\d*)?([Ee]([+-]?\\d+))?$"] opt:[NSMutableString stringWithString:@""]]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
+ (id) globals:(id)val {
	static id _val;
	if (val == nil) { if (_val == nil) _val = [NSMutableDictionary dictionaryWithObjectsAndKeys:
nil]; }
	else { if (_val != nil) _val = val; }
	return _val;
}
@synthesize expr;
@synthesize context;
@synthesize macros;
@synthesize stack;
@synthesize buf;
- (NSMutableString*) execute:(id)context macros:(id)macros{
	// Optional arguments
	if (!macros) macros = nil;
	
	self.macros = ( (macros == nil) ? [NSMutableDictionary dictionaryWithObjectsAndKeys:
	nil] : macros);
	self.context = context;
	self.stack = [[List alloc] init];
	self.buf = [[StringBuf alloc] init];
	[self run:self.expr];
	return self.buf.b;
}
- (id) resolve:(NSMutableString*)v{
	if ([Reflect hasField:self.context field:v]) return [Reflect field:self.context field:v];
	{
		id _it = [self.stack iterator];
		while ( [_it hasNext] ) do {
			id ctx = [_it next];
			if ([Reflect hasField:ctx field:v]) return [Reflect field:ctx field:v];
		}
	}
	if (v == [NSMutableString stringWithString:@"__current__"]) return self.context;
	return [Reflect field:-TDynamic- field:v];
}
- (List*) parseTokens:(NSMutableString*)data{
	
	List *tokens = [[List alloc] init];
	while ([-TMono- match:data]) {
		id p = [-TMono- matchedPos];
		if (p pos > 0) [tokens add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		[[data substr:0 len:p pos] copy], @"p",
		[YES copy], @"s",
		[nil copy], @"l",
		nil]];
		if ([data charCodeAt:p pos] == 58) {
			[tokens add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
			[[data substr:p pos + 2 len:p len - 4] copy], @"p",
			[NO copy], @"s",
			[nil copy], @"l",
			nil]];
			data = [-TMono- matchedRight];
			continue;
		}
		int parp = p pos + p len;
		int npar = 1;
		while (npar > 0) {
			int c = [data charCodeAt:parp];
			if (c == 40) npar++;
			else if (c == 41) npar--;
			else if (c == nil) @throw [NSMutableString stringWithString:@"Unclosed macro parenthesis"];;
			parp++;
		}
		
		NSMutableArray *params = [[data.substr:p pos + p len len:parp -  (p pos + p len) - 1] split:[NSMutableString stringWithString:@","]];
		[tokens add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		[[-TMono- matched:2] copy], @"p",
		[NO copy], @"s",
		[params copy], @"l",
		nil]];
		data = [data substr:parp len:data.length - parp];
	}
	if (data.length > 0) [tokens add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
	[data copy], @"p",
	[YES copy], @"s",
	[nil copy], @"l",
	nil]];
	return tokens;
}
- (Template*) parseBlock:(List*)tokens{
	
	List *l = [[List alloc] init];
	while (YES) {
		id t = [tokens first];
		if (t == nil) break;
		if (!t s &&  (t p == [NSMutableString stringWithString:@"end"] || t p == [NSMutableString stringWithString:@"else"] || [t p substr:0 len:7] == [NSMutableString stringWithString:@"elseif "])) break;
		[l add:[self parse:tokens]];
	}
	if (l.length == 1) return [l first];
	return [ OpBlock:l];
}
- (Template*) parse:(List*)tokens{
	id t = [tokens pop];
	
	NSMutableString *p = t p;
	if (t s) return [ OpStr:p];
	if (t l != nil) {
		
		List *pe = [[List alloc] init];
		{
			int _g = 0; 
			NSMutableArray *_g1 = t l;
			while (_g < _g1.length) {
				
				NSMutableString *p1 = [_g1 objectAtIndex:_g];
				++_g;
				[pe add:[self parseBlock:[self parseTokens:p1]]];
			}
		}
		return [ OpMacro:p params:pe];
	}
	if ([p substr:0 len:3] == [NSMutableString stringWithString:@"if "]) {
		p = [p substr:3 len:p.length - 3];
		SEL e = [self parseExpr:p];
		
		Template *eif = [self parseBlock:tokens];
		id t1 = [tokens first];
		
		Template *eelse;
		if (t1 == nil) @throw [NSMutableString stringWithString:@"Unclosed 'if'"];;
		if (t1 p == [NSMutableString stringWithString:@"end"]) {
			[tokens pop];
			eelse = nil;
		}
		else if (t1 p == [NSMutableString stringWithString:@"else"]) {
			[tokens pop];
			eelse = [self parseBlock:tokens];
			t1 = [tokens pop];
			if (t1 == nil || t1 p != [NSMutableString stringWithString:@"end"]) @throw [NSMutableString stringWithString:@"Unclosed 'else'"];;
		}
		else {
			t1 p = [t1 p substr:4 len:t1 p.length - 4];
			eelse = [self parse:tokens];
		}
		return [ OpIf:e eif:eif eelse:eelse];
	}
	if ([p substr:0 len:8] == [NSMutableString stringWithString:@"foreach "]) {
		p = [p substr:8 len:p.length - 8];
		SEL e = [self parseExpr:p];
		
		Template *efor = [self parseBlock:tokens];
		id t1 = [tokens pop];
		if (t1 == nil || t1 p != [NSMutableString stringWithString:@"end"]) @throw [NSMutableString stringWithString:@"Unclosed 'foreach'"];;
		return [ OpForeach:e loop:efor];
	}
	if ([-TMono- match:p]) return [ OpExpr:[self parseExpr:p]];
	return [ OpVar:p];
}
- (SEL) parseExpr:(NSMutableString*)data{
	
	List *l = [[List alloc] init];
	
	NSMutableArray *expr = [[NSMutableArray alloc] initWithObjects:data, nil];
	while ([-TMono- match:data]) {
		id p = [-TMono- matchedPos];
		int k = p pos + p len;
		if (p pos != 0) [l add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		[[data substr:0 len:p pos] copy], @"p",
		[YES copy], @"s",
		nil]];
		
		NSMutableString *p1 = [-TMono- matched:0];
		[l add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		[p1 copy], @"p",
		[[p1 indexOf:[NSMutableString stringWithString:@"\""] startIndex:nil] >= 0 copy], @"s",
		nil]];
		data = [-TMono- matchedRight];
	}
	if (data.length != 0) [l add:[NSMutableDictionary dictionaryWithObjectsAndKeys:
	[data copy], @"p",
	[YES copy], @"s",
	nil]];
	
	NSMutableArray *e = [[NSMutableArray alloc] initWithObjects:, nil];
	@try {
		[e replaceObjectAtIndex:0 withObject:[self makeExpr:l]];
		if (![l isEmpty]) @throw [l.first] p;;
	}
	@catch (NSException *s) {
		@throw [[[[NSMutableString stringWithString:@"Unexpected '"] stringByAppendingString:s] stringByAppendingString:[NSMutableString stringWithString:@"' in "]] stringByAppendingString:[expr objectAtIndex:@"0"]];;
	}
	return ^- (int) {
		@try {
			return [[e objectAtIndex:0]];
		}
		@catch (NSException *exc) {
			@throw [[[[NSMutableString stringWithString:@"Error : "] stringByAppendingString:[Std string:exc]] stringByAppendingString:[NSMutableString stringWithString:@" in "]] stringByAppendingString:[expr objectAtIndex:@"0"]];;
		}
		return 0;
	}
}
- (SEL) makeConst:(NSMutableString*)v{
	
	NSMutableArray *v1 = [[NSMutableArray alloc] initWithObjects:v, nil];
	[-TMono- match:[v1 objectAtIndex:0]];
	[v1 replaceObjectAtIndex:0 withObject:[-TMono- matched:[NSNumber numberWithInt:1]]];
	if ([[v1 objectAtIndex:0] charCodeAt:0] == 34) {
		
		NSMutableArray *str = [[NSMutableArray alloc] initWithObjects:[[v1 objectAtIndex:[NSNumber numberWithInt:0]] substr:[NSNumber numberWithInt:1] len:[v1 objectAtIndex:[NSNumber numberWithInt:0]].length - [NSNumber numberWithInt:2]], nil];
		return ^- (NSMutableString*) {
			return [str objectAtIndex:0];
		}
	}
	if ([-TMono- match:[v1 objectAtIndex:0]]) {
		
		NSMutableArray *i = [[NSMutableArray alloc] initWithObjects:[Std parseInt:[v1 objectAtIndex:[NSNumber numberWithInt:0]]], nil];
		return ^- (int) {
			return [i objectAtIndex:0];
		}
	}
	if ([-TMono- match:[v1 objectAtIndex:0]]) {
		
		NSMutableArray *f = [[NSMutableArray alloc] initWithObjects:[Std parseFloat:[v1 objectAtIndex:[NSNumber numberWithInt:0]]], nil];
		return ^- (float) {
			return [f objectAtIndex:0];
		}
	}
	
	NSMutableArray *me = [[NSMutableArray alloc] initWithObjects:self, nil];
	return ^- (id) {
		return [[me objectAtIndex:0] resolve:[v1 objectAtIndex:0]];
	}
}
- (SEL) makePath:(SEL)e l:(List*)l{
	
	NSMutableArray *e1 = [[NSMutableArray alloc] initWithObjects:e, nil];
	id p = [l first];
	if (p == nil || p p != [NSMutableString stringWithString:@"."]) return [e1 objectAtIndex:0];
	[l pop];
	id field = [l pop];
	if (field == nil || !field s) @throw field p;;
	
	NSMutableArray *f = [[NSMutableArray alloc] initWithObjects:field p, nil];
	[-TMono- match:[f objectAtIndex:0]];
	[f replaceObjectAtIndex:0 withObject:[-TMono- matched:[NSNumber numberWithInt:1]]];
	return [self makePath:^- (id) {
		return [Reflect field:[[e1 objectAtIndex:0]] field:[f objectAtIndex:0]];
	} l:l];
}
- (SEL) makeExpr:(List*)l{
	return [self makePath:[self makeExpr2:l] l:l];
}
- (SEL) makeExpr2:(List*)l{
	id p = [l pop];
	if (p == nil) @throw [NSMutableString stringWithString:@"<eof>"];;
	if (p s) return [self makeConst:p p];
	switch (p p){
		case [NSMutableString stringWithString:@"("]:{
			{
				
				NSMutableArray *e1 = [[NSMutableArray alloc] initWithObjects:[self makeExpr:l], nil];
				id p1 = [l pop];
				if (p1 == nil || p1 s) @throw p1 p;;
				if (p1 p == [NSMutableString stringWithString:@")"]) return [e1 objectAtIndex:0];
				
				NSMutableArray *e2 = [[NSMutableArray alloc] initWithObjects:[self makeExpr:l], nil];
				id p2 = [l pop];
				if (p2 == nil || p2 p != [NSMutableString stringWithString:@")"]) @throw p2 p;;
				return ((SEL)($this:(snd ctx.path)) switch (p1 p){
					case [NSMutableString stringWithString:@"+"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] + [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"-"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] - [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"*"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] * [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"/"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] / [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@">"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] > [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"<"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] < [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@">="]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] >= [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"<="]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] <= [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"=="]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] == [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"!="]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] != [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"&&"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] && [[e2 objectAtIndex:0]];
						}}break;
					case [NSMutableString stringWithString:@"||"]:{
						__r__ = ^- (id) {
							return (id)[[e1 objectAtIndex:0]] || [[e2 objectAtIndex:0]];
						}}break;
					default:{
						__r__ = ((SEL)($this:(snd ctx.path)) @throw [[NSMutableString stringWithString:@"Unknown operation "] stringByAppendingString:p1 p];
						return __r__2{
							
							SEL* __r__2}
						}($this))}break;
				}
				return __r__{
					
					SEL* __r__}
				}(self));
			}}break;
		case [NSMutableString stringWithString:@"!"]:{
			{
				
				NSMutableArray *e = [[NSMutableArray alloc] initWithObjects:[self makeExpr:l], nil];
				return ^- (BOOL) {
					id v = [[e objectAtIndex:0]];
					return v == nil || v == NO;
				}
			}}break;
		case [NSMutableString stringWithString:@"-"]:{
			{
				
				NSMutableArray *e = [[NSMutableArray alloc] initWithObjects:[self makeExpr:l], nil];
				return ^- (int) {
					return -[[e objectAtIndex:0]];
				}
			}}break;
	}
	@throw p p;;
	return nil;
}
- (void) run:(Template*)e{
	
	var $e : enum =  (e)
	switch ( $e.index ) {
		
		case 0:
		
		var MATCH e_eOpVar_0 : NSMutableString = $e.params[0]{
			self.buf.b += [Std string:[Std string:[self resolve:e_eOpVar_0]]]}break
		case 1:
		
		var MATCH e_eOpExpr_0 : SEL = $e.params[0]{
			self.buf.b += [Std string:[Std string:[e_eOpExpr_0]]]}break
		case 2:
		
		var MATCH e_eOpIf_2 : Template = $e.params[2], MATCH e_eOpIf_1 : Template = $e.params[1], MATCH e_eOpIf_0 : SEL = $e.params[0]{
			{
				id v = [e_eOpIf_0];
				if (v == nil || v == NO) {
					if (e_eOpIf_2 != nil) [self run:e_eOpIf_2];
				}
				else [self run:e_eOpIf_1];
			}}break
		case 3:
		
		var MATCH e_eOpStr_0 : NSMutableString = $e.params[0]{
			self.buf.b += [Std string:e_eOpStr_0]}break
		case 4:
		
		var MATCH e_eOpBlock_0 : List = $e.params[0]{
			{
				{
					id _it2 = [e_eOpBlock_0 iterator];
					while ( [_it2 hasNext] ) do {
						Template e1 = [_it2 next];
						[self run:e1];
					}
				}
			}}break
		case 5:
		
		var MATCH e_eOpForeach_1 : Template = $e.params[1], MATCH e_eOpForeach_0 : SEL = $e.params[0]{
			{
				id v = [e_eOpForeach_0];
				@try {
					id x = [v iterator];
					if ([x hasNext] == nil) @throw nil;;
					v = x;
				}
				@catch (NSException *e1) {
					@try {
						if ([v hasNext] == nil) @throw nil;;
					}
					@catch (NSException *e2) {
						@throw [[NSMutableString stringWithString:@"Cannot iter on "] stringByAppendingString:[Std string:v]];;
					}
				}
				[self.stack push:self.context];
				id v1 = v;
				{
					id _it3 = v1;
					while ( [_it3 hasNext] ) do {
						id ctx = [_it3 next];
						{
							self.context = ctx;
							[self run:e_eOpForeach_1];
						};
					}
				}
				self.context = [self.stack pop];
			}}break
		case 6:
		
		var MATCH e_eOpMacro_1 : List = $e.params[1], MATCH e_eOpMacro_0 : NSMutableString = $e.params[0]{
			{
				id v = [Reflect field:self.macros field:e_eOpMacro_0];
				
				NSMutableArray *pl = [[NSMutableArray alloc] init];
				
				StringBuf *old = self.buf;
				[pl push:self resolve];
				{
					id _it4 = [e_eOpMacro_1 iterator];
					while ( [_it4 hasNext] ) do {
						Template p = [_it4 next];
						{
							
							var $e5 : enum =  (p)
							switch ( $e5.index ) {
								
								case 0:
								
								var MATCH p_eOpVar_0 : NSMutableString = $e5.params[0]{
									[pl push:[self resolve:p_eOpVar_0]]}break
								default:{
									{
										self.buf = [[StringBuf alloc] init];
										[self run:p];
										[pl push:self.buf.b];
									}}break
							}
						};
					}
				}
				self.buf = old;
				@try {
					self.buf.b += [Std string:[Std string:[Reflect callMethod:self.macros func:v args:pl]]];
				}
				@catch (NSException *e1) {
					
					NSMutableString *plstr = ((NSMutableString)($this:(snd ctx.path)) @try {
						__r__6 = [pl join:[NSMutableString stringWithString:@","]];
					}
					@catch (NSException *e2) {
						__r__6 = [NSMutableString stringWithString:@"???"];
					}
					return __r__6{
						
						NSMutableString* __r__6}
					}(self));
					
					NSMutableString *msg = [[[[[[[NSMutableString stringWithString:@"Macro call "] stringByAppendingString:e_eOpMacro_0] stringByAppendingString:[NSMutableString stringWithString:@"("]] stringByAppendingString:plstr] stringByAppendingString:[NSMutableString stringWithString:@") failed ("]] stringByAppendingString:[Std string:e1]] stringByAppendingString:[NSMutableString stringWithString:@")"]];
					@throw msg;;
				}
			}}break
	}
}
- (id) init:(NSMutableString*)str{
	self = [super init];
	
	List *tokens = [self parseTokens:str];
	self.expr = [self parseBlock:tokens];
	if (![tokens isEmpty]) @throw [[[NSMutableString stringWithString:@"Unexpected '"] stringByAppendingString:[Std string:[tokens.first] s]] stringByAppendingString:[NSMutableString stringWithString:@"'"]];;
	return self;
}

@end
