//
//  NoogaArticleModelArticle.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleModelArticle.h"

@implementation NoogaArticleModelArticle

@synthesize title;
@synthesize content;
@synthesize excerpt;

//Statics
+ (RKObjectMapping *)objectMapper
{

    RKObjectMapping *objectMapper = [RKObjectMapping mappingForClass:[self class]];
    [objectMapper mapKeyPathsToAttributes:
     @"id", @"articleId",
     @"title", @"title",
     @"content", @"content",
     @"excerpt", @"excerpt",
     @"sizes.thumb", @"thumbImage",
     @"sizes.medium", @"mediumImage",
     nil];
    return objectMapper;
}

- (NSString *)description
{
    return self.title;
}

- (NSString *)getThumbImageUrl
{
    return [NSString stringWithFormat:@"http://www.nooga.com%@", self.thumbImage];
}

- (NSString *)getMediumImageUrl
{
    return [NSString stringWithFormat:@"http://www.nooga.com%@", self.mediumImage];
}

@end
