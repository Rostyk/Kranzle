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

@interface CollectDataViewController()
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIPopoverController *popover;

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
    valueLabel.text = [NSString stringWithFormat:@"%d", value];
    [self.scrollView addSubview: valueLabel];
    
    [self.selectedButton removeFromSuperview];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)removeValueDidSelect {
    [self.selectedButton removeFromSuperview];
    [self.popover dismissPopoverAnimated:YES];
}


@end
