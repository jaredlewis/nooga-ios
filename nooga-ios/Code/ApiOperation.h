//
//  ApiOperation.h
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ApiOperation : NSObject <RKRequestDelegate, RKObjectLoaderDelegate>

@property (nonatomic) RKObjectManager *objectManager;
@property (nonatomic) NSString *apiPath;
@property (nonatomic) RKObjectMapping *objectMapping;
@property (nonatomic) NSString *objectingMappingKeyPath;
@property (nonatomic) Class objectClass;
@property (nonatomic, copy) void(^successBlock)(RKObjectLoader *objectLoader, NSArray *objects);
@property (nonatomic, copy) void(^failureBlock)(RKObjectLoader *objectLoader, NSError *error);
@property (nonatomic, copy) void(^completeBlock)(void);
@property (nonatomic) NSMutableDictionary *params;
@property (nonatomic) NSMutableArray *sorters;

- (void)doOperation:(void(^)(void))theOperationBlock onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;

- (NSString *)paramString;
- (NSDictionary *)getPostParams;

- (void)setValue:(NSString *)value forParam:(NSString *)param;
- (void)addSorterProperty:(NSString *)property ascending:(BOOL)isAscending;

@end
