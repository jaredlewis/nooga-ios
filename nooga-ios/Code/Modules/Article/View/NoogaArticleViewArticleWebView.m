//
//  NoogaArticleViewArticleWebView.m
//  nooga-ios
//
//  Created by Jared Lewis on 10/21/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import "NoogaArticleViewArticleWebView.h"

@implementation NoogaArticleViewArticleWebView

@synthesize article;

- (void)loadArticle:(NSString *)articleId
{
    //Create the client
    RKClient *homepageClient = [RKClient sharedClient];
    
    //Create a mapping provider
    RKObjectManager *homepageObjectManager = [[RKObjectManager alloc] initWithBaseURL:homepageClient.baseURL];
    [homepageObjectManager setClient:homepageClient];
    
    //Article Mapping
    RKObjectMapping *articleMapper = [NoogaArticleModelArticle objectMapper];
    [homepageObjectManager.mappingProvider setObjectMapping:articleMapper forKeyPath:@"record"];
    
    //Load the homepage
    NSDictionary *params = @{
        @"id": articleId
    };
    NSString *path = [@"/article/article-api/view" stringByAppendingQueryParameters:params];
    [homepageObjectManager loadObjectsAtResourcePath:path usingBlock:^(RKObjectLoader *loader){
        loader.delegate = self;
    }];
    //[homepageObjectManager loadObjectsAtResourcePath:@"/article/article-api/view" delegate:self];
}

////////////////////////////////////////////////////////////
//  Object loader delegate methods
////////////////////////////////////////////////////////////
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    article = [objects objectAtIndex:0];
    [self loadHTMLString:article.content baseURL:[NSURL URLWithString:@"http://www.nooga.com"]];
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
    NSLog(@"---- did load the response = %@", [request.URL absoluteString]);
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    NSLog(@"--- did fail");
}

@end
