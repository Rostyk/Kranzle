//
//  NewCustomerViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/19/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "NewCustomerViewController.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "Customer.h"


@interface NewCustomerViewController ()
@property (nonatomic, strong) Customer *createdCustomer;
@end

@implementation NewCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createdCustomer = [[DataProvider sharedProvider] createNewCustomer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}


@end
