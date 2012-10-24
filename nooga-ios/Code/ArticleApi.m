//
//  ArticleApi.m
//  nooga-ios
//
//  Created by Wes Okes on 10/23/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "ArticleApi.h"
#import "NoogaArticleModelArticle.h"

@implementation ArticleApi

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
    
    self.apiPath = @"article/article-api";
    self.objectingMappingKeyPath = @"records";
    self.objectMapping = [NoogaArticleModelArticle objectMapper];
    self.objectClass = [NoogaArticleModelArticle class];
}

@end
