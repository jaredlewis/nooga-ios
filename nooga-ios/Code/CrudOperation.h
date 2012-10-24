//
//  CrudOperation.h
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "ApiOperation.h"

@interface CrudOperation : ApiOperation <RKObjectLoaderDelegate>

@property (nonatomic) RKObjectManager *objectManager;
@property (nonatomic) RKObjectMapping *objectMapping;
@property (nonatomic) NSString *objectingMappingKeyPath;
@property (nonatomic) Class objectClass;

@property (nonatomic) NSString *createAction;
@property (nonatomic) NSString *readAction;
@property (nonatomic) NSString *updateAction;
@property (nonatomic) NSString *deleteAction;

- (void)doLoad;
- (void)doLoadOperationOnSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock;

//- (void)doCreateWithItem:(id)item;
//- (void)doCreateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;
//
//- (void)doRead;
//- (void)doReadOperationOnSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock;
//
//- (void)doUpdateWithItem:(id)item;
//- (void)doUpdateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;
//
//- (void)doDeleteWithItem:(id)item;
//- (void)doDeleteOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock;



@end
