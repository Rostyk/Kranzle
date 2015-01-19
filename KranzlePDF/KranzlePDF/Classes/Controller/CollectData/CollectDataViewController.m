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

@interface CollectDataViewController()
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
@property (nonatomic, strong) IBOutletCollection(DuplicatableLabel) NSArray *labels;

@property (nonatomic, weak) IBOutlet UITextField *ortAndNameTextField1;
@property (nonatomic, weak) IBOutlet UITextField *ortAndNameTextField2;

@property (nonatomic, weak) IBOutlet UITextField *fachhandelsvertragTextField;
@property (nonatomic, weak) IBOutlet UILabel *fachhandelsvertragLabel;
@property (nonatomic, weak) IBOutlet UITextField *konditionsvereinbarungTextField;
@property (nonatomic, weak) IBOutlet UILabel *konditionsvereinbarungLabel;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet DuplicatableLabel *kdnLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *nameLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *name2Label;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *streetLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *plzLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *ortLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *wwwLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *emailLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *verbandLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *emailVertreterLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *verbandsNumberLabel;
@end

@implementation CollectDataViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.duplicatedLabels = [[NSMutableArray alloc] init];
    [self setupRightNavigationItem];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = self.scrollView.delaysContentTouches;
    
    [self populateCustomerData];
    /*removed in the lst update */
    //[self addCheckBoxes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark display customer data on form

- (void)populateCustomerData {
    //Fill in customer data
    self.nameLabel.text = self.customer.name;
    self.name2Label.text = self.customer.name2;
    self.streetLabel.text = self.customer.street;
    self.plzLabel.text = self.customer.plz;
    self.ortLabel.text = self.customer.ort;
    self.wwwLabel.text = self.customer.www;
    self.emailLabel.text = self.customer.email;
    self.verbandLabel.text = self.customer.verband;
    self.emailVertreterLabel.text = self.customer.email;
    self.verbandsNumberLabel.text = self.customer.verbandsNumber;
    self.kdnLabel.text = self.customer.number;
    
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
    /*
    UILabel *valueLabel = [[UILabel alloc] initWithFrame: self.selectedButton.frame];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = [NSString stringWithFormat:@"%ld", value];
    [self.scrollView addSubview: valueLabel];
    [self.selectedButton removeFromSuperview];
     */
    
    /*prevent the value to be added to the sum multiple times*/
    if(![self isNumber:self.selectedButton.currentTitle] || self.selectedButton.currentTitle.length == 0) {
        [self setTitle:[NSString stringWithFormat:@"%ld", value] forButton:self.selectedButton];
        self.sum += value;
        self.sumLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.sum];
    }
    
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
    self.sumLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.sum];
    [self setTitle:@"" forButton:self.selectedButton];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)setTitle:(NSString *)title forButton:(UIButton *)button
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
}
- (BOOL)isNumber:(NSString*)string {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self.selectedButton.titleLabel.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    
    return NO;
}


#pragma mark text filed delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.fachhandelsvertragTextField)
        self.fachhandelsvertragLabel.text = textField.text;
    if(textField == self.konditionsvereinbarungTextField)
        self.konditionsvereinbarungLabel.text = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField == self.bottomName1TextField || textField == self.bottomName2TextField) {
        [self.scrollView setContentOffset:CGPointMake(0, 1128) animated:YES];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    int y = self.view.bounds.size.height - self.keyboardHeight;
    

    if(textField == self.bottomName1TextField || textField == self.bottomName2TextField) {
        [self.scrollView setContentOffset:CGPointMake(0,  [self.contentView convertPoint:textField.frame.origin toView:self.scrollView].y - y + textField.frame.size.height) animated:YES];
    }
}

#pragma mark keyboard

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    self.keyboardHeight = keyboardFrame.size.height;
}


#pragma mark duplicate labels

/* duplicate the labels and add them on the second page of the pdf
 Its done in viewDidLayoutSubviews cause its when outlets get proper frames*/
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (DuplicatableLabel *label in self.labels) {
        if(CGRectContainsRect(self.scrollView.bounds, label.frame) && (self.duplicatedLabels.count < self.labels.count)) {
            [self duplicateLabel:self.kdnLabel withVerticalOffset:1096];
            [self duplicateLabel:self.nameLabel withVerticalOffset:1096];
            [self duplicateLabel:self.name2Label withVerticalOffset:1102];
            [self duplicateLabel:self.streetLabel withVerticalOffset:1107];
            [self duplicateLabel:self.verbandLabel withVerticalOffset:1122];
            [self duplicateLabel:self.ortLabel withVerticalOffset:1112];
            [self duplicateLabel:self.verbandsNumberLabel withVerticalOffset:1122];
            [self duplicateLabel:self.wwwLabel withVerticalOffset:1112];
            [self duplicateLabel:self.emailLabel withVerticalOffset:1118];
            [self duplicateLabel:self.emailVertreterLabel withVerticalOffset:1128];
        }
    }
    
    [self.contentView bringSubviewToFront:self.lagerwareCheckbox];
    [self.contentView bringSubviewToFront:self.exclusivitatCheckbox];
}

- (void)duplicateLabel:(DuplicatableLabel *)label withVerticalOffset:(int)offset {
    if(label.duplicated == NO) {
        CGRect frame = [label frame];
        frame.origin.y += offset;
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:frame];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = label.font;
        newLabel.textAlignment = label.textAlignment;
        newLabel.adjustsFontSizeToFitWidth = YES;
        newLabel.minimumScaleFactor = label.minimumScaleFactor;
        newLabel.text = label.text;
        label.duplicated = YES;
        
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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(mailPDF)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

#pragma mark render/mail pdf
- (void)mailPDF {
    [self renderPDF];
    [self mail];
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
    [pdfData writeToFile:pdfFileName atomically:NO];
}

- (void)mail {
    NSArray *mails =  @[@"konditionsvereinbarung@kraenzle.com"];
    if(self.customer.email.length > 0)
        mails = @[@"konditionsvereinbarung@kraenzle.com", self.customer.email];
    [self mailTo: mails];
}

- (void)mailTo:(NSArray *)mailAddresses {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:mailAddresses];
        if(self.customer.emailVertreter)
           [composeViewController setCcRecipients: @[self.customer.emailVertreter]];
        [composeViewController setSubject:@"Kranzle Pdf"];
        
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
        
        [composeViewController addAttachmentData:data mimeType:@"application/pdf" fileName:@"Form.pdf"];
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
    controller.delegate = self;
    controller.drawingView.frame = CGRectMake(0, 0, 500, 500);
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
