//
//  CollectDataViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CollectDataViewController.h"
#import "ScrollViewToPDF.h"

@interface CollectDataViewController()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeight;
@end

@implementation CollectDataViewController

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self renderPDF];
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


@end
