//
//  TableViewControllerSection.m
//  fireplug-ios
//
//  Created by Jared Lewis on 9/4/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import "TableViewControllerSection.h"
#import "TableViewController.h"
#import "FireplugTableViewCell.h"
#import "Utils.h"

@interface TableViewControllerSection ()
@end

@implementation TableViewControllerSection

@synthesize tableViewController;
@synthesize store;
@synthesize cellClass;
@synthesize cellIsXib;
@synthesize multiSelect;
@synthesize selection;
@synthesize editable;
@synthesize header;
@synthesize headerTitle;
@synthesize footer;
@synthesize customView;
@synthesize canEdit;
@synthesize canDelete;
@synthesize cellHeight;
@synthesize headerHeight;
@synthesize footerHeight;

////////////////////////////////////////////
//  Init methods
////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
        [self initComponent];
    }
    return self;
}

- (id)initWithCellClass:(NSString *)newCellClass
{
    self = [self init];
    if (self) {
        cellClass = newCellClass;
    }
    return self;
}

- (id)initWithStore:(FPDataStore *)newStore
{
    self = [self init];
    if (self) {
        self.store = newStore;
    }
    return self;
}

+ (id)sectionWithSingleView:(UIView *)view
{
    TableViewControllerSection *section = [[TableViewControllerSection alloc] init];
    [section setCustomView:view];
    [section.store addItem:[[NSObject alloc] init]];
    return section;
}

- (void)initComponent
{
    selection = [[NSMutableArray alloc] init];
    self.store = [[FPDataStore alloc] init];
    customView = nil;
    canEdit = NO;
    canDelete = NO;
    cellHeight = 44.0f;
    cellIsXib = YES;
    [self initHeader];
    [self initFooter];
}

- (void)initHeader
{
    header = nil;
}

- (void)initFooter
{
    footer = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
//  Mutators
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTableViewController:(TableViewController *)newTableViewController
{
    tableViewController = newTableViewController;
    //[tableViewController.tableView setAllowsMultipleSelection:YES];
}
- (void)setSelection:(NSMutableArray *)newSelection
{
    [self clearSelection];
    selection = [[NSMutableArray alloc] initWithArray:newSelection.copy];
    if (tableViewController.isViewLoaded) {
        [tableViewController reloadData];
    }
}

- (void)setStore:(FPDataStore *)dataStore
{
    //Ignore if this is the same store
    if (dataStore == self.store) {
        return;
    }
    
    //Clean up old store
    if (store != nil) {
        [store removeDelegate:self];
        [self clearSelection];
    }
    
    //Set the store to the new data store
    store = dataStore;
    [store addDelegate:self];
    
    //Reload the table view
    if (store != nil && tableViewController.isViewLoaded) {
        [tableViewController reloadData];
    }
}

- (void)setCellClass:(NSString *)newCellClass
{
    cellClass = newCellClass;
    if(cellClass != nil){
        [tableViewController registerCellClass:cellClass];
        [tableViewController reloadData];
    }
}

- (void)setMultiSelect:(BOOL)newMultiSelect
{
    multiSelect = newMultiSelect;
    if (tableViewController != nil) {
        [tableViewController.tableView setAllowsMultipleSelection:multiSelect];
    }
}

- (void)setHeader:(UIView *)newHeader
{
    header = newHeader;
    if (self.tableViewController != nil) {
        [self.tableViewController reloadData];
    }
}

- (void)setHeaderHeight:(CGFloat)newHeaderHeight
{
    headerHeight = newHeaderHeight;
    if (self.tableViewController != nil) {
        [self.tableViewController reloadData];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////
//  Methods To Extend
//////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)getCellWithRecord:(id)record
{
    UITableViewCell *cell = nil;
    if (customView != nil) {
        cell = [[UITableViewCell alloc] init];
        CGRect viewFrame = CGRectMake(0.0, 0.0,
                                      cell.contentView.bounds.size.width,
                                      cell.contentView.bounds.size.height);
        [customView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [customView setFrame:viewFrame];
        [cell.contentView addSubview:customView];
    } else if (cellIsXib || !cellClass.length){
        cell = [tableViewController getCellFromClass:cellClass];
    } else {
        cell = [tableViewController.tableView dequeueReusableCellWithIdentifier:cellClass];
        if (cell == nil) {
            id cellClassObject = NSClassFromString(cellClass);
            cell = [[cellClassObject alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClass];
        }
    }
    
    return cell;
}

- (CGFloat)getHeaderHeight
{
    return headerHeight;
}

- (CGFloat)getFooterHeight
{
    return footerHeight;
}

- (CGFloat)getCellHeight:(id)record
{
    return cellHeight;
}

- (void)renderCell:(UITableViewCell *)cell withRecord:(id)record atIndexPath:(NSIndexPath *)indexPath
{
    //If the cell is a fireplug cell set the section
    if ([cell isKindOfClass:[FireplugTableViewCell class]] && [cell respondsToSelector:@selector(setSection:)] && [cell respondsToSelector:@selector(setRecord:)]) {
        [cell performSelector:@selector(setSection:) withObject:self];
        [cell performSelector:@selector(setRecord:) withObject:record];
    }
    
    //Configure the cell
    [self configureCell:cell withRecord:record];
    
    indexPath = [self getIndexPathForRecord:record];
    
    //Configure based on selection
    if([selection containsObject:record]){
        @try {
            [tableViewController.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        @catch (NSException *exception) {
            NSLog(@"----Select row exception = %@", exception);
        }
        [self configureSelectedCell:cell withRecord:record];
    } else {
        [tableViewController.tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self configureUnselectedCell:cell withRecord:record];
    }
    
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:renderCell:) andArguments:@[self, cell]];
}

- (void)configureCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Perform a cell selector if it exists
    if ([cell respondsToSelector:@selector(configureWithRecord:fromSection:)]) {
        [cell performSelector:@selector(configureWithRecord:fromSection:) withObject:record withObject:self];
    }
    
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:configureCell:withRecord:) andArguments:@[self, cell, record]];
    
    [cell setNeedsDisplay];
}

- (void)configureSelectedCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Make sure the cell is selected
    [cell setSelected:YES];
    
    //Perform a cell selector if it exists
    if ([cell respondsToSelector:@selector(configureSelectedWithRecord:fromSection:)]) {
        [cell performSelector:@selector(configureSelectedWithRecord:fromSection:) withObject:record withObject:self];
    }
    
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:configureSelectedCell:withRecord:) andArguments:@[self, cell, record]];
    
    [cell setNeedsDisplay];
}

- (void)configureUnselectedCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Make sure the cell is unselected
    [cell setSelected:NO];
    
    //Perform a cell selector if it exists
    if ([cell respondsToSelector:@selector(configureUnselectedWithRecord:fromSection:)]) {
        [cell performSelector:@selector(configureUnselectedWithRecord:fromSection:) withObject:record withObject:self];
    }
    
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:configureUnselectedCell:withRecord:) andArguments:@[self, cell, record]];
    
    [cell setNeedsDisplay];
}

- (void)selectedCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Get the index path
    NSIndexPath *indexPath = [self getIndexPathForRecord:record];
    
    //Make sure cell is not nil
    if (cell == nil) {
        cell = [self getCellWithRecord:record];
    }
    
    //Handle the selection
    if (![selection containsObject:record]) {
        [selection removeObject:record];
    }
    if (!multiSelect) {
        [self clearSelection];
    }
    
    [selection addObject:record];
    if ([[tableViewController.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
        [self configureSelectedCell:cell withRecord:record];
    }
    
    //Call selection change
    [self onSelectionChange:selection];
    
    //Call the class event
    [self onCellClicked:cell withRecord:record];
}


- (void)unselectedCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Handle the selection
    if ([selection containsObject:record]) {
        [selection removeObject:record];
    }
    
    NSIndexPath *indexPath = [self getIndexPathForRecord:record];
    if ([[tableViewController.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
        [self configureUnselectedCell:cell withRecord:record];
    }
    
    //Call selection change
    [self onSelectionChange:selection];
}

- (void)removeCell:(UITableViewCell *)cell withRecord:(id)record
{
    [self.store remove:record];
    [self onRemoveCell:cell withRecord:record];
}

- (BOOL)canEditRecord:(id)record
{
    return canEdit;
}

- (BOOL)canDeleteRecord:(id)record
{
    return canDelete;
}


///////////////////////////////////////////////////////////
//  Methods
///////////////////////////////////////////////////////////
- (NSIndexPath *)getIndexPathForRecord:(id)record
{
    int sectionIndex = [self.tableViewController getSectionIndex:self];
    int recordIndex = 0;
    if ([self.store.items containsObject:record]) {
        recordIndex = [self.store.items indexOfObject:record];
    }
    return [NSIndexPath indexPathForRow:recordIndex inSection:sectionIndex];
}

- (void)clearSelection
{
    
    NSArray *selectionCopy = [selection copy];
    for (int i = 0; i < selectionCopy.count; i++) {
        id selectedRecord = [selectionCopy objectAtIndex:i];
        //NSIndexPath *indexPath = [self getIndexPathForRecord:selectedRecord];
        //BOOL cellVisible = [[tableViewController.tableView indexPathsForVisibleRows] containsObject:indexPath];
        [self deselectRecord:selectedRecord];
    }
    [selection removeAllObjects];
    
    //Call selection change
    [self onSelectionChange:selection];
}

- (void)selectRecord:(id)record
{
    //Make sure we have this record
    if (![self.store.items containsObject:record]) {
        return;
    }
    
    NSIndexPath *indexPath = [self getIndexPathForRecord:record];
    [tableViewController.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if ([tableViewController respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [tableViewController tableView:tableViewController.tableView willSelectRowAtIndexPath:indexPath];
    }
    if ([tableViewController respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [tableViewController tableView:tableViewController.tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)deselectRecord:(id)record
{
    //Make sure we have this record
    if (![self.store.items containsObject:record]) {
        return;
    }
    
    NSIndexPath *indexPath = [self getIndexPathForRecord:record];
    [tableViewController.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableViewController respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
        [tableViewController tableView:tableViewController.tableView willDeselectRowAtIndexPath:indexPath];
    }
    if ([tableViewController respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [tableViewController tableView:tableViewController.tableView didDeselectRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [self.tableViewController tableView:self.tableViewController.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

//////////////////////////////////////////////////////////////////
//  Events
//////////////////////////////////////////////////////////////////
- (void)onSelectionChange:(NSArray *)newSelection
{
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:selectionChange:) andArguments:@[self, newSelection]];
}

- (void)onCellClicked:(UITableViewCell *)cell withRecord:(id)record
{
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:cellClicked:withRecord:) andArguments:@[self, cell, record]];
}

- (void)onRemoveCell:(UITableViewCell *)cell withRecord:(id)record
{
    //Call the delegate if necessary
    [self callDelegatesWithSelector:@selector(tableSection:removeCell:withRecord:) andArguments:@[self, cell, record]];
}


//////////////////////////////////////////////////////////////////////////////////////////////
//  Store delegate methods
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)dataStore:(FPDataStore *)store changeBuffered:(NSArray *)records
{
    [tableViewController reloadData];
}

@end