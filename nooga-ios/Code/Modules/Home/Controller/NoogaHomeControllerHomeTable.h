//
//  NoogaHomeControllerHomeTable.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "TableViewController.h"
#import "NoogaArticleViewArticleSection.h"

@interface NoogaHomeControllerHomeTable : TableViewController <RKRequestDelegate, RKObjectLoaderDelegate, TableViewControllerSectionDelegate>

@property (nonatomic) NoogaArticleViewArticleSection *topSection;

@end
