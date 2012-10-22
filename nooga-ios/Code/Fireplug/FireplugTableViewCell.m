//
//  FireplugTableViewCell.m
//  fireplug-ios
//
//  Created by Jared Lewis on 8/21/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FireplugTableViewCell.h"
#import "TableViewController.h"

@implementation FireplugTableViewCell

@synthesize section;
@synthesize record;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponent];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent{}

//Methods
- (void)configureWithRecord:(id)record fromSection:(TableViewControllerSection *)section{}
- (void)configureSelectedWithRecord:(id)record fromSection:(TableViewControllerSection *)section{}
- (void)configureUnselectedWithRecord:(id)record fromSection:(TableViewControllerSection *)section{}
@end
