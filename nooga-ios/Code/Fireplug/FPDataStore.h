//
//  FPDataStore.h
//  FireplugCore
//
//  Created by Wes Okes on 8/8/12.
//
//

#import "AKObservable.h"

@class FPDataStore;

@protocol FPDataStoreDelegate <NSObject>

@optional
- (void)dataStore:(FPDataStore *)store change:(NSArray *)records;
- (void)dataStore:(FPDataStore *)store changeBuffered:(NSArray *)records;
- (void)dataStore:(FPDataStore *)store add:(NSArray *)records;
- (void)dataStore:(FPDataStore *)store remove:(id)record;
- (void)dataStore:(FPDataStore *)store removeAll:(NSArray *)records;
- (void)dataStoreWillLoad:(FPDataStore *)store;
- (void)dataStore:(FPDataStore *)store load:(NSArray *)records;

@end

/**
 * A class for storing that data.
 */
@interface FPDataStore : AKObservable <NSCoding>
{
    NSLock *dataLock;
}

@property (atomic, weak) id delegate;
@property (atomic) BOOL itemsAreDirty;
@property (atomic, readonly) NSMutableArray *items;
@property (atomic, readonly) NSMutableArray *allItems;
@property (atomic) NSMutableArray *filters;
@property (atomic) NSMutableArray *sorters;
@property (nonatomic) NSString *modelName;
@property (atomic) Class classRef;
@property (atomic, weak) id proxy;
@property (atomic) float changeBufferTimeout;
@property (atomic) NSTimer *changeTimer;

//Methods
- (id)initWithProxy:(id)aProxy;
- (void)initComponent;
- (id)findItemWithFieldName:(NSString *)fieldName equalTo:(NSString *)value;

- (void)addSorter:(NSSortDescriptor *)sortDescriptor;
- (void)sortByKey:(NSString *)key;
- (void)sortByKey:(NSString *)key ascending:(BOOL)isAscending;
- (void)clearSort;

- (void)addFilter:(NSPredicate *)predicate;
- (void)filterByFieldName:(NSString *)fieldName equalTo:(NSString *)value;
- (void)filterByFieldName:(NSString *)fieldName notEqualTo:(NSString *)value;
- (void)filterByFieldName:(NSString *)fieldName contains:(NSString *)value;
- (void)filterByFieldName:(NSString *)fieldName doesNotContain:(NSString *)value;
- (void)filterByBlock:(BOOL (^)(id record, NSDictionary *bindings))filterBlock;
- (void)clearFilter;

- (id)addItem:(id)item;
- (void)load:(NSArray *)records;
- (void)add:(NSArray *)records;
- (void)remove:(id)record;
- (NSUInteger)getCount;
- (NSUInteger)count;
- (id)getAtIndex:(NSInteger)index;
- (void)removeAll;
- (id)load;

- (NSArray *)filteredArrayWhereFieldName:(NSString *)fieldName equalsValue:(id)value;
- (NSArray *)uniqueValuesForFieldName:(NSString *)fieldName;

//Events
- (void)willLoad;
- (void)onLoad;
- (void)onChange;
- (void)onAdd:(NSArray *)records;
- (void)onRemove:(id)record;
- (void)onRemoveAll:(NSArray *)removedItems;

@end;
