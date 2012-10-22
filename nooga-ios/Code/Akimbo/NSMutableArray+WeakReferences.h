//
//  NSMutableArray+WeakReferences.h
//  AkimboCore
//
//  Created by Wes Okes on 8/31/12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
@end
