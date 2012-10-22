//
//  NoogaArticleModelCategory.h
//  nooga-ios
//
//  Created by Jared Lewis on 10/20/12.
//  Copyright (c) 2012 Jared Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "NoogaModel.h"

@interface NoogaArticleModelCategory : NoogaModel

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSSet *articles;

@end
