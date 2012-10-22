//
//  FPDataStore.m
//  FireplugCore
//
//  Created by Wes Okes on 8/8/12.
//
//

#import "FPDataStore.h"

@implementation FPDataStore

@synthesize delegate;
@synthesize itemsAreDirty;
@synthesize items;
@synthesize allItems;
@synthesize filters;
@synthesize sorters;
@synthesize modelName;
@synthesize classRef;
@synthesize proxy;
@synthesize changeTimer;
@synthesize changeBufferTimeout;

/////////////////////////////////////////////////////////////////
//  Init Methods
/////////////////////////////////////////////////////////////////
- (id)initWithProxy:(id)aProxy
{
    self = [super init];
    
    if (self) {
        [self initComponent];
        proxy = aProxy;
    }
    
    return self;
}

- (id)init
{
    self = [self initWithProxy:nil];
    
    return self;
}

- (void)initComponent
{
    itemsAreDirty = NO;
    items = [[NSMutableArray alloc] init];
    allItems = [[NSMutableArray alloc] init];
    filters = [[NSMutableArray alloc] init];
    sorters = [[NSMutableArray alloc] init];
    dataLock = [[NSLock alloc] init];
    changeBufferTimeout = 0.2f;
}

- (void)setModelName:(NSString *)aModelName
{
    modelName = aModelName;
    if ([modelName isEqualToString:@"id"] == NO) {
        classRef = NSClassFromString(modelName);
    } else {
        classRef = nil;
    }
}

/////////////////////////////////////////////////////////////////
//  Methods
/////////////////////////////////////////////////////////////////
- (id)addItem:(id)item
{
    [self add:@[item]];
    return item;
}

- (void)load:(NSArray *)records
{
    [self removeAll];
    [self add:records];
    [self onLoad];
}

- (NSArray *)items
{
    if (itemsAreDirty == YES) {
        [self updateFilteredItems];
    }
    return items;
}

- (void)addSorter:(NSSortDescriptor *)sortDescriptor
{
    [dataLock lock];
    [sorters addObject:sortDescriptor];
    itemsAreDirty = YES;
    [dataLock unlock];
    [self updateFilteredItems];
}

- (void)sortByKey:(NSString *)key
{
    [self sortByKey:key ascending:YES];
}

- (void)sortByKey:(NSString *)key ascending:(BOOL)isAscending;
{
    [self addSorter:[[NSSortDescriptor alloc] initWithKey:key ascending:isAscending]];
}

- (id)findItemWithFieldName:(NSString *)fieldName equalTo:(NSString *)value
{
    @synchronized(self.allItems){
        for (id item in self.allItems) {
            if ([[item valueForKey:fieldName] isEqualToString:value]) {
                return item;
            }
        }
    }
    
    return nil;
}

- (void)clearFilter
{
    @synchronized(self.filters){
        [self.filters removeAllObjects];
    }
    itemsAreDirty = YES;
    [self updateFilteredItems];
}

- (void)clearSort
{
    itemsAreDirty = YES;
    @synchronized(self.sorters){
        [self.sorters removeAllObjects];
    }
    [self updateFilteredItems];
}

- (void)addFilter:(NSPredicate *)predicate
{
    @synchronized(self.filters){
        [self.filters addObject:predicate];
    }
    itemsAreDirty = YES;
    [self updateFilteredItems];
}

- (void)filterByFieldName:(NSString *)fieldName equalTo:(NSString *)value
{
    [self addFilter:[NSPredicate predicateWithFormat:@"%K == %@", fieldName, value]];
}

- (void)filterByFieldName:(NSString *)fieldName notEqualTo:(NSString *)value
{
    [self addFilter:[NSPredicate predicateWithFormat:@"%K != %@", fieldName, value]];
}

- (void)filterByFieldName:(NSString *)fieldName contains:(NSString *)value
{
    [self addFilter:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", fieldName, value]];
}

- (void)filterByFieldName:(NSString *)fieldName doesNotContain:(NSString *)value
{
    [self addFilter:[NSPredicate predicateWithFormat:@"NOT %K CONTAINS %@", fieldName, value]];
}

- (void)filterByBlock:(BOOL (^)(id record, NSDictionary *bindings))filterBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:filterBlock];
    [self addFilter:predicate];
}

- (void)updateFilteredItems
{
    @synchronized(items){
        [items removeAllObjects];
    
        // Apply filters and then apply sorters
        [items addObjectsFromArray:[[allItems filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:filters]] sortedArrayUsingDescriptors:sorters]];
    }
    itemsAreDirty = NO;
    [self onChange];
}

- (void)add:(NSArray *)records
{
    @synchronized(allItems){
        [allItems addObjectsFromArray:records];
    }
    itemsAreDirty = YES;
    [self onAdd:records];
}

- (void)remove:(id)record
{
    @synchronized(allItems){
        [allItems removeObject:record];
    }
    self.itemsAreDirty = YES;
    [self onRemove:record];
}

- (NSUInteger)getCount
{
    NSLog(@"DEPCRCATED: FPDataStore.getCount should be FPDataStore.count");
    @synchronized(self.items){
        return self.items.count;
    }
}

- (NSUInteger)count
{
    @synchronized(self.items){
        return self.items.count;
    }
}

- (id)getAtIndex:(NSInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    @synchronized(self.items){
        return [self.items objectAtIndex:index];
    }
}

- (void)removeAll
{
    NSArray *removedItems;
    @synchronized(allItems){
        removedItems = [NSArray arrayWithArray:allItems];
        [allItems removeAllObjects];
    }
    @synchronized(items){
        [items removeAllObjects];
    }
    [self onRemoveAll:removedItems];
}

- (id)load
{
    if (proxy == nil) {
        return nil;
    }
    
    SEL loadSelector = NSSelectorFromString(@"load");
    if ([proxy respondsToSelector:loadSelector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id loadResult = [proxy performSelector:loadSelector];
        #pragma clang diagnostic pop
        
        return loadResult;
    }
    
    return nil;
}

- (NSArray *)filteredArrayWhereFieldName:(NSString *)fieldName equalsValue:(id)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", fieldName, value];
    @synchronized(allItems){
        NSArray *filteredItems = [allItems filteredArrayUsingPredicate:predicate];
        return filteredItems;
    }
}

- (NSArray *)uniqueValuesForFieldName:(NSString *)fieldName
{
    NSMutableArray *uniqueValues = [[NSMutableArray alloc] init];
    NSString *keyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", fieldName];
    @synchronized(allItems){
        uniqueValues = [allItems valueForKeyPath:keyPath];
        return uniqueValues;
    }
}

/////////////////////////////////////////////////////////////////
//  Events
/////////////////////////////////////////////////////////////////
- (void)willLoad
{
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStoreWillLoad:)]) {
        [delegate dataStoreWillLoad:self];
    }
    
    [self callDelegatesWithSelector:@selector(dataStoreWillLoad:) andArguments:@[self]];
}

- (void)onLoad
{
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:load:)]) {
        [delegate dataStore:self load:self.items];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:load:) andArguments:@[self, self.items]];
}

- (void)startChangeTimer
{
    [self.changeTimer invalidate];
    changeTimer = [NSTimer scheduledTimerWithTimeInterval:changeBufferTimeout
                                                   target:self
                                                 selector:@selector(onChangeBuffered)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)onChange
{
    // Call the delegate if necessary
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:change:)]) {
        [delegate dataStore:self change:self.items];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:change:) andArguments:@[self, self.items]];
    [self performSelectorOnMainThread:@selector(startChangeTimer) withObject:nil waitUntilDone:NO];
    
}

- (void)onChangeBuffered
{
    // Call the delegate if necessary
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:changeBuffered:)]) {
        [delegate dataStore:self change:self.items];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:changeBuffered:) andArguments:@[self, self.items]];
}

- (void)onAdd:(NSArray *)records
{
    [self updateFilteredItems];
    
    // Call the delegate if necessary
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:add:)]) {
        [delegate dataStore:self add:records];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:add:) andArguments:@[self, records]];    
}

- (void)onRemove:(id)record
{
    [self updateFilteredItems];
    
    // Call the delegate if necessary
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:remove:)]) {
        [delegate dataStore:self remove:record];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:remove:) andArguments:@[self, record]];
}

- (void)onRemoveAll:(NSArray *)removedItems
{
    [self updateFilteredItems];
    
    NSArray *copiedItems = removedItems.copy;
    
    // Call the delegate if necessary
    if (delegate != nil && [delegate respondsToSelector:@selector(dataStore:removeAll:)]) {
        [delegate dataStore:self removeAll:copiedItems];
    }
    
    [self callDelegatesWithSelector:@selector(dataStore:removeAll:) andArguments:@[self, copiedItems]];
    
    removedItems = nil;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    @synchronized(self.allItems){
        [aCoder encodeObject:self.allItems forKey:@"allItems"];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        [self load:[aDecoder decodeObjectForKey:@"allItems"]];
    }
	return self;
}

@end
