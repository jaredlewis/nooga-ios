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

- (id)initWithClient:(RKClient *)theClient
{
    self = [super initWithClient:theClient];
    
    if (self) {
        [self initDefaults];
        
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
    if (self.objectingMappingKeyPath == nil || self.objectMapping == nil) {
        return;
    }
    
    //Load the homepage
    NSString *urlPath = [NSString stringWithFormat:@"/%@/public?%@", self.apiPath, [self paramString]];
    
    [self.objectManager loadObjectsAtResourcePath:urlPath delegate:self];
}

- (void)doLoadOperationWithParams:(NSDictionary *)theParams onSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"/%@/%@", self.apiPath, self.readAction];
    NSString *resourcePathWithQueryParams = [resourcePath stringByAppendingQueryParameters:theParams];
    [self.objectManager loadObjectsAtResourcePath:resourcePathWithQueryParams usingBlock:^(RKObjectLoader *loader) {
        NSLog(@"%@", loader);
        
        [self addOperation:loader onSuccess:theSuccessBlock onFailure:theFailureBlock onComplete:theCompleteBlock];
        loader.params = theParams;
        loader.delegate = self;
    }];
    
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
    [super initObjectManager];
    
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/public", self.apiPath]];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/create", self.apiPath] forMethod:RKRequestMethodPOST];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/update", self.apiPath] forMethod:RKRequestMethodPUT];
    [self.objectManager.router routeClass:self.objectClass toResourcePath:[NSString stringWithFormat:@"/%@/delete", self.apiPath] forMethod:RKRequestMethodDELETE];
}

- (void)doRead
{
    
}

- (void)doReadOperationOnSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
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


@end
