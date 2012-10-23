//
//  NoogaArticleModelControllerCategory.h
//  nooga-ios
//
//  Created by Wes Okes on 10/22/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "TableViewController.h"

@class NoogaArticleViewArticleSection;
@class ArticleApi;
@class Unit;

@interface NoogaArticleControllerCategory : TableViewController <TableViewControllerSectionDelegate, RKRequestDelegate, RKObjectLoaderDelegate>

@property (nonatomic) ArticleApi *articleApi;
@property (nonatomic) NoogaArticleViewArticleSection *articleSection;
@property (nonatomic) NoogaArticleModelCategory *category;

@property (nonatomic) RKClient *wesClient;
@property (nonatomic) RKObjectManager *unitManager;
@property (nonatomic) Unit *testUnit;

@end
