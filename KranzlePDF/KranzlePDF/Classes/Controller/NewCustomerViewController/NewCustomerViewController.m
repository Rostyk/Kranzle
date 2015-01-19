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

@property (nonatomic, weak) IBOutlet UITextField *kdnTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *name2TextField;
@property (nonatomic, weak) IBOutlet UITextField *name3TextField;
@property (nonatomic, weak) IBOutlet UITextField *streetTextField;
@property (nonatomic, weak) IBOutlet UITextField *plzTextField;
@property (nonatomic, weak) IBOutlet UITextField *ortTextField;
@property (nonatomic, weak) IBOutlet UITextField *landTextField;
@property (nonatomic, weak) IBOutlet UITextField *telefonTextField;
@property (nonatomic, weak) IBOutlet UITextField *telefaxTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *wwwTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandsCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandTextField;

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@end

@implementation NewCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createdCustomer = [[DataProvider sharedProvider] createNewCustomer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   
}

#pragma mark submit new customer
- (IBAction)submitButtonClicked:(id)sender {
    if([self validateFields]) {
        [self setupCustomer];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setupCustomer {
    self.createdCustomer.number = self.kdnTextField.text;
    self.createdCustomer.name = self.nameTextField.text;
    self.createdCustomer.name2 = self.name2TextField.text;
    self.createdCustomer.name3 = self.name3TextField.text;
    self.createdCustomer.street = self.streetTextField.text;
    self.createdCustomer.plz = self.plzTextField.text;
    self.createdCustomer.ort = self.ortTextField.text;
    //self.createdCustomer.land = self.landTextField.text;
    //self.createdCustomer.telefon = self.telefonTextField.text;
    //self.createdCustomer.telefax = self.telefaxTextField.text;
    self.createdCustomer.email = self.emailTextField.text;
    //self.createdCustomer.www = self.wwwTextField.text;
    self.createdCustomer.verbandsNumber = self.verbandsCodeTextField.text;
    self.createdCustomer.manuallyCreated = @(YES);
    self.createdCustomer.verband = self.verbandTextField.text;
    self.createdCustomer.vertreterCode = [[DataProvider sharedProvider] lastUsedVertreterCode];
    
}

#pragma mark textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark validate fields
- (BOOL)validateFields {
    if(self.kdnTextField.text.length < 1) {
         [self alert:@"Please enter Kdn."];
        return NO;
    }
    if(self.nameTextField.text.length < 1) {
        [self alert:@"Please enter Name"];
        return NO;
    }
    
    if(self.streetTextField.text.length < 1) {
        [self alert:@"Please enter street"];
        return NO;
    }
    
    return YES;
}

#pragma mark display alert

- (void)alert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}




@end
