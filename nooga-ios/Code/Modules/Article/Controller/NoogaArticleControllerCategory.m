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

@interface Unit : NoogaModel
@property (nonatomic) NSString *unitId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *zip;
@end

@implementation Unit
@synthesize unitId;
@synthesize name;
@synthesize zip;

+ (RKObjectMapping *)objectMapper
{
    RKObjectMapping *objectMapper = [RKObjectMapping mappingForClass:[self class]];
    [objectMapper mapKeyPathsToAttributes:
     @"id", @"unitId",
     @"name", @"name",
     @"zip_code", @"zip",
     nil];
    return objectMapper;
}
@end

@implementation NoogaArticleControllerCategory

@synthesize articleApi;
@synthesize articleSection;

@synthesize wesClient;
@synthesize unitManager;
@synthesize testUnit;

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
    
    articleApi = [[ArticleApi alloc] init];
    [articleApi setValue:self.category.categoryId forParam:@"category"];
    [articleApi addSorterProperty:@"updated_at" ascending:NO];
    
    [articleApi doReadOperationOnSuccess:^(RKObjectLoader *objectLoader, NSArray *objects) {
        
        // Load the records into the table view
        [self.articleSection.store load:objects];
        
    } onFailure:^(RKObjectLoader *objectLoader, NSError *error) {
        
        
    } onComplete:^{
        
        
    }];
    
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
