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
    
    [articleApi setParam:@"category" value:self.category.categoryId];
    [articleApi addSorterProperty:@"updated_at" ascending:NO];
    
//    [articleApi doReadOperationOnSuccess:^(RKObjectLoader *objectLoader, NSArray *objects) {
//        
//        // Load the records into the table view
//        [self.articleSection.store load:objects];
//        
//    } onFailure:^(RKObjectLoader *objectLoader, NSError *error) {
//        
//        
//    } onComplete:^{
//        
//        
//    }];
    
    [articleApi doGETOperationToApi:@"energy/unit-api/read" withParams:@{@"one":@"two"} onSuccess:^(RKRequest *request, RKResponse *response) {
        
    } onFailure:nil onComplete:nil];
    
    [articleApi doGETOperationToApi:@"nopeenergy/unit-api/read" withParams:@{@"one":@"two"} onSuccess:nil onFailure:nil onComplete:nil];
    
}

////////////////////////////////////////////////////////////
//  Table section delegate methods
////////////////////////////////////////////////////////////
- (void)tableSection:(TableViewControllerSection *)section cellClicked:(UITableViewCell *)cell withRecord:(NoogaArticleModelArticle *)record
{
    UIViewController *contentViewController = [[UIViewController alloc] init];
    NoogaArticleViewArticleWebView *webView = [[NoogaArticleViewArticleWebView alloc] init];
    [webView loadArticle:record.articleId];
    
    [articleApi doCreateOperationForItem:record onSuccess:nil onFailure:nil onComplete:nil];
    
    contentViewController.view = webView;
    [self.navigationController pushViewController:contentViewController animated:YES];
}

@end
