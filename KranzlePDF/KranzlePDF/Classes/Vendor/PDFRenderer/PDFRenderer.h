//
//  PDFRenderer.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Customer;

@interface PDFRenderer : NSObject

+ (instancetype)sharedRenderer;

- (void)insertCustomerData:(Customer*)customer;
- (void)render;
@end
