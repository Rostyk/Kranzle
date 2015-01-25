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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkStoredVertreterCode];
    self.title = @"";
}

/*set the title to Einstellungen in order to show the proper back button on the susequent screen*/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"Einstellungen";
}

/*Clear text field*/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.salesIDTextfield.text = @"";
}

#pragma mark login

- (IBAction)loginButtonClicked:(id)sender {
    
    //disimss the keyboard
    [self.salesIDTextfield resignFirstResponder];
    [self loginWitVertreterCode:self.salesIDTextfield.text];
    //add preload grpahics
   
}

- (void)loginWitVertreterCode:(NSString *)code {
    __weak typeof(self) weakSelf = self;
    [self addPreload];
    NSString *customerNumber = code;
    [[DataProvider sharedProvider] fetchRecordsForSalesmenNumber:customerNumber sucess:^(NSArray *records) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"VertreterCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self removePreload];
        [weakSelf showCustomerList];
    } failure:^(NSError *error) {
        [self removePreload];
        if(error.code == PARSER_ERROR) {
            [weakSelf alert: @"Die hinterlegte Datenquelle ist fehlerhaft. Bitte wenden Sie sich an den Support."];
        }
        if(error.code == EMPTY_FETCH_RESULT_ERROR) {
            [weakSelf alert:@"Keine Kunden mit dieser Vertreternummer gefunden."];
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.hud];
}

- (void)addPreload {
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.hud];
    [self.view bringSubviewToFront:self.hud];
    
    self.hud.labelText = @"Logging";
    [self.hud show: YES];
}

- (void)removePreload {
    [self.hud hide:YES];
}

- (void)checkStoredVertreterCode {
    NSString *vertreterCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"VertreterCode"];
    if(vertreterCode) {
        [self loginWitVertreterCode:vertreterCode];
    }
}

@end
