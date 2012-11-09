//
//  NoogaArticleViewArticleCell.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleModelArticle.h"

@interface NoogaArticleViewArticleCell : AkimboUITableViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) CGRect titleLabelMargin;
@property (nonatomic) UILabel *excerptLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) CGFloat imageViewHeight;
@property (nonatomic) CGRect imageViewMargin;

- (CGFloat)getHeightForRecord:(NoogaArticleModelArticle *)record;

@end
