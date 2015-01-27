//
//  CollectDataViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CollectDataViewController.h"
#import "ScrollViewToPDF.h"
#import "M13Checkbox.h"
#import "Customer.h"
#import "Constants.h"
#import "DuplicatableLabel.h"
#import "SigningViewController.h"
#import "UIImage+scale.h"
#import "ControlCloner.h"
#import "DuplicatableTextField.h"
#import "TextCache.h"
#import "RabatModel.h"

@interface CollectDataViewController()
@property (nonatomic, strong) RabatModel *rabatsModel;
@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) M13Checkbox *lagerwareCheckbox;
@property (nonatomic, strong) M13Checkbox *exclusivitatCheckbox;
@property (nonatomic, strong) NSMutableArray *duplicatedLabels;
@property (nonatomic) NSUInteger sum;
@property (nonatomic) NSUInteger keyboardHeight;

@property (nonatomic, weak) IBOutlet UITextField *bottomName1TextField;
@property (nonatomic, weak) IBOutlet UITextField *bottomName2TextField;

@property (nonatomic, strong) UIButton *selectedSignButton;
@property (nonatomic, weak) IBOutlet UIButton *fachhandelsPartnerSignButton;
@property (nonatomic, weak) IBOutlet UIButton *kranzleSignButton;

@property (nonatomic, weak) IBOutlet UILabel *sumLabel;
/*all the labels need to be duplicated in the seccond page should be added to this outlet collection(labels)*/
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *labels;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *selectButtons;

@property (nonatomic, weak) IBOutlet UITextField *ortAndNameTextField1;
@property (nonatomic, weak) IBOutlet UITextField *ortAndNameTextField2;

@property (nonatomic, weak) IBOutlet UITextField *fachhandelsvertragTextField;
@property (nonatomic, weak) IBOutlet UITextField *konditionsvereinbarungTextField;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UITextField *ansprechpartnerTextField;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *rabatLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *bottomRabatLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *kdnLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *name2TextField;
@property (nonatomic, weak) IBOutlet UITextField *streetTextField;
@property (nonatomic, weak) IBOutlet UITextField *plzTextField;
@property (nonatomic, weak) IBOutlet UITextField *ortTextField;
@property (nonatomic, weak) IBOutlet UITextField *telefonTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *wwwTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandsCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField *verbandTexField;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *vertreterNameLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *vertreterTelefoneLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *emailVertreterLabel;
@property (nonatomic, weak) IBOutlet UITextField *verbandsNumberTextField;
@end

@implementation CollectDataViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.duplicatedLabels = [[NSMutableArray alloc] init];
    
    [self setupRightNavigationItem];
    [self setupRabatsModel];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = self.scrollView.delaysContentTouches;
    
    [self populateCustomerData];
    [self registerForKeyboardNotifications];
    
    [[TextCache sharedCache] startCachingCustomer:self.customer];
    [TextCache sharedCache].cacheType = CACHE_TYPE_SINGLE_CUSTOMER;
    [self restoreFields];
    /*removed in the lst update */
    //[self addCheckBoxes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark display customer data on form

- (void)populateCustomerData {
    
    //Fill in customer data
    self.nameTextField.text = self.customer.name;
    self.name2TextField.text = self.customer.name2;
    self.streetTextField.text = self.customer.street;
    self.plzTextField.text = self.customer.plz;
    self.ortTextField.text = self.customer.ort;
    self.telefonTextField.text = self.customer.telefon;
    self.emailTextField.text = self.customer.email;
    self.wwwTextField.text = self.customer.www;
    self.verbandsCodeTextField.text = self.customer.verbandsCode;
    self.verbandTexField.text = self.customer.verband;
    self.vertreterNameLabel.text = self.customer.nameVertreter;
    self.vertreterTelefoneLabel.text = self.customer.telefonVertreter;
    self.emailVertreterLabel.text = self.customer.emailVertreter;
    self.verbandsNumberTextField.text = self.customer.verbandsNumber;
    self.kdnLabel.text = self.customer.number;
    self.ansprechpartnerTextField.text = self.customer.ansprechpartner;
    
    //Set Ort und datum
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *stringDate = [formatter stringFromDate: [[NSDate alloc] init]];
    if(self.customer.ort.length > 0) {
        self.ortAndNameTextField1.text = [NSString stringWithFormat:@"%@, %@", self.customer.ort, stringDate];
        self.ortAndNameTextField2.text = [NSString stringWithFormat:@"%@, %@", self.customer.ort, stringDate];
    }
    else {
        self.ortAndNameTextField1.text = [NSString stringWithFormat:@"%@", stringDate];
        self.ortAndNameTextField2.text = [NSString stringWithFormat:@"%@", stringDate];
    }
}

#pragma mark collect data button handlers

- (IBAction)formButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    self.selectedButton = button;
    [self addPopoverNearButtonFrame:button.frame];
}

#pragma mark add popover

-(void) addPopoverNearButtonFrame:(CGRect)frame {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataPopoverContentViewController *contentController = (CollectDataPopoverContentViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataPopoverContentViewControllerID"];
    contentController.delegate = self;
    self.popover = [[UIPopoverController alloc] initWithContentViewController:contentController];
    self.popover.popoverContentSize = CGSizeMake(120, 80);
    
    frame.origin.y -= self.scrollView.bounds.origin.y; // you can postion the popover with + and - values
    frame.origin.y += frame.size.height/2;
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark popover delegate

- (void)defaultValueDidSelect {
    long value = [FORM_VALUES[self.selectedButton.tag] integerValue];
    
    /*prevent the value to be added to the sum multiple times*/
    if(![self isNumber:self.selectedButton.currentTitle] || self.selectedButton.currentTitle.length == 0) {
        [self setTitle:[NSString stringWithFormat:@"%ld", value] forButton:self.selectedButton];
        self.sum += value;
    }
    
    //tell the model some rabat is selected
    [self.rabatsModel rabatSelected:self.selectedButton remove:NO];
    [self updateSumLabel];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)removeValueDidSelect {
    [self.selectedButton setBackgroundColor:[UIColor clearColor]];
    
    /*check if it was previously set to the default value.
     If yes, we need to subtract this value from the sum*/
    if ([self isNumber:self.selectedButton.currentTitle])
    {
        self.sum -= [self.selectedButton.titleLabel.text integerValue];
    }
    [self setTitle:@"Wählen" forButton:self.selectedButton];
    
    //tell the model some rabat is selected
    [self.rabatsModel rabatSelected:self.selectedButton remove:YES];
    [self updateSumLabel];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)updateSumLabel {
    NSUInteger sum = self.rabatsModel.sum;
    self.sumLabel.text = [NSString stringWithFormat:@"%lu", sum];
    self.rabatLabel.text = [NSString stringWithFormat:@"l %lu", sum];
    self.bottomRabatLabel.text = [NSString stringWithFormat:@"l %lu", sum];
   
}

- (void)setTitle:(NSString *)title forButton:(UIButton *)button
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
}

- (BOOL)isNumber:(NSString*)string {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark text filed delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (IBAction)textFieldDidChange:(id)sender {
    /*
    UITextField *textField = (UITextField *)sender;
    if([self.labels containsObject:textField]) {
        //we remove all 16 labels and add duplicate them again.
        // Reafctor it for a single label later
        [self clearDuplicatedLabels];
        [self duplicateLabels];
    }
*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.labels containsObject:textField]) {
        /*we remove all 16 labels and add duplicate them again.
         Reafctor it for a single label later*/
        [self clearDuplicatedLabels];
        [self duplicateLabels];
    }
    [[TextCache sharedCache] saveTexTField:textField];
    self.activeField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == self.bottomName1TextField || textField == self.bottomName2TextField) {
        [self.scrollView setContentOffset:CGPointMake(0, 1128) animated:YES];
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark duplicate labels

/* duplicate the labels and add them on the second page of the pdf
 Its done in viewDidLayoutSubviews cause its when outlets get proper frames*/
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self duplicateLabels];
}

- (void)duplicateLabels {
    for (DuplicatableLabel *label in self.labels) {
        if(CGRectContainsRect(self.scrollView.bounds, label.frame) && (self.duplicatedLabels.count < self.labels.count)) {
            
            [self duplicateView:self.kdnLabel withVerticalOffset:1096];
            [self duplicateView:self.nameTextField withVerticalOffset:1096];
            [self duplicateView:self.name2TextField withVerticalOffset:1102];
            [self duplicateView:self.streetTextField withVerticalOffset:1107];
            [self duplicateView:self.verbandTexField withVerticalOffset:1122];
            [self duplicateView:self.plzTextField withVerticalOffset:1112];
            [self duplicateView:self.ortTextField withVerticalOffset:1112];
            [self duplicateView:self.telefonTextField withVerticalOffset:1118];
            [self duplicateView:self.ansprechpartnerTextField withVerticalOffset:1118];
            [self duplicateView:self.verbandsNumberTextField withVerticalOffset:1122];
            [self duplicateView:self.wwwTextField withVerticalOffset:1112];
            [self duplicateView:self.emailTextField withVerticalOffset:1118];
            [self duplicateView:self.verbandsCodeTextField withVerticalOffset:1122];
            [self duplicateView:self.vertreterNameLabel withVerticalOffset:1129];
            [self duplicateView:self.vertreterTelefoneLabel withVerticalOffset:1129];
            [self duplicateView:self.emailVertreterLabel withVerticalOffset:1129];
            [self duplicateView:self.fachhandelsvertragTextField withVerticalOffset:1132];
            [self duplicateView:self.konditionsvereinbarungTextField withVerticalOffset:1132];
        }
    }
}

- (void)clearDuplicatedLabels {
    for (DuplicatableLabel *label in self.duplicatedLabels) {
        [label removeFromSuperview];
    }
    [self.duplicatedLabels removeAllObjects];
}

- (void)duplicateView:(UIView *)view withVerticalOffset:(int)offset {
    UILabel *newLabel = [ControlCloner clone:view withOffset:offset];
    if(newLabel) {
        [self.duplicatedLabels addObject:newLabel];
        [self.contentView addSubview:newLabel];
    }
}

#pragma mark add check boxes

- (void)addCheckBoxes {
    self.lagerwareCheckbox = [[M13Checkbox alloc] initWithFrame: CGRectMake(108, 681, 15, 15)];
    self.exclusivitatCheckbox = [[M13Checkbox alloc] initWithFrame: CGRectMake(180, 681, 15, 15)];
    self.lagerwareCheckbox.checkColor = [UIColor blackColor];
    self.exclusivitatCheckbox.checkColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.lagerwareCheckbox];
    [self.contentView addSubview:self.exclusivitatCheckbox];
}

#pragma mark right navigation button

- (void)setupRightNavigationItem {
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(mailButtonClicked)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

#pragma mark action sheet
- (void)showActionSheet {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Nicht gesetzte angaben werden mit \"Keine\" bzw. \"nicht vorhanden\" gefüllt." delegate:self cancelButtonTitle:@"Angaben ergänzen" destructiveButtonTitle:nil otherButtonTitles:@"Senden", @"Angaben ergänzen", nil];
    popup.tag = 1;
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case ACTION_SENDEN: {
                    [self mail];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark render/mail pdf

- (void)mailButtonClicked {
    [self.activeField resignFirstResponder];
    
    if([self checkFieldsAvailableForInput]) {
        [self mail];
    }
    else {
        [self alert:@"Bitte füllen Sie alle Eingabefelder aus. Informationen die nicht in Erfahrung zu bringen sind, können mit \"nicht vorhanden\" oder \"Keine\" gesetzt werden. Diese Angaben erscheinen dann nicht auf dem Formular"];
    }
}

- (void)mail {
    [self clearDuplicatedLabels];
    [self duplicateLabels];
    
    [self showSelectButtons:NO];
    [self hideEmptyFieldsWithText:YES];
    
    
    [self renderPDF];
    [self showSelectButtons:YES];
    [self hideEmptyFieldsWithText:NO];
    [self mailPDF];
}

- (void)renderPDF {
    NSData *pdfData = [ScrollViewToPDF pdfDataOfScrollView:self.scrollView];
    NSString* fileName = @"Form.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    NSLog(@"%@", pdfFileName);
    [pdfData writeToFile:pdfFileName atomically:YES];
}

- (void)mailPDF {
    NSArray *mails =  @[@"konditionsvereinbarung@kraenzle.com"];
    if(self.customer.email.length > 0)
        mails = @[@"konditionsvereinbarung@kraenzle.com", self.customer.email];
    if(self.emailTextField.text.length > 0)
        mails = @[@"konditionsvereinbarung@kraenzle.com", self.emailTextField.text];
    [self mailTo: mails];
}

- (void)mailTo:(NSArray *)mailAddresses {
    if ([MFMailComposeViewController canSendMail]) {
        NSString *subjectName = [NSString stringWithFormat:@"%@ Konditionsvereinbarung.pdf", self.customer.number];
        
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:mailAddresses];
        if(self.customer.emailVertreter)
           [composeViewController setCcRecipients: @[self.customer.emailVertreter]];
        [composeViewController setSubject:subjectName];
        
        NSString* fileName = @"Form.pdf";
        
        NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(
                                            NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
        NSString *path = [arrayPaths objectAtIndex:0];
        NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
        NSURL *url = [NSURL fileURLWithPath:pdfFileName];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        [composeViewController addAttachmentData:data mimeType:@"application/pdf" fileName:subjectName];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark signing delegate

- (void)signingController:(SigningViewController*)signingController didSignWithImage:(UIImage*)image {
    [self.selectedSignButton setBackgroundImage:[image imageByScalingAndCroppingForSize:self.selectedSignButton.frame.size] forState:UIControlStateNormal];
}

#pragma mark sign buttons handlers

- (IBAction)fachhandelsPartnerSignButtonClicked:(id)sender {
    self.selectedSignButton = self.fachhandelsPartnerSignButton;
    [self showSigningViewController];
}

- (IBAction)kranzleSignButtonCliked:(id)sender {
    self.selectedSignButton = self.kranzleSignButton;
    [self showSigningViewController];
}

- (void)showSigningViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SigningViewController *controller = (SigningViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"SigningViewControllerID"];
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    controller.delegate = self;
    controller.drawingView.frame = CGRectMake(0, 0, 500, 500);
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)showSelectButtons:(BOOL)visibility {
    for (UIButton *button in self.selectButtons) {
        /*if the button has any value picked, not a 'Wahlen' text*/
        if(![self isNumber:button.currentTitle])
            button.hidden = !visibility;
    }
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

#pragma mark cahce

- (void)restoreFields {
    for(UIView *view in self.labels) {
        if([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            [[TextCache sharedCache] restoreTextForTextField:field];
        }
    }
    
    [[TextCache sharedCache] restoreTextForTextField:self.bottomName1TextField];
    [[TextCache sharedCache] restoreTextForTextField:self.bottomName2TextField];
    [[TextCache sharedCache] restoreTextForTextField:self.ortAndNameTextField1];
    [[TextCache sharedCache] restoreTextForTextField:self.ortAndNameTextField2];
}

#pragma mark check fields

- (BOOL)checkFieldsAvailableForInput {
    for (UIView *view in self.labels) {
        if([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            if(field.text.length < 1) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)hideEmptyFieldsWithText:(BOOL)hide {
    for (UIView *view in self.labels) {
        if([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            NSString *string = [field.text lowercaseString];
            if([self compareNotFilledValue:string]) {
                field.hidden = hide;
            }
            
        }
    }
    for (UILabel *label in self.duplicatedLabels){
        NSString *string = [label.text lowercaseString];
        if([self compareNotFilledValue:string]) {
            label.hidden = hide;
        }
    }
}

- (BOOL)compareNotFilledValue:(NSString *)string {
    return ([string isEqualToString:@"keine"] || [string isEqualToString:@"nicht vorhanden"] || [string isEqualToString:@"k.a"] || [string isEqualToString:@"n.a"] || [string isEqualToString:@"keine angabe"]|| [string isEqualToString:@"n.v"]);
}

#pragma mark discounts

- (void)setupRabatsModel {
    self.rabatsModel = [[RabatModel alloc] initWithArrayOfButtons:self.selectButtons];
    
    //Set mutual exclusive discounts(see corresponding rabat buttons tags in IB)
    [self.rabatsModel setMutualExclusiveRabats:@[@(0)] withRabats:@[@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8)]];
    [self.rabatsModel setMutualExclusiveRabats:@[@(2)] withRabats:@[@(3)]];
    [self.rabatsModel setMutualExclusiveRabats:@[@(3)] withRabats:@[@(2)]];
    
    
    [self.rabatsModel setMutualExclusiveRabats:@[@(7)] withRabats:@[@(8)]];
    [self.rabatsModel setMutualExclusiveRabats:@[@(8)] withRabats:@[@(7)]];
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
