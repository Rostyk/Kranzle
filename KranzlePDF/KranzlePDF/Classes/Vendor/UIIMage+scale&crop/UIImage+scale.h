//
//  UIImage+scale.h
//  KranzlePDF
//
//  Created by Ross on 1/19/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(scale)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
