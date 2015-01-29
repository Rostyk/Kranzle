//
//  CacheItem.h
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Customer;

@interface CacheItem : NSObject
@property (nonatomic, strong, readonly) Customer *customer;
- (id)initWithCustomer:(Customer *)customer;
- (void)saveTexTField:(UITextField *)textField;
- (void)restoreTextForTextField:(UITextField *)textField;
- (void)saveButton:(UIButton *)button withImage:(BOOL)saveImage;
- (void)restoreButton:(UIButton *)button;
@end
