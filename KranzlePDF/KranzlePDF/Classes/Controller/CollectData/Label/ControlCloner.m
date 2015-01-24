//
//  ControlCloner.m
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "ControlCloner.h"
#import "DuplicatableLabel.h"
#import "DuplicatableTextField.h"

@implementation ControlCloner

+ (UILabel *)clone:(UIView *)view withOffset:(NSUInteger)offset{
    
    BOOL duplicated = NO;
    NSString *text = @"";
    UIFont *font;
    float fontScaleFactor = 0.6;
    NSTextAlignment textAlignment;
    if([view isKindOfClass:[DuplicatableLabel class]]) {
        DuplicatableLabel *label = (DuplicatableLabel *)view;
        duplicated = label.duplicated;
        text = label.text;
        font = label.font;
        fontScaleFactor = label.minimumScaleFactor;
        textAlignment = label.textAlignment;
    }
    else if([view isKindOfClass:[UITextField class]]) {
        DuplicatableTextField *textField =(DuplicatableTextField *)view;
        duplicated = textField.duplicated;
        text = textField.text;
        font = textField.font;
        textAlignment = textField.textAlignment;
    }
    else
        return nil;

    if(duplicated == NO) {
        CGRect frame = [view frame];
        frame.origin.y += offset;
        NSLog(@"Label: %@", text);
        UILabel *newLabel = [[UILabel alloc] initWithFrame:frame];
        newLabel.backgroundColor = [UIColor clearColor];
        newLabel.font = font;
        newLabel.textAlignment = textAlignment;
        newLabel.adjustsFontSizeToFitWidth = YES;
        newLabel.minimumScaleFactor = fontScaleFactor;
        newLabel.text = text;
        return newLabel;
    }
    else
        return nil;

}

@end
