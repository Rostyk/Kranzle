//
//  OrderSigningViewController.m
//  RPTrade Plus
//
//  Created by Marlon on 30.01.14.
//
//

#import "SigningViewController.h"

@interface SigningViewController ()

@end

@implementation SigningViewController

- (IBAction)closeWindow:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okayAndClose:(id)sender
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(signingController:didSignWithImage:)]) {
            [self.delegate signingController:self didSignWithImage:self.drawingView.image];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end