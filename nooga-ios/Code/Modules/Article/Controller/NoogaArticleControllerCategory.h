//
//  NoogaArticleModelControllerCategory.h
//  nooga-ios
//
//  Created by Wes Okes on 10/22/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RestKit.h>

@class NoogaArticleViewArticleSection;
@class ArticleApi;
@class Unit;

@interface NoogaArticleControllerCategory : AkimboUITableViewController <AkimboUITableViewControllerSectionDelegate>

@property (nonatomic) ArticleApi *articleApi;
@property (nonatomic) NoogaArticleViewArticleSection *articleSection;
@property (nonatomic) NoogaArticleModelCategory *category;

@end
