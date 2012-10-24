//
//  ApiOperation.h
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface ApiOperation : NSObject <RKRequestDelegate>

@property (nonatomic) RKClient *client;
@property (nonatomic) NSString *apiPath;
@property (nonatomic) NSMutableDictionary *params;
@property (nonatomic) NSMutableArray *sorters;
@property (nonatomic) NSMutableDictionary *operations;

- (id)initWithClient:(RKClient *)theClient;
- (void)initDefaults

- (void)doOperation:(id)theOperationBlock onSuccess:(id) theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock;

- (void)doGETOperationToApi:(NSString *)resourcePath withParams:(NSDictionary *)theParams onSuccess:(id)theSuccessBlock onFailure:(id)theFailureBlock onComplete:(id)theCompleteBlock;

- (NSString *)paramString;
- (NSDictionary *)getPostParams;

- (void)setParam:(NSString *)key value:(NSString *)value;
- (void)addSorterProperty:(NSString *)property ascending:(BOOL)isAscending;

@end
