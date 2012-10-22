//
//  AKWeakItem.m
//  AkimboCore
//
//  Created by Wes Okes on 9/4/12.
//
//

#import "AKWeakItem.h"

@implementation AKWeakItem

@synthesize item;

- (NSString *)description
{
//    CFIndex rc = CFGetRetainCount((__bridge CFTypeRef)self);
//    return [NSString stringWithFormat:@"%@ (%li) -> %@", [super description], rc, item];
    return [NSString stringWithFormat:@"%@ -> %@", [super description], item];
}

- (id)initWithItem:(id)anItem
{
    self = [self init];
    if (self) {
        item = anItem;
    }
    return self;
}

- (BOOL)itemIsNil
{
    id theItem = item;
    return theItem == nil;
}

- (BOOL)itemIsEqual:(id)anItem
{
    return anItem == item;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:[self class]]) {
        AKWeakItem *weakObject = (AKWeakItem *)object;
        if (self.item == [weakObject item]) {
            return YES;
        }
    }
    if (self.item == object) {
        return YES;
    }
    return NO;
}

@end
