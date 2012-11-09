//
//  NoogaArticleViewArticleSectionHeader.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/21/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleViewArticleSectionHeader.h"

@implementation NoogaArticleViewArticleSectionHeader

@synthesize titleLabel;
@synthesize startColor;
@synthesize endColor;
@synthesize akimboDraw;
@synthesize category;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 40.0f;
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont fontWithName:@"Stag-Medium" size:16.0f]];
        [titleLabel setTextColor:[UIColor colorWithHex:@"#f2f2f2" alpha:1.0f]];
        akimboDraw = [[AkimboDraw alloc] init];
        startColor = [UIColor colorWithHex:@"#333333" alpha:1.0f];
        endColor = [UIColor colorWithHex:@"#000000" alpha:1.0f];
    }
    return self;
}

- (void)layoutSubviews
{
    [titleLabel sizeToFit];
    CGRect frame = titleLabel.frame;
    frame.origin.x = 5;
    frame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetMidY(frame);
    [titleLabel setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    //Get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Drawing code
    [akimboDraw drawLinearGradientInContext:context withRect:self.bounds andColors:@[self.startColor, self.endColor]];
    
    [titleLabel drawTextInRect:titleLabel.frame];
}

@end
