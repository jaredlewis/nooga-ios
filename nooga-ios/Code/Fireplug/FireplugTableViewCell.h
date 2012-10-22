//
//  FireplugTableViewCell.h
//  fireplug-ios
//
//  Created by Jared Lewis on 8/21/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "TableViewControllerSection.h"

@class TableViewControllerSection;

@interface FireplugTableViewCell : UITableViewCell

@property (nonatomic, weak) TableViewControllerSection *section;
@property (nonatomic, weak) id record;

//Methods
- (void)initComponent;
- (void)configureWithRecord:(id)record fromSection:(TableViewControllerSection *)section;
- (void)configureSelectedWithRecord:(id)record fromSection:(TableViewControllerSection *)section;
- (void)configureUnselectedWithRecord:(id)record fromSection:(TableViewControllerSection *)section;
@end
