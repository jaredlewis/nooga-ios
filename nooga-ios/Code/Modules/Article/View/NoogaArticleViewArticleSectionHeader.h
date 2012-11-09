//
//  NoogaArticleViewArticleSectionHeader.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/21/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoogaArticleModelCategory;

@interface NoogaArticleViewArticleSectionHeader : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIColor *startColor;
@property (nonatomic) UIColor *endColor;
@property (nonatomic) AkimboDraw *akimboDraw;
@property (nonatomic) NoogaArticleModelCategory *category;

@end
