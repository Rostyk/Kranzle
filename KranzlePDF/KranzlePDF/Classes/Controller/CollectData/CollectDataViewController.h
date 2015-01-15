//
//  CollectDataViewController.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectDataPopoverContentViewController.h"

@class Customer;

@interface CollectDataViewController : UIViewController<CollectDataPopoverDelegate>
@property (nonatomic, strong) Customer *customer;
@end
