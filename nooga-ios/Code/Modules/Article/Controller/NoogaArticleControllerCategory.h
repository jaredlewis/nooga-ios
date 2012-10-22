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

@interface NoogaArticleControllerCategory : TableViewController <RKRequestDelegate, RKObjectLoaderDelegate, TableViewControllerSectionDelegate>

@property (nonatomic) NoogaArticleViewArticleSection *articleSection;
@property (nonatomic) NoogaArticleModelCategory *category;

@end
