//
//  RabatModel.h
//  KranzlePDF
//
//  Created by Ross on 1/25/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RabatModel : NSObject
- (id)initWithArrayOfButtons:(NSArray *)buttons;
- (void) setMutualExclusiveRabats:(NSArray *)rabatsArray1 withRabats:(NSArray *)rabatsArray2;
- (void)rabatSelected:(UIButton *)button remove:(BOOL)remove;

@property (nonatomic, readonly) NSUInteger sum;
@end
