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
#import "Constants.h"
#import "MBProgressHUD.h"

@interface SalesLoginViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
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
    [[DataProvider sharedProvider] fetchRecordsForSalesmenNumber:customerNumber sucess:^(NSArray *records) {
        [self removePreload];
        [weakSelf showCustomerList];
    } failure:^(NSError *error) {
        [self removePreload];
        if(error.code == PARSER_ERROR) {
            [weakSelf alert: @"Cant parse customer. CSV file corrupted"];
        }
        if(error.code == EMPTY_FETCH_RESULT_ERROR) {
            [weakSelf alert:@"No customers found for this sales number"];
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
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    self.hud.labelText = @"Logging";
    [self.hud show: YES];
}

- (void)removePreload {
    [self.hud hide:YES];
}

@end
