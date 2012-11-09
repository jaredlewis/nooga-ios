//
//  AKObservable.h
//  AKimboCore
//
//  Created by Wes Okes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKObservable : NSObject

@property NSMutableArray *notifications;
@property (atomic) NSMutableArray *delegates;
@property (atomic) NSMutableDictionary *listeners;

/**
 * Designated initializer
 */
- (id)init;

- (void)removeNullDelegates;
- (void)addDelegate:(id)aDelegate;
- (void)removeDelegate:(id)aDelegate;
- (void)callDelegatesWithSelector:(SEL)selector andArguments:(NSArray *)arguments;

- (void)addNotification:(NSString *)notificationName;
- (void)addNotifications:(NSArray *)notificationNames;

- (void)addObserver:(id)observer;
- (void)addObserver:(id)observer forObject:(id)observed;
- (void)removeObserver:(id)object;
- (void)observe:(id)object;
- (void)stopObserving:(id)object;

- (void)postSuccessNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo;
- (void)postFailureNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo;
- (void)postCompleteNotification:(NSString *)notificationName withData:(NSDictionary *)userInfo;
- (void)postCustomNotification:(NSString *)notificationName notificationType:(NSString *)notificationType withData:(NSDictionary *)userInfo;

- (void)on:(NSString *)eventName performBlock:(id)theBlock;
- (void)on:(NSString *)eventName performBlock:(id)theBlock withBuffer:(float)bufferTime;
//- (void)fireEvent:(NSString *)eventName, ...;
- (void)fireEvent:(NSString *)eventName withDict:(NSDictionary *)dict;

@end
