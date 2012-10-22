//
//  NSMutableArray+AK.h
//  AkimboCore
//
//  Created by Wes Okes on 8/23/12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AK)

@property NSString *anotherProperty;

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;
- (void)prependWith:(NSArray *)objects;

@end
