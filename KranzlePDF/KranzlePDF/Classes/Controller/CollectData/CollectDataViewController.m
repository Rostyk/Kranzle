//
//  CollectDataViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CollectDataViewController.h"
#import "ScrollViewToPDF.h"
#import "CollectDataPopoverContentViewController.h"
#import "M13Checkbox.h"
#import "Customer.h"

@interface CollectDataViewController()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;


@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *name2Label;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *plzLabel;
@property (nonatomic, weak) IBOutlet UILabel *ortLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *verbandLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailVertreterLabel;
@property (nonatomic, weak) IBOutlet UILabel *verbandsNumberLabel;
@end

@implementation CollectDataViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.panGestureRecognizer.delaysTouchesBegan = self.scrollView.delaysContentTouches;
    
    [self populateCustomerData];
}

#pragma mark render pdf

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

- (IBAction)rabatButtonClicked:(id)sender {
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataPopoverContentViewController *contentController = (CollectDataPopoverContentViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataPopoverContentViewControllerID"];
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:contentController];
    popoverController.popoverContentSize = CGSizeMake(120, 80);
    CGRect frame = ((UIButton *)sender).frame;
    frame.origin.y += frame.size.height;
    frame.origin.y -= self.scrollView.bounds.origin.y; // you can postion the popover with + and - values
    [popoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


@end
