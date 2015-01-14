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
#import "PDFRenderer.h"

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
    /*
    //disimss the keyboard
    [self.salesIDTextfield resignFirstResponder];
    
    NSString *customerNumber = self.salesIDTextfield.text;
    NSArray *customerRecord = [[DataProvider sharedProvider] recordForCustomerNumber:customerNumber];
    if(!customerRecord) {
        [self alert:[ NSString stringWithFormat:@"Customer with number %@ not found in our database", customerNumber]];
        return;
    }
    
    Customer *customer = [[Customer alloc] initWithRecord: customerRecord];
    //setup the renderer to display customer info
    [[PDFRenderer sharedRenderer] insertCustomerData: customer];
    [[PDFRenderer sharedRenderer] render];
    */
    [self showCollectDataViewController];
}


#pragma mark open collect data view controller

-(void) showCollectDataViewController{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataViewController *controller = (CollectDataViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataViewControllerID"];
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
