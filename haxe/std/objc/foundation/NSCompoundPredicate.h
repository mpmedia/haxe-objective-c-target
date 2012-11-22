/*	NSCompoundPredicate.h
	Copyright (c) 2004-2012, Apple Inc. All rights reserved.
*/

#import <Foundation/NSPredicate.h>

@class NSArray;

// Compound predicates are predicates which act on the results of evaluating other operators. We provide the basic boolean operators: AND, OR, and NOT.

typedef NS_ENUM(NSUInteger, NSCompoundPredicateType) {
    NSNotPredicateType = 0, 
    NSAndPredicateType,
    NSOrPredicateType,
};

NS_CLASS_AVAILABLE(10_4, 3_0)
extern class NSCompoundPredicate : NSPredicate {
    @private
    void *_reserved2;
    NSUInteger _type;
    NSArray *_subpredicates;
}

- (id)initWithType:(NSCompoundPredicateType)type subpredicates:(NSArray *)subpredicates;

- (NSCompoundPredicateType)compoundPredicateType;
- (NSArray *)subpredicates;

/*** Convenience Methods ***/
+ (NSPredicate *)andPredicateWithSubpredicates:(NSArray *)subpredicates;
+ (NSPredicate *)orPredicateWithSubpredicates:(NSArray *)subpredicates;
+ (NSPredicate *)notPredicateWithSubpredicate:(NSPredicate *)predicate;
}

