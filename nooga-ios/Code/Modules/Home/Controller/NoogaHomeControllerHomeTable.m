//
//  NoogaHomeControllerHomeTable.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaHomeControllerHomeTable.h"
#import "NoogaArticleModelArticle.h"
#import "NoogaArticleModelCategory.h"
#import "NoogaArticleViewArticleSectionHeader.h"
#import "NoogaArticleViewArticleWebView.h"
#import "NoogaArticleControllerCategory.h"
#import <RestKit/RKJSONParserJSONKit.h>

@implementation NoogaHomeControllerHomeTable

@synthesize topSection;

- (void)initSections
{
    [super initSections];
    
    topSection = [[NoogaArticleViewArticleSection alloc] init];
    [topSection addDelegate:self];
    [self addSection:topSection];
}

- (void)initStyle
{
    [super initStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create the client
    RKClient *homepageClient = [RKClient clientWithBaseURLString:@"http://nooga.com"];
    
    //Create a mapping provider
    RKObjectManager *homepageObjectManager = [[RKObjectManager alloc] initWithBaseURL:homepageClient.baseURL];
    [homepageObjectManager setClient:homepageClient];
    
    //Article Mapping
    RKObjectMapping *articleMapper = [NoogaArticleModelArticle objectMapper];
    [homepageObjectManager.mappingProvider setObjectMapping:articleMapper forKeyPath:@"top_articles"];
    
    //Category Mapping
    RKObjectMapping *categoryMapper = [NoogaArticleModelCategory objectMapper];
    [categoryMapper mapKeyPath:@"articles" toRelationship:@"articles" withMapping:articleMapper];
    [homepageObjectManager.mappingProvider setObjectMapping:categoryMapper forKeyPath:@"categories"];
    
    //Load the homepage
    [homepageObjectManager loadObjectsAtResourcePath:@"/article/article-api/homepage" delegate:self];
}

- (void)addCategorySection:(NoogaArticleModelCategory *)category
{
    //Create a section
    NoogaArticleViewArticleSection *section = [[NoogaArticleViewArticleSection alloc] init];
    [section addDelegate:self];
    NoogaArticleViewArticleSectionHeader *header = [[NoogaArticleViewArticleSectionHeader alloc] init];
    header.category = category;
    header.titleLabel.text = category.name;
    [section setHeader:header];
    [section setHeaderHeight:header.frame.size.height];
    
    //Add tap gesture to header
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCategory:)];
    [header addGestureRecognizer:tap];
    
    //Set the header color
    NSString *categoryName = [category.name lowercaseString];
    NSLog(@"%@", categoryName);
    if ([categoryName isEqualToString:@"business"]) {
        [header setStartColor:[UIColor colorWithHex:@"#3f7f25" alpha:1.0f]];
        [header setEndColor:[UIColor colorWithHex:@"#285014" alpha:1.0f]];
    }
    if ([categoryName isEqualToString:@"government"]) {
        [header setStartColor:[UIColor colorWithHex:@"#02789b" alpha:1.0f]];
        [header setEndColor:[UIColor colorWithHex:@"#015269" alpha:1.0f]];
    }
    if ([categoryName isEqualToString:@"lifestyle"]) {
        [header setStartColor:[UIColor colorWithHex:@"#218e78" alpha:1.0f]];
        [header setEndColor:[UIColor colorWithHex:@"#176757" alpha:1.0f]];
    }
    if ([categoryName isEqualToString:@"opinion"]) {
        [header setStartColor:[UIColor colorWithHex:@"#c76c25" alpha:1.0f]];
        [header setEndColor:[UIColor colorWithHex:@"#98521a" alpha:1.0f]];
    }
    if ([categoryName isEqualToString:@"sports"]) {
        [header setStartColor:[UIColor colorWithHex:@"#b51e12" alpha:1.0f]];
        [header setEndColor:[UIColor colorWithHex:@"#82150a" alpha:1.0f]];
    }
    
    //Add articles
    for (NoogaArticleModelArticle *article in category.articles) {
        [section.store addItem:article];
    }
    
    //Add Section
    [self addSection:section];
}

- (void)showCategory:(UITapGestureRecognizer *)tapRecognizer
{
    NoogaArticleViewArticleSectionHeader *headerView = (NoogaArticleViewArticleSectionHeader *)[tapRecognizer view];
    NoogaArticleControllerCategory *categoryController = [[NoogaArticleControllerCategory alloc] init];
    [categoryController setCategory:headerView.category];
    [self.navigationController pushViewController:categoryController animated:YES];
}

////////////////////////////////////////////////////////////
//  Object loader delegate methods
////////////////////////////////////////////////////////////
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    //Create sections
    NSMutableArray *topStories = [[NSMutableArray alloc] init];
    for (id object in objects) {
        
        //is top story article
        if ([object isKindOfClass:[NoogaArticleModelArticle class]]) {
            [topStories addObject:object];
        }
        
        //is a category
        if ([object isKindOfClass:[NoogaArticleModelCategory class]]) {
            [self addCategorySection:object];
        }
    }
    [topSection.store load:topStories];

    
    //Redraw
    runOnMainThread(^{
        [self.tableView reloadData];
    });
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"--- object load failure");
}

////////////////////////////////////////////////////////////
//  Request delegate methods
////////////////////////////////////////////////////////////
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"%@", [request.URL absoluteString]);
}


////////////////////////////////////////////////////////////
//  Table section delegate methods
////////////////////////////////////////////////////////////
- (void)tableSection:(AkimboUITableViewControllerSection *)section cellClicked:(UITableViewCell *)cell withRecord:(NoogaArticleModelArticle *)record
{
    UIViewController *contentViewController = [[UIViewController alloc] init];
    NoogaArticleViewArticleWebView *webView = [[NoogaArticleViewArticleWebView alloc] init];
    [webView loadArticle:record.articleId];
    contentViewController.view = webView;
    [self.navigationController pushViewController:contentViewController animated:YES];
}

@end
