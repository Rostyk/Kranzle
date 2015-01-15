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

@interface CollectDataViewController()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) M13Checkbox *lagerwareCheckbox;
@property (nonatomic, strong) M13Checkbox *exclusivitatCheckbox;

@property (nonatomic, strong) NSMutableArray *duplicatedLabels;
@property (nonatomic, strong) IBOutletCollection(DuplicatableLabel) NSArray *labels;
@property (nonatomic, weak) IBOutlet UITextField *fachhandelsvertragTextField;
@property (nonatomic, weak) IBOutlet UILabel *fachhandelsvertragLabel;
@property (nonatomic, weak) IBOutlet UITextField *konditionsvereinbarungTextField;
@property (nonatomic, weak) IBOutlet UILabel *konditionsvereinbarungLabel;


@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;


@property (nonatomic, weak) IBOutlet DuplicatableLabel *nameLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *name2Label;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *streetLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *plzLabel;
@property (nonatomic, weak) IBOutlet DuplicatableLabel *ortLabel;
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
    [self addCheckBoxes];
}

#pragma mark display customer data on form

- (void)populateCustomerData {
    self.nameLabel.text = self.customer.name;
    self.name2Label.text = self.customer.name2;
    self.streetLabel.text = self.customer.street;
    self.plzLabel.text = self.customer.plz;
    self.ortLabel.text = self.customer.ort;
    self.emailLabel.text = self.customer.email;
    self.verbandLabel.text = self.customer.verband;
    self.emailVertreterLabel.text = self.customer.email;
    self.verbandsNumberLabel.text = self.customer.verbandsNumber;
    
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
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame: self.selectedButton.frame];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = [NSString stringWithFormat:@"%ld", value];
    [self.scrollView addSubview: valueLabel];
    
    [self.selectedButton removeFromSuperview];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)removeValueDidSelect {
    [self.selectedButton removeFromSuperview];
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark text filed delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == self.fachhandelsvertragTextField)
        self.fachhandelsvertragLabel.text = textField.text;
    if(textField == self.konditionsvereinbarungTextField)
        self.konditionsvereinbarungLabel.text = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark duplicate labels

/* duplicate the labels and add them on the second page of the pdf
 Its done in viewDidLayoutSubviews cause its when outlets get proper frames*/
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (DuplicatableLabel *label in self.labels) {
        if(CGRectContainsRect(self.scrollView.bounds, label.frame) && (self.duplicatedLabels.count < self.labels.count)) {
            [self duplicateLabel:self.nameLabel withVerticalOffset:1096];
            [self duplicateLabel:self.name2Label withVerticalOffset:1102];
            [self duplicateLabel:self.streetLabel withVerticalOffset:1107];
            [self duplicateLabel:self.verbandLabel withVerticalOffset:1122];
            [self duplicateLabel:self.ortLabel withVerticalOffset:1112];
            [self duplicateLabel:self.verbandsNumberLabel withVerticalOffset:1122];
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
    [self mailTo: @"info@cluster-one.eu"];
}

- (void)mailTo:(NSString *)mail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[mail]];
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

@end
