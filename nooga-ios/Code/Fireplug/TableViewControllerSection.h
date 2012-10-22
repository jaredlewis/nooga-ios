//
//  TableViewControllerSection.h
//  fireplug-ios
//
//  Created by Jared Lewis on 9/4/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKObservable.h"
#import "FPDataStore.h"

@class TableViewController;
@class TableViewControllerSection;


/////////////////////////////////////////////////////////////////////
//  Delegate Protocols
/////////////////////////////////////////////////////////////////////
@protocol TableViewControllerSectionDelegate <NSObject>

@optional
- (void)tableSection:(TableViewControllerSection *)section cellClicked:(UITableViewCell *)cell withRecord:(id)record;
- (void)tableSection:(TableViewControllerSection *)section renderCell:(UITableViewCell *)cell;
- (void)tableSection:(TableViewControllerSection *)section configureCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)tableSection:(TableViewControllerSection *)section configureSelectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)tableSection:(TableViewControllerSection *)section configureUnselectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)tableSection:(TableViewControllerSection *)section selectionChange:(NSArray *)selection;
- (void)tableSection:(TableViewControllerSection *)section removeCell:(UITableViewCell *)cell withRecord:(id)record;
- (CGFloat)tableSection:(TableViewControllerSection *)section heightForCell:(UITableViewCell *)cell withRecord:(id)record;
@end

@interface TableViewControllerSection : AKObservable <FPDataStoreDelegate>

@property (nonatomic, weak) TableViewController *tableViewController;
@property (nonatomic) NSString *cellClass;
@property (nonatomic) BOOL cellIsXib;
@property (nonatomic) FPDataStore *store;
@property (nonatomic) NSMutableArray *selection;
@property (nonatomic) BOOL multiSelect;
@property (nonatomic) BOOL editable;
@property (nonatomic) UIView *header;
@property (nonatomic) NSString *headerTitle;
@property (nonatomic) UIView *footer;
@property (nonatomic) UIView *customView;
@property (nonatomic) BOOL canEdit;
@property (nonatomic) BOOL canDelete;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;

//Init Methods
- (id)initWithCellClass:(NSString *)cellClass;
- (id)initWithStore:(FPDataStore *)store;
+ (id)sectionWithSingleView:(UIView *)view;

//Init setup methods
- (void)initComponent;
- (void)initHeader;

//Methods to extend
- (UITableViewCell *)getCellWithRecord:(id)record;
- (CGFloat)getHeaderHeight;
- (CGFloat)getFooterHeight;
- (CGFloat)getCellHeight:(id)record;
- (void)renderCell:(UITableViewCell *)cell withRecord:(id)record atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)configureSelectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)configureUnselectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)selectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)unselectedCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)removeCell:(UITableViewCell *)cell withRecord:(id)record;
- (BOOL)canEditRecord:(id)record;
- (BOOL)canDeleteRecord:(id)record;

//Methods
- (NSIndexPath *)getIndexPathForRecord:(id)record;
- (void)clearSelection;
- (void)selectRecord:(id)record;
- (void)deselectRecord:(id)record;

//Event Methods
- (void)onCellClicked:(UITableViewCell *)cell withRecord:(id)record;
- (void)onRemoveCell:(UITableViewCell *)cell withRecord:(id)record;
- (void)onSelectionChange:(NSArray *)selection;

@end
