//
//  CollectDataPopoverController.m
//  KranzlePDF
//
//  Created by Ross on 1/14/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CollectDataPopoverContentViewController.h"

@implementation CollectDataPopoverContentViewController

- (IBAction)defaulValueButtonClicked:(id)sender {
    [self.delegate defaultValueDidSelect];
}

- (IBAction)removeValueDidSelect:(id)sender {
    [self.delegate removeValueDidSelect];
}

@end
