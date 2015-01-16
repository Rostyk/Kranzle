//
//  ViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "SalesLoginViewController.h"
#import "CustomerListViewController.h"
#import "DataProvider.h"
#import "Customer.h"

@interface SalesLoginViewController ()
@property (nonatomic, strong) UIAlertView *loadingView;
@property (nonatomic, weak) IBOutlet UITextField *salesIDTextfield;
@end

@implementation SalesLoginViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark login

- (IBAction)loginButtonClicked:(id)sender {
    
    //disimss the keyboard
    [self.salesIDTextfield resignFirstResponder];
    
    //add preload grpahics
    [self addPreload];
    __weak typeof(self) weakSelf = self;
    NSString *customerNumber = self.salesIDTextfield.text;
    [[DataProvider sharedProvider] fetchRecordsForSalesmenNumber:customerNumber
        sucess:^(NSArray *records) {
            [self removePreload];
        
            if(!records || records.count == 0) {
                [weakSelf alert: @"Customers with this sales number not found in our database"];
            }
            else {
                 [weakSelf showCustomerList];
            }
    }];
}


#pragma mark open collect data view controller

-(void) showCustomerList{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CustomerListViewController *controller = (CustomerListViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CustomerListViewControllerID"];
    [self.navigationController pushViewController: controller animated:YES];
}


#pragma mark login

- (void)alert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark preload

- (void)addPreload {
    self.loadingView = [[UIAlertView alloc] initWithTitle:@"Logging"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingView setValue:spinner forKey:@"accessoryView"];
    [spinner startAnimating];
    [self.loadingView show];
}

- (void)removePreload {
    [self.loadingView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
