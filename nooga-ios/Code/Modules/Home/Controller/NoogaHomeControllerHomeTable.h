//
//  NoogaHomeControllerHomeTable.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "NoogaArticleViewArticleSection.h"

@interface NoogaHomeControllerHomeTable : AkimboUITableViewController <RKRequestDelegate, RKObjectLoaderDelegate, AkimboUITableViewControllerSectionDelegate>

@property (nonatomic) NoogaArticleViewArticleSection *topSection;

@end
