//
//  NoogaArticleViewArticleCell.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "NoogaArticleViewArticleCell.h"
#import "NoogaArticleModelArticle.h"

@implementation NoogaArticleViewArticleCell

@synthesize titleLabel;
@synthesize titleLabelMargin;
@synthesize excerptLabel;
@synthesize imageView;
@synthesize imageViewHeight;
@synthesize imageViewMargin;

/////////////////////////////////////////////////////
//  Init Methods
/////////////////////////////////////////////////////
- (void)initComponent
{
    [super initComponent];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initTitleLabel];
    [self initExcerptLabel];
    [self initImageView];
}

- (void)initTitleLabel
{
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [titleLabel setNumberOfLines:0];
    titleLabelMargin = CGRectMake(5, 5, 5, 5);
}

- (void)initExcerptLabel
{
    excerptLabel = [[UILabel alloc] init];
    [excerptLabel setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
    [excerptLabel setNumberOfLines:0];
}

- (void)initImageView
{
    imageViewHeight = 200.0f;
    imageViewMargin = CGRectMake(5, 5, 5, 5);
    imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeCenter];
}


/////////////////////////////////////////////////////
//  Draw Methods
/////////////////////////////////////////////////////
- (void)layoutSubviews
{
    //Call Super
    [super layoutSubviews];
    
    //Create a frame
    CGRect frame;
    
    //Layout the title
    frame = titleLabel.frame;
    frame.origin.x = titleLabelMargin.origin.x;
    frame.origin.y = titleLabelMargin.origin.y;
    frame.size.width = self.bounds.size.width - titleLabelMargin.origin.x - titleLabelMargin.size.width;
    frame.size.height = [self getHeightForTitle:titleLabel.text];
    [titleLabel setFrame:frame];
    
    //Layout the excerpt
    frame = excerptLabel.frame;
    frame.origin.x = titleLabel.frame.origin.x;
    frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height;
    frame.size.width = titleLabel.frame.size.width;
    frame.size.height = [self getHeightForExcerpt:excerptLabel.text];
    [excerptLabel setFrame:frame];
    
    //Layout the image view
    frame = imageView.frame;
    frame.size.width = self.bounds.size.width - self.imageViewMargin.origin.x - self.imageViewMargin.size.width;
    frame.size.height = self.imageViewHeight;
    frame.origin.x = self.imageViewMargin.origin.x;
    frame.origin.y = excerptLabel.frame.origin.y + excerptLabel.frame.size.height + titleLabelMargin.size.height;
    [imageView setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    //Get the current context
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Draw the image
    [imageView.image drawInRect:imageView.frame];
    
    //Draw the title label
    [titleLabel drawTextInRect:titleLabel.frame];
    
    //Draw the excerpt label
    [excerptLabel drawTextInRect:excerptLabel.frame];
    
    //Call super
    [super drawRect:rect];
}

- (void)configureWithRecord:(NoogaArticleModelArticle *)record fromSection:(TableViewControllerSection *)section
{
    [self.titleLabel setText:record.title];
    [self.excerptLabel setText:record.excerpt];
    
    //Load the image
    __block id blocksafeSelf = self;
    [self.imageView setImageWithURL:[NSURL URLWithString:[record getMediumImageUrl]]
              placeholderImage:[UIImage imageNamed:@"icon.png"]
                       success:^(UIImage *image, BOOL cached) {
                           [blocksafeSelf setNeedsDisplay];
                       }
                       failure:^(NSError *error) {
                           
                       }];

}

- (CGFloat)getHeightForRecord:(NoogaArticleModelArticle *)record
{
    CGFloat height = 0.0f;
    
    //Get the title height
    height += [self getHeightForTitle:record.title] + titleLabelMargin.origin.y + titleLabelMargin.size.height;
    
    //Get the excerpt height
    height += [self getHeightForExcerpt:record.excerpt];
    
    //Get the height for the image
    height += [self getHeightForImage:record.mediumImage];
    
    //Return the height
    return height;
}

- (CGFloat)getHeightForTitle:(NSString *)title
{
    //Compute the title height
    CGSize maxSize = CGSizeMake(self.bounds.size.width - titleLabelMargin.origin.x - titleLabelMargin.size.width, CGFLOAT_MAX);
    CGSize titleSize = [title sizeWithFont:titleLabel.font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    return titleSize.height;
}

- (CGFloat)getHeightForExcerpt:(NSString *)excerpt
{
    //Compute the excerpt height
    CGSize maxSize = CGSizeMake(self.bounds.size.width - titleLabelMargin.origin.x - titleLabelMargin.size.width, CGFLOAT_MAX);
    CGSize titleSize = [excerpt sizeWithFont:excerptLabel.font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    return titleSize.height;
}

- (CGFloat)getHeightForImage:(NSString *)image
{
    //Compute the image height
    CGFloat height = 0.0f;
    if (image != nil) {
        height += self.imageViewHeight + self.imageViewMargin.origin.y + self.imageViewMargin.size.height;
    }
    return height;
}

@end
