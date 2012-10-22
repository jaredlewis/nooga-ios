//
//  NSMutableArray+AK.m
//  AkimboCore
//
//  Created by Wes Okes on 8/23/12.
//
//

#import "NSMutableArray+AK.h"
#import <objc/runtime.h>

@implementation NSMutableArray (AK)

@dynamic anotherProperty;
static char anotherPropertyKey;

- (void)setAnotherProperty:(NSString *)anotherProperty
{
    objc_setAssociatedObject(self, &anotherPropertyKey, anotherProperty, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)anotherProperty
{
    return objc_getAssociatedObject(self, &anotherPropertyKey);
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, objects.count)];
    [self insertObjects:objects atIndexes:[[NSIndexSet alloc] initWithIndexSet:indexSet]];
}

- (void)prependWith:(NSArray *)objects
{
    [self insertObjects:objects atIndex:0];
}

@end
