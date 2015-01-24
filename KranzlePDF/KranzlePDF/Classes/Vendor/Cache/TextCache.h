//
//  TextCache.h
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    CACHE_TYPE_SINGLE_CUSTOMER = 0,
    CACHE_TYPE_MULTIPLE_CUSTOMERS
} CACHE_TYPE;



@class Customer;

@interface TextCache : NSObject
@property (nonatomic) CACHE_TYPE cacheType;

+ (instancetype)sharedCache;
- (void)startCachingCustomer:(Customer *)customer;

- (void)saveTexTField:(UITextField *)textField;
- (void)restoreTextForTextField:(UITextField *)textField;

@end
