//
//  NoogaArticleViewArticleWebView.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/21/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "NoogaArticleModelArticle.h"

@interface NoogaArticleViewArticleWebView : UIWebView <RKRequestDelegate,RKObjectLoaderDelegate>

@property (nonatomic) NoogaArticleModelArticle *article;

- (void)loadArticle:(NSString *)articleId;

@end
