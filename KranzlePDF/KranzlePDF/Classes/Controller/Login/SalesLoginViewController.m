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
    
    __weak typeof(self) weakSelf = self;
    NSString *customerNumber = self.salesIDTextfield.text;
    [[DataProvider sharedProvider] fetchRecordsForSalesmenNumber:customerNumber
        sucess:^(NSArray *records) {
        
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

@end
