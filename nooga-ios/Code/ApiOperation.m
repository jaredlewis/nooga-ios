//
//  ApiOperation.m
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RKJSONParserJSONKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>
#import "ApiOperation.h"

@implementation ApiOperation

@synthesize client;
@synthesize apiPath;
@synthesize params;
@synthesize sorters;
@synthesize operations;

@synthesize objectManager;
@synthesize objectMapping;
@synthesize objectingMappingKeyPath;
@synthesize objectClass;


- (id)initWithClient:(RKClient *)theClient
{
    self = [super init];
    
    if (self) {
        self.client = theClient;
        [self initDefaults];
        [self initObjectManager];
    }
    
    return self;
}

- (void)initDefaults
{
    self.params = [[NSMutableDictionary alloc] init];
    self.sorters = [[NSMutableArray alloc] init];
    self.operations = [[NSMutableDictionary alloc] init];
}

- (void)initObjectManager
{
    //Create a mapping provider
    self.objectManager = [[RKObjectManager alloc] initWithBaseURL:self.client.baseURL];
    [self.objectManager setClient:self.client];
    
    //Article Mapping
    [self.objectManager.mappingProvider setObjectMapping:self.objectMapping forKeyPath:self.objectingMappingKeyPath];
    [self.objectManager.mappingProvider setSerializationMapping:[self.objectMapping inverseMapping] forClass:self.objectClass];
}

- (id)init
{
    self = [self initWithClient:[RKClient sharedClient]];
    return self;
}

- (void)doOperation:(id)theOperationBlock onSuccess:(id) theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
{
    
    if (theOperationBlock) {
        
    }
}

- (void)doGETOperationToApi:(NSString *)resourcePath withParams:(NSDictionary *)theParams onSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
{
    RKRequest *request = [self.client get:resourcePath queryParameters:theParams delegate:self];
    [self addOperation:request
           onSuccess:theSuccessBlock
           onFailure:theFailureBlock
          onComplete:theCompleteBlock];
}

- (void)addOperation:(id)operation onSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock
{
    NSMutableDictionary *callbacks = [[NSMutableDictionary alloc] init];
    [callbacks setValue:operation forKey:@"operation"];
    [callbacks setValue:theSuccessBlock forKey:@"onSuccess"];
    [callbacks setValue:theFailureBlock forKey:@"onFailure"];
    [callbacks setValue:theCompleteBlock forKey:@"onComplete"];
    [self.operations setValue:callbacks forKey:[operation description]];
}

- (NSDictionary *)getOperationCallbacks:(id)operation
{
    return [self.operations objectForKey:[operation description]];
}

- (void)removeOperation:(id)operation
{
    [self.operations removeObjectForKey:[operation description]];
}

- (NSString *)urlEncode:(NSString *)theString
{
    return [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)params
{
    // Add params
    NSMutableDictionary *combinedParams = [params copy];
    [combinedParams setValue:self.sorters forKey:@"sort"];
    
    return combinedParams;
}

- (void)setParam:(NSString *)key value:(NSString *)value;
{
    [self.params setValue:value forKey:key];
}

- (void)addSorterProperty:(NSString *)property ascending:(BOOL)isAscending
{
    NSMutableDictionary *sorter = [[NSMutableDictionary alloc] init];
    [sorter setValue:property forKey:@"property"];
    if (isAscending) {
        [sorter setValue:@"ASC" forKey:@"direction"];
    } else {
        [sorter setValue:@"DESC" forKey:@"direction"];
    }
    [self.sorters addObject:sorter];
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    // Make sure this is a normal request and not an object loader request
    if ([request class] != [RKRequest class]) {
        return;
    }
    
    // Get the callbacks for this request object
    NSDictionary *operationCallbacks = [self getOperationCallbacks:request];
    if ([operationCallbacks objectForKey:@"onSuccess"]) {
        ((void (^)(RKRequest *request, RKResponse *response))[operationCallbacks objectForKey:@"onSuccess"])(request, response);
    }
    if ([operationCallbacks objectForKey:@"onComplete"]) {
        ((void (^)(RKRequest *request, RKResponse *response))[operationCallbacks objectForKey:@"onComplete"])(request, response);
    }
    
    [self removeOperation:request];
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    NSDictionary *operationCallbacks = [self getOperationCallbacks:request];
    if (operationCallbacks == nil) {
        return;
    }
    
    ((void (^)(RKRequest *request, NSError *error))[operationCallbacks objectForKey:@"onFailure"])(request, error);
    ((void (^)(void))[operationCallbacks objectForKey:@"onComplete"])();
    
    [self removeOperation:request];
}


- (void)request:(RKRequest *)request didReceiveData:(NSInteger)bytesReceived totalBytesReceived:(NSInteger)totalBytesReceived totalBytesExpectedToReceive:(NSInteger)totalBytesExpectedToReceive
{
    
}

- (void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response
{
    
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
}

- (void)requestDidCancelLoad:(RKRequest *)request
{
    
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    
}

- (void)requestDidTimeout:(RKRequest *)request
{
    
}

- (void)requestWillPrepareForSend:(RKRequest *)request
{
    
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSDictionary *operationCallbacks = [self getOperationCallbacks:objectLoader];
    if ([operationCallbacks objectForKey:@"onSuccess"]) {
        ((void (^)(RKObjectLoader *objectLoader, NSArray *objects))[operationCallbacks objectForKey:@"onSuccess"])(objectLoader, objects);
    }
    if ([operationCallbacks objectForKey:@"onComplete"]) {
        ((void (^)(RKObjectLoader *objectLoader, NSArray *objects))[operationCallbacks objectForKey:@"onComplete"])(objectLoader, objects);
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

@end
