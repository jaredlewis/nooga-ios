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

@implementation NoogaArticleControllerCategory

@synthesize articleSection;

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
    
    //Create the client
    RKClient *categoryClient = [RKClient sharedClient];
    
    //Create a mapping provider
    RKObjectManager *homepageObjectManager = [[RKObjectManager alloc] initWithBaseURL:categoryClient.baseURL];
    [homepageObjectManager setClient:categoryClient];
    
    //Article Mapping
    RKObjectMapping *articleMapper = [NoogaArticleModelArticle objectMapper];
    [homepageObjectManager.mappingProvider setObjectMapping:articleMapper forKeyPath:@"records"];
    
    //Load the homepage
    NSString *urlPath = [NSString stringWithFormat:@"/article/article-api/public?category=%@&sort=[{\"property\":\"updated_at\",\"direction\":\"DESC\"}]", self.category.categoryId];
    [homepageObjectManager loadObjectsAtResourcePath:urlPath delegate:self];
}



////////////////////////////////////////////////////////////
//  Object loader delegate methods
////////////////////////////////////////////////////////////
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [self.articleSection.store load:objects];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
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
