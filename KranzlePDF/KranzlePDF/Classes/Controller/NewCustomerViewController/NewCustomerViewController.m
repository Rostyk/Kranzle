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
@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *kdnTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *name2TextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandsNummerTextField;
@property (nonatomic, weak) IBOutlet UITextField *streetTextField;
@property (nonatomic, weak) IBOutlet UITextField *plzTextField;
@property (nonatomic, weak) IBOutlet UITextField *ortTextField;
@property (nonatomic, weak) IBOutlet UITextField *landTextField;
@property (nonatomic, weak) IBOutlet UITextField *telefonTextField;
@property (nonatomic, weak) IBOutlet UITextField *telefaxTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *wwwTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandsCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandNumberTextField;
@property (nonatomic, weak) IBOutlet UITextField *ansprechpartnerTextField;
@property (nonatomic, weak) IBOutlet UITextField *vertreterNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *vertreterTelefonTextField;
@property (nonatomic, weak) IBOutlet UITextField *vertreterEmailTextField;

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@end

@implementation NewCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
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
    self.createdCustomer.street = self.streetTextField.text;
    self.createdCustomer.plz = self.plzTextField.text;
    self.createdCustomer.ort = self.ortTextField.text;
    self.createdCustomer.land = self.landTextField.text;
    self.createdCustomer.telefon = self.telefonTextField.text;
    self.createdCustomer.telefax = self.telefaxTextField.text;
    self.createdCustomer.email = self.emailTextField.text;
    self.createdCustomer.www = self.wwwTextField.text;
    self.createdCustomer.verbandsCode = self.verbandsCodeTextField.text;
    self.createdCustomer.manuallyCreated = @(YES);
    self.createdCustomer.verband = self.verbandNumberTextField.text;
    self.createdCustomer.verbandsNumber = self.verbandsNummerTextField.text;
    self.createdCustomer.nameVertreter = self.vertreterNameTextField.text;
    self.createdCustomer.telefonVertreter = self.vertreterTelefonTextField.text;
    self.createdCustomer.emailVertreter = self.vertreterEmailTextField.text;
    self.createdCustomer.ansprechpartner = self.ansprechpartnerTextField.text;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}


#pragma mark validate fields
- (BOOL)validateFields {
    if(self.kdnTextField.text.length < 1) {
         [self alert:@"Bitte geben Sie einen Kundennummer ein."];
        return NO;
    }
    if(self.nameTextField.text.length < 1) {
        [self alert:@"Bitte geben Sie einen Namen ein."];
        return NO;
    }
    
    if(self.streetTextField.text.length < 1) {
        [self alert:@"Bitte geben Sie eine Strasse ein."];
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

#pragma mark keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
