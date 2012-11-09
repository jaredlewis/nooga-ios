//
//  NoogaArticleModelControllerCategory.m
//  nooga-ios
//
//  Created by Wes Okes on 10/22/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//


#import "NoogaArticleModelArticle.h"
#import "NoogaArticleModelCategory.h"
#import "NoogaArticleControllerCategory.h"
#import "NoogaArticleViewArticleSection.h"
#import "NoogaArticleViewArticleWebView.h"
#import "ArticleApi.h"

@implementation NoogaArticleControllerCategory

@synthesize articleApi;
@synthesize articleSection;
@synthesize category;

- (void)initSections
{
    [super initSections];
    
    articleSection = [[NoogaArticleViewArticleSection alloc] init];
    [self addSection:articleSection];
    [articleSection addDelegate:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKClient *client = [[RKClient alloc] initWithBaseURLString:@"http://127.0.0.1:8000"];
    articleApi = [[ArticleApi alloc] initWithClient:client];
    NSDictionary *params = @{
        @"category": self.category.categoryId,
        @"sort": @[
            @{
                @"property": @"updated_at",
                @"direction": @"DESC",
            }
        ]
    };
    [articleApi doLoadOperationWithParams:params onSuccess:^(RKObjectLoader *loader, NSArray *objects){
        NSLog(@"object load success block from controller");
        [self.articleSection.store load:objects];
        
    } onFailure:nil onComplete:nil];
    
}

////////////////////////////////////////////////////////////
//  Table section delegate methods
////////////////////////////////////////////////////////////
- (void)tableSection:(TableViewControllerSection *)section cellClicked:(UITableViewCell *)cell withRecord:(NoogaArticleModelArticle *)record
{
    UIViewController *contentViewController = [[UIViewController alloc] init];
    NoogaArticleViewArticleWebView *webView = [[NoogaArticleViewArticleWebView alloc] init];
    [webView loadArticle:record.articleId];
    
    contentViewController.view = webView;
    [self.navigationController pushViewController:contentViewController animated:YES];
}

@end
