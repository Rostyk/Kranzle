//
//  ViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "SalesLoginViewController.h"
#import "CollectDataViewController.h"
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
    [[DataProvider sharedProvider] fetchRecordForCustomerNumber:customerNumber
        sucess:^(NSArray *record) {
        
            if(!record) {
                [weakSelf alert:[ NSString stringWithFormat:@"Customer with number %@ not found in our database", customerNumber]];
            }
            else {
                 Customer *customer = [[Customer alloc] initWithRecord: record];
                 [weakSelf showCollectDataViewControllerForCustomer: customer];
            }
    }];
}


#pragma mark open collect data view controller

-(void) showCollectDataViewControllerForCustomer:(Customer *)customer {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataViewController *controller = (CollectDataViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataViewControllerID"];
    controller.customer = customer;
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
