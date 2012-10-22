//
//  AKObservable.m
//  AkimboCore
//
//  Created by Wes Okes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AKObservable.h"
#import "NSString+AK.h"
#import "NSMutableArray+WeakReferences.h"
#import "AKWeakItem.h"

@implementation AKObservable

static NSArray *suffixes;

@synthesize notifications;
@synthesize delegates;

- (id)init
{
    self = [super init];
    
    if (self) {
        suffixes = @[@"Success", @"Failure", @"Complete"];
        notifications = [[NSMutableArray alloc] init];
        @synchronized(delegates){
            delegates = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

- (void)removeNullDelegates
{
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    @synchronized(self.delegates){
        for (int i = 0; i < self.delegates.count; i++) {
            AKWeakItem *weakItem = [self.delegates objectAtIndex:i];
            if ([weakItem itemIsNil] == YES) {
                [indexSet addIndex:i];
            }
        }
        [self.delegates removeObjectsAtIndexes:indexSet];
    }
}

- (void)addDelegate:(id)aDelegate
{
    [self removeNullDelegates];
    @synchronized(self.delegates){
        AKWeakItem *item = [[AKWeakItem alloc] initWithItem:aDelegate];
        if (![self.delegates containsObject:item]) {
            [self.delegates addObject:item];
        }
    }
}

- (void)removeDelegate:(id)aDelegate
{
    [self removeNullDelegates];

    int itemIndex = -1;
     
    // Loop through weak referenced delegates
    @synchronized(self.delegates){
        for (int i = 0; i < self.delegates.count; i++) {
            AKWeakItem *weakItem = [self.delegates objectAtIndex:i];
            if ([weakItem itemIsEqual:aDelegate]) {
                itemIndex = i;
                break;
            }
        }
        if (itemIndex != -1) {
            [self.delegates removeObjectAtIndex:itemIndex];
        }
    }
}

- (void)callDelegatesWithSelector:(SEL)selector andArguments:(NSArray *)arguments
{
    [self removeNullDelegates];
    for (int i = 0; i < self.delegates.count; i++) {
        AKWeakItem *weakItem = [self.delegates objectAtIndex:i];
        id delegateItem = weakItem.item;
        if ([delegateItem respondsToSelector:selector]) {
            // Build the selector with arguments
            NSMethodSignature *signature  = [delegateItem methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation setTarget:delegateItem];
            [invocation setSelector:selector];
            // 0 is for target, 1 is for selector
            for (int i = 0; i < arguments.count; i++) {
                id argument = [arguments objectAtIndex:i];
                [invocation setArgument:&argument atIndex:i+2];
            }
            
            [invocation invoke];
        }
    }
}

- (void)addNotification:(NSString *)notificationName
{
    [self.notifications addObject:notificationName];
}

- (void)addNotifications:(NSArray *)notificationNames
{
    [self.notifications addObjectsFromArray:notificationNames];
}

- (void)addObserver:(id)observer
{
    [self addObserver:observer forObject:self];
}

- (void)addObserver:(id)observer forObject:(id)observed
{
    for (NSString *notificationName in notifications) {
        for (NSString *suffix in suffixes) {
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"on%@%@:", notificationName, suffix]);
            NSString *realNotificationName = [NSString stringWithFormat:@"%@%@", notificationName, suffix];
            if ([observer respondsToSelector:sel]) {
                [[NSNotificationCenter defaultCenter] addObserver:observer
                                                         selector:sel
                                                             name:realNotificationName
                                                           object:observed];
            }
        }
        
        // Try without suffix for custom notifications
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"on%@:", notificationName]);
        NSString *realNotificationName = [NSString stringWithFormat:@"%@", notificationName];
        if ([observer respondsToSelector:sel]) {
            [[NSNotificationCenter defaultCenter] addObserver:observer
                                                     selector:sel
                                                         name:realNotificationName
                                                       object:observed];
        }
    }
}

- (void)removeObserver:(id)object
{
    [[NSNotificationCenter defaultCenter] removeObserver:object
                                                    name:nil
                                                  object:self];
    
}

- (void)observe:(id)object
{
    if ([object respondsToSelector:@selector(addObserver:)]) {
        [object addObserver:self];
    }
}

- (void)stopObserving:(id)object
{
    if ([object respondsToSelector:@selector(removeObserver:)]) {
        [object removeObserver:self];
    }
}

- (void)postSuccessNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo
{
    [self postCustomNotification:notificationName notificationType:@"Success" withData:userInfo];
}

- (void)postFailureNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo
{
    [self postCustomNotification:notificationName notificationType:@"Failure" withData:userInfo];
}

- (void)postCompleteNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo
{
    [self postCustomNotification:notificationName notificationType:@"Complete" withData:userInfo];
}

- (void)postCustomNotification:(NSString *)notificationName notificationType:(NSString *)notificationType withData:(NSDictionary *)userInfo
{
    userInfo = [userInfo mutableCopy];
    [userInfo setValue:self forKey:@"sender"];
    
    NSString *fullNotificationName = [NSString stringWithFormat:@"%@%@", notificationName.capitalize, notificationType.capitalize];
    
    NSString *message = [NSString stringWithFormat:@"Posting \"%@\" from %@", fullNotificationName, self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FPLogFull"
                                                        object:nil
                                                      userInfo:@{
         @"title":fullNotificationName,
         @"type":notificationType,
         @"module":NSStringFromClass(self.class),
         @"message":message
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:fullNotificationName
                                                        object:self
                                                      userInfo:userInfo];
    
    return;
    NSLog(@"Posting \"%@\"", notificationName);
    [[NSNotificationCenter defaultCenter] postNotificationName:fullNotificationName
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
