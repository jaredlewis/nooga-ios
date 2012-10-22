//
//  TableViewController.h
//  fireplug-ios
//
//  Created by Jared Lewis on 7/19/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewControllerSection.h"

/////////////////////////////////////////////////////////////////////
//  Needed classes
/////////////////////////////////////////////////////////////////////
@class TableViewController;
@class TableViewControllerSection;

/////////////////////////////////////////////////////////////////////
//  Interface
/////////////////////////////////////////////////////////////////////
@interface TableViewController : UITableViewController

@property (nonatomic, readonly) NSMutableArray *sections;

//Init methods
- (void)initComponent;
- (void)initProperties;
- (void)initSections;
- (void)initStyle;

//Methods
- (void)addSection:(TableViewControllerSection *)section;
- (void)removeSection:(TableViewControllerSection *)section;
- (void)removeAllSections;

- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)getCellFromClass:(NSString *)classString;
- (TableViewControllerSection *)getSectionFromIndexPath:(NSIndexPath *)indexPath;
- (id)getRecordFromIndexPath:(NSIndexPath *)indexPath;
- (int)getSectionIndex:(TableViewControllerSection *)section;

- (void)reloadData;
- (void)registerCellClass:(NSString *)classString;
- (void)removeCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withRecord:(id)record;

@end