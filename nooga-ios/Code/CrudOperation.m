//
//  CrudOperation.m
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "CrudOperation.h"

@implementation CrudOperation

@synthesize objectManager;
@synthesize objectMapping;
@synthesize objectingMappingKeyPath;
@synthesize objectClass;

- (id)initWithClient:(RKClient *)theClient
{
    self = [super initWithClient:theClient];
    
    if (self) {
        [self initDefaults];
        [self initObjectManager];
    }
    
    return self;
}

- (void)initDefaults
{
    [super initDefaults];
    self.createAction = @"create";
    self.readAction = @"read";
    self.updateAction = @"update";
    self.deleteAction = @"delete";
}

- (void)doLoad
{
    
}

- (void)doLoadOperationOnSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
{
    
}

- (void)doCreateWithItem:(id)item;
{
    [self initObjectManager];
    
    [self.objectManager postObject:item delegate:self];
}

- (void)doCreateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock
{
//    __block CrudOperation *blocksafeSelf = self;
//    [self doOperation:^{
//        [blocksafeSelf doCreateWithItem:item];
//    } onSuccess:theSuccessBlock onFailure:theFailureBlock onComplete:theCompleteBlock];
}

- (void)initObjectManager
{
    //Create a mapping provider
    self.objectManager = [[RKObjectManager alloc] initWithBaseURL:self.client.baseURL];
    [self.objectManager setClient:self.client];
    
    //Article Mapping
    [self.objectManager.mappingProvider setObjectMapping:self.objectMapping forKeyPath:self.objectingMappingKeyPath];
    [self.objectManager.mappingProvider setSerializationMapping:[self.objectMapping inverseMapping] forClass:self.objectClass];
    
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/public", self.apiPath]];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/create", self.apiPath] forMethod:RKRequestMethodPOST];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/update", self.apiPath] forMethod:RKRequestMethodPUT];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/delete", self.apiPath] forMethod:RKRequestMethodDELETE];
}

- (void)doRead
{
    if (self.objectingMappingKeyPath == nil || self.objectMapping == nil) {
        return;
    }
    
    [self initObjectManager];
    
    //Load the homepage
    NSString *urlPath = [NSString stringWithFormat:@"/%@/public?%@", self.apiPath, [self paramString]];
    
    [self.objectManager loadObjectsAtResourcePath:urlPath delegate:self];
}

- (void)doReadOperationOnSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock
{
    __block CrudOperation *blocksafeSelf = self;
    [self doOperation:^{
        [blocksafeSelf doRead];
    } onSuccess:theSuccessBlock onFailure:theFailureBlock onComplete:theCompleteBlock];
}

- (void)doUpdateWithItem:(id)item
{
    [self initObjectManager];
    
    [self.objectManager putObject:item delegate:self];
}

- (void)doUpdateOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock
{
    __block CrudOperation *blocksafeSelf = self;
    [self doOperation:^{
        [blocksafeSelf doUpdateWithItem:item];
    } onSuccess:theSuccessBlock onFailure:theFailureBlock onComplete:theCompleteBlock];
}

- (void)doDeleteWithItem:(id)item
{
    [self initObjectManager];
    
//    [self.objectManager deleteObject:item usingBlock:^(RKObjectLoader *loader) {
//        loader.params = @{@"id":[loader.targetObject valueForKey:@"id"]};
//    }];
}

- (void)doDeleteOperationForItem:(id)item onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock
{
    __block CrudOperation *blocksafeSelf = self;
    [self doOperation:^{
        [blocksafeSelf doDeleteWithItem:item];
    } onSuccess:theSuccessBlock onFailure:theFailureBlock onComplete:theCompleteBlock];
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
//    if (self.successBlock) {
//        self.successBlock(objectLoader, objects);
//    }
//    
//    if (self.completeBlock) {
//        self.completeBlock();
//    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
//    if (self.failureBlock) {
//        self.failureBlock(objectLoader, error);
//    }
//    
//    if (self.completeBlock) {
//        self.completeBlock();
//    }
}

@end
