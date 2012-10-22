//
//  NoogaArticleViewArticleSectionHeader.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/21/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FireplugDraw.h"

@interface NoogaArticleViewArticleSectionHeader : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIColor *startColor;
@property (nonatomic) UIColor *endColor;
@property (nonatomic) FireplugDraw *fireplugDraw;

@end
