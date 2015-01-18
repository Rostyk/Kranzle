//
//  CustomerListViewController.h
//  KranzlePDF
//
//  Created by Ross on 1/15/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MANUALLY_CREATED_CUSTOMERS_SECTION = 0,
    PARSED_CUSTOMERS_SECTION
} SECTIOM_TYPE;

typedef enum {
    SINGLE_SECTION_TABLE_MODE = 0,
    DOUBLE_SECTION_TABLE_MODE
} TABLE_MODE;

@interface CustomerListViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@end
