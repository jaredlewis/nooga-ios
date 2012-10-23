//
//  ApiOperation.m
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RKJSONParserJSONKit.h>
#import "ApiOperation.h"

@implementation ApiOperation

@synthesize objectManager;
@synthesize apiPath;
@synthesize objectMapping;
@synthesize objectingMappingKeyPath;
@synthesize objectClass;
@synthesize successBlock;
@synthesize failureBlock;
@synthesize completeBlock;
@synthesize params;
@synthesize sorters;

- (id)init
{
    self = [super init];
    
    if (self) {
        self.params = [[NSMutableDictionary alloc] init];
        self.sorters = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)doOperation:(void(^)(void))theOperationBlock onSuccess:(void(^)(RKObjectLoader * objectLoader, NSArray *objects))theSuccessBlock onFailure:(void(^)(RKObjectLoader *objectLoader, NSError *error))theFailureBlock onComplete:(void(^)(void))theCompleteBlock
{
    self.successBlock = theSuccessBlock;
    self.failureBlock = theFailureBlock;
    self.completeBlock = theCompleteBlock;
    
    if (theOperationBlock) {
        theOperationBlock();
    }
}

- (NSString *)urlEncode:(NSString *)theString
{
    return [theString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)getPostParams
{
    return self.params;
}

- (NSString *)paramString
{
    // Add params
    NSMutableArray *paramArray = [[NSMutableArray alloc] init];
    for (NSString *key in self.params) {
        NSString *encodedValue = [self urlEncode:[self.params objectForKey:key]];
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, encodedValue]];
    }
    
    // Add sorters
    RKJSONParserJSONKit *parser = [[RKJSONParserJSONKit alloc] init];
    [paramArray addObject:[NSString stringWithFormat:@"%@=%@", @"sort", [parser stringFromObject:self.sorters error:nil]]];
    
    // Create url formatted string joined with &
    NSString *paramString = [paramArray componentsJoinedByString:@"&"];
    
    return paramString;
}

- (void)setValue:(NSString *)value forParam:(NSString *)param
{
    [self.params setValue:value forKey:param];
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

////////////////////////////////////////////////////////////
//  Object loader delegate methods
////////////////////////////////////////////////////////////
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (self.successBlock) {
        self.successBlock(objectLoader, objects);
    }
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    if (self.failureBlock) {
        self.failureBlock(objectLoader, error);
    }
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"request = %@ response = %@", request, response);
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    
}

@end
