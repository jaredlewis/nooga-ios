//
//  NoogaArticleViewArticleSection.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleViewArticleSection.h"
#import "NoogaArticleViewArticleCell.h"

@implementation NoogaArticleViewArticleSection
@synthesize sizeCell;

- (void)initComponent
{
    [super initComponent];
    [self setCellClass:@"NoogaArticleViewArticleCell"];
    [self setCellIsXib:NO];
    sizeCell = [[NoogaArticleViewArticleCell alloc] init];
}

- (CGFloat)getCellHeight:(id)record
{
    return  [sizeCell getHeightForRecord:record];
}

@end
