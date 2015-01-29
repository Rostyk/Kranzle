//
//  TextCache.m
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "TextCache.h"
#import "Customer.h"
#import "CacheItem.h"

@interface TextCache()
@property (nonatomic, strong) NSMutableArray *cachedCustomers;
@property (nonatomic, strong) CacheItem *currentItem;
@end

@implementation TextCache

#pragma mark shared instance

+ (instancetype)sharedCache
{
    static dispatch_once_t once;
    static TextCache *sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                      sharedInstance.cachedCustomers = [[NSMutableArray alloc] init];
                      sharedInstance.cacheType = CACHE_TYPE_SINGLE_CUSTOMER;
                  });
    
    return sharedInstance;
}

- (void)startCachingCustomer:(Customer *)customer {
    [self checkCacheTypeForNumber:customer.number];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"customer.number == %@", customer.number];
    NSArray *items = [self.cachedCustomers filteredArrayUsingPredicate:pred];
    
    //already cached
    if(items.count > 0) {
        self.currentItem = [items firstObject];
    }
    else {
        CacheItem *item = [[CacheItem alloc] initWithCustomer:customer];
        [self.cachedCustomers addObject:item];
        self.currentItem = item;
    }
}

- (void)saveTexTField:(UITextField *)textField {
    [self.currentItem saveTexTField:textField];
}

- (void)restoreTextForTextField:(UITextField *)textField {
    [self.currentItem restoreTextForTextField:textField];
}

- (void)saveButton:(UIButton *)button withImage:(BOOL)saveImage {
    [self.currentItem saveButton:button withImage:saveImage];
}

- (void)restoreButton:(UIButton *)button {
    [self.currentItem restoreButton:button];
}

- (void)checkCacheTypeForNumber:(NSString *)number {
    /*if the new object for caching arrives,
     clear the cache (in case its cacheType is set to MULTIPLE)*/
    if(![number isEqualToString:self.currentItem.customer.number]) {
        if(self.cacheType == CACHE_TYPE_SINGLE_CUSTOMER) {
            [self.cachedCustomers removeAllObjects];
        }
    }
}


@end
