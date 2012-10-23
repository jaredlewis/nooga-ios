//
//  CrudOperation.h
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "ApiOperation.h"

@interface CrudOperation : ApiOperation

- (void)doCreateWithItem:(id)item;
- (void)doCreateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;

- (void)doRead;
- (void)doReadOperationOnSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;

- (void)doUpdateWithItem:(id)item;
- (void)doUpdateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;

- (void)doDeleteWithItem:(id)item;
- (void)doDeleteOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;



@end
