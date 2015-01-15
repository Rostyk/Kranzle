//
//  ScrollViewToPDF.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScrollViewToPDF : NSObject

+ (NSData *)pdfDataOfScrollView:(UIScrollView *)scrollView;

@end