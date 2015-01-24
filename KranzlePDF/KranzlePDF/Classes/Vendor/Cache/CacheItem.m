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
@end


@implementation CacheItem

- (id)initWithCustomer:(Customer *)customer {
    self = [super init];
    _customer = customer;
    self.fields = [[NSMutableDictionary alloc] init];
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

@end
