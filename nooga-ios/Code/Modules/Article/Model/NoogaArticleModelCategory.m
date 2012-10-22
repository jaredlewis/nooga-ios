//
//  NoogaArticleModelCategory.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleModelCategory.h"

@implementation NoogaArticleModelCategory

@synthesize name;
@synthesize articles;

+ (RKObjectMapping *)objectMapper
{
    RKObjectMapping *objectMapper = [RKObjectMapping mappingForClass:[self class]];
    [objectMapper mapKeyPathsToAttributes:
     @"name", @"name",
     nil];
    return objectMapper;
}

@end
