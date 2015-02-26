//
//  CacheItem.m
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CacheItem.h"

@interface CacheItem()
@property (nonatomic, strong) NSMutableDictionary *fields;
@property (nonatomic, strong) NSMutableDictionary *buttons;
@end


@implementation CacheItem

- (id)initWithCustomer:(Customer *)customer {
    self = [super init];
    _customer = customer;
    self.fields = [[NSMutableDictionary alloc] init];
    self.buttons = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)saveTexTField:(UITextField *)textField {
    [self.fields setObject:textField.text forKey:@(textField.tag)];
}

- (void)restoreTextForTextField:(UITextField *)textField {
    NSString *text = [self.fields objectForKey:@(textField.tag)];
    if(text)
      textField.text = text;
}

- (void)saveButton:(UIButton *)button withImage:(BOOL)saveImage{
    if(saveImage) {
        [self.buttons setObject:@{@"title" : (button.currentTitle) ? button.currentTitle : [NSNull null], @"image" : (button.currentBackgroundImage) ? button.currentBackgroundImage : [NSNull null], @"hidden" : @(button.hidden)} forKey:@(button.tag)];
    }
    else {
        [self.buttons setObject:@{@"title" : button.currentTitle, @"image" : [NSNull null],  @"hidden" : @(button.hidden)} forKey:@(button.tag)];
    }
}

- (void)restoreButton:(UIButton *)button {
    NSString *title = [[self.buttons objectForKey:@(button.tag)] objectForKey:@"title"];
    UIImage *image = [[self.buttons objectForKey:@(button.tag)] objectForKey:@"image"];
    BOOL hidden = [[[self.buttons objectForKey:@(button.tag)] objectForKey:@"hidden"] boolValue];
    
    if([title isKindOfClass:[NSString class]]) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateSelected];
    }
    if([image isKindOfClass:[UIImage class]]) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    button.hidden = hidden;
}

@end
