//
//  ControlCloner.h
//  KranzlePDF
//
//  Created by Ross on 1/24/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ControlCloner : NSObject

+ (UILabel *)clone:(UIView *)view withOffset:(NSUInteger)offset;

@end
