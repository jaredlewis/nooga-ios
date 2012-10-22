//
//  TableViewController.m
//  fireplug-ios
//
//  Created by Jared Lewis on 7/19/12.
//  Copyright (c) 2012 Akimbo. All rights reserved.
//

#import "TableViewController.h"
#import "Utils.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize sections;

//////////////////////////////////////////////////////////////////////////////////////////////
//  Init Methods
//////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self initComponent];
    }
    return self;
}

- (void)initComponent
{
    [self initProperties];
    [self initSections];
}

- (void)initProperties
{
    
}

- (void)initSections
{
    sections = [[NSMutableArray alloc] init];
}

- (void)initStyle
{
    //Set the seperator color to clear
    self.tableView.separatorColor = [UIColor clearColor];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//  View Methods
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initStyle];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//  Mutators
//////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////
//  Methods
//////////////////////////////////////////////////////////////////////////////////////////////
- (void)addSection:(TableViewControllerSection *)section
{
    if (self.isViewLoaded) {
        [self.tableView beginUpdates];
    }

    //If our table already has this section then remove it
    if ([sections containsObject:section]) {
        if (self.isViewLoaded) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[sections indexOfObject:section]] withRowAnimation:NO];
        }
        [sections removeObject:section];
    }
    
    //Add the section
    [sections addObject:section];
    if (self.isViewLoaded) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:[sections indexOfObject:section]] withRowAnimation:NO];
    }
    
    //Set the table view controller
    [section setTableViewController:self];
    
    //Reload the table
    if (self.isViewLoaded) {
        [self.tableView endUpdates];
        [self reloadData];
    }
}

- (void)removeSection:(TableViewControllerSection *)section
{
    if (self.isViewLoaded) {
        [self.tableView beginUpdates];
    }
    
    //If our table already has this section then remove it
    if ([sections containsObject:section]) {
        if (self.isViewLoaded) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[sections indexOfObject:section]] withRowAnimation:NO];
        }
        [sections removeObject:section];
    }
    
    //Reload the table
    if (self.isViewLoaded) {
        [self.tableView endUpdates];
        [self reloadData];
    }
}

- (void)removeAllSections
{
    if (self.isViewLoaded) {
        [self.tableView beginUpdates];
    }
    
    //If our table already has this section then remove it
    for (int i = 0; i < sections.count; i++) {
        if (self.isViewLoaded) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:NO];
        }
        [sections removeObjectAtIndex:i];
    }
    
    //Reload the table
    if (self.isViewLoaded) {
        [self.tableView endUpdates];
        [self reloadData];
    }
}

- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the section
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    
    //Get the record
    id record = [self getRecordFromIndexPath:indexPath];
    if (record == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    //Get the cell
    UITableViewCell *cell = [section getCellWithRecord:record];
    
    //Configure the cell
    [section renderCell:cell withRecord:record atIndexPath:indexPath];
    
    //Return the cell
    return cell;
}

- (TableViewControllerSection *)getSectionFromIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < sections.count) {
        return [sections objectAtIndex:indexPath.section];
    }
    return nil;
}

- (UITableViewCell *)getCellFromClass:(NSString *)classString
{
    UITableViewCell *cell = nil;

    if (classString != nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:classString];
        //If cell is still nil we probably had a memory warning and our cell is gone
        if (cell == nil){
            //Re-register our cell class
            if (classString != nil) {
                [self registerCellClass:classString];
            }
            cell = [self.tableView dequeueReusableCellWithIdentifier:classString];
        }
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"UITableViewCell"];
        }
    }

    return cell;
}

- (id)getRecordFromIndexPath:(NSIndexPath *)indexPath
{
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    return [section.store getAtIndex:indexPath.row];
}

- (int)getSectionIndex:(TableViewControllerSection *)section
{
    return [sections indexOfObject:section];
}

- (void)registerCellClass:(NSString *)classString
{
    UINib * cellNib = [UINib nibWithNibName:classString bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:classString];
}

- (void)removeCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withRecord:(id)record
{
    // Get the section
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    
    // Remove if necessary
    if ([section canDeleteRecord:record]) {
        [section removeCell:cell withRecord:record];
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

- (void)reloadData
{
    if (self.isViewLoaded) {
        runOnMainThread(^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - Table View Delegates
//////////////////////////////////////////////////////////////////////////////////////////////
//  All table view delegates
//////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int numSections = sections.count;
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        return tableSection.store.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the record
    id record = [self getRecordFromIndexPath:indexPath];
    
    //Return the height
    return [[self getSectionFromIndexPath:indexPath] getCellHeight:record];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the section
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    
    //Get the record
    id record = [self getRecordFromIndexPath:indexPath];
    
    //Get the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Handle the selection
    [section selectedCell:cell withRecord:record];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the section
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    
    //Get the record
    id record = [self getRecordFromIndexPath:indexPath];
    
    //Get the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Handle the selection
    [section unselectedCell:cell withRecord:record];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    return [section canEditRecord:[self getRecordFromIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the record
    id record = [self getRecordFromIndexPath:indexPath];
    
    //Get the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeCell:cell forRowAtIndexPath:indexPath withRecord:record];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Get the section
    TableViewControllerSection *section = [self getSectionFromIndexPath:indexPath];
    
    // Detemine if it's in editing mode
    if (self.editing || [section canDeleteRecord:[self getRecordFromIndexPath:indexPath]] == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Get the section
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        return tableSection.header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //Get the section
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        if (tableSection.header != nil) {
            return [tableSection getHeaderHeight];
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //Get the section
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        return tableSection.footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //Get the section
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        return [tableSection getFooterHeight];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Get the section
    if (section < sections.count) {
        TableViewControllerSection *tableSection = [sections objectAtIndex:section];
        return [tableSection headerTitle];
    }
    return nil;
}

@end