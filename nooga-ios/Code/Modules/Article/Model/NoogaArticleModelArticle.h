//
//  NoogaArticleModelArticle.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "NoogaModel.h"

@interface NoogaArticleModelArticle : NoogaModel

@property (nonatomic) NSString *articleId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *excerpt;

//Images
@property (nonatomic) NSString *thumbImage;
@property (nonatomic) NSString *mediumImage;

- (NSString *)getThumbImageUrl;
- (NSString *)getMediumImageUrl;

@end
