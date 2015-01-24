//
//  CollectDataViewController.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectDataPopoverContentViewController.h"
#import <MessageUI/MessageUI.h>
#import "SigningViewController.h"

typedef enum {
    ACTION_SENDEN = 0
} ACTION_SHEET_ACTION;


@class Customer;

@interface CollectDataViewController : UIViewController<CollectDataPopoverDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate, SigningDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) Customer *customer;
@end
