//
//  AKWeakItem.h
//  AkimboCore
//
//  Created by Wes Okes on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@interface AKWeakItem : NSObject

@property (weak, atomic) id item;

- (id)initWithItem:(id)anItem;
- (BOOL)itemIsNil;
- (BOOL)itemIsEqual:(id)anItem;

@end
