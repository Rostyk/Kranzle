//
//  RabatModel.m
//  KranzlePDF
//
//  Created by Ross on 1/25/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "RabatModel.h"

@interface RabatModel()
@property (nonatomic, strong) NSMutableDictionary *buttons;
@property (nonatomic, strong) NSMutableArray *exclusions;
@end
@implementation RabatModel

#pragma mark  lifecycle
- (id)initWithArrayOfButtons:(NSArray *)buttons {
    self = [super init];
    self.buttons = [[NSMutableDictionary alloc] init];
    for (UIButton *button in buttons) {
        [self.buttons setObject:button forKey:@(button.tag)];
    }
    return self;
}

#pragma mark mutual exclusive rabats
- (void) setMutualExclusiveRabats:(NSArray *)rabatsArray1 withRabats:(NSArray *)rabatsArray2 {
    [self.exclusions addObject: @[rabatsArray1, rabatsArray2]];
}

- (NSMutableArray *)exclusions {
    if(!_exclusions)
        _exclusions = [[NSMutableArray alloc] init];
    
    return _exclusions;
}

- (void)rabatSelected:(UIButton *)button remove:(BOOL)remove {
    for (NSArray *rabatsArray in self.exclusions) {
        NSArray *rabats1 = rabatsArray[0];
        NSArray *rabats2 = rabatsArray[1];
        
        if([rabats1 containsObject:@(button.tag)]) {
            for(NSNumber *mutuallyExclusiveButtonTag in rabats2)
                ((UIButton *)self.buttons[mutuallyExclusiveButtonTag]).hidden = !remove;
        }
    }
}

- (NSUInteger)sum {
    NSUInteger realSum = 0;
    
    for(NSObject *key in self.buttons.allKeys) {
        UIButton *button = self.buttons[key];
        if(button.hidden == NO && [self isNumber:button.currentTitle])
            realSum += button.currentTitle.integerValue;
    }
    
    return realSum;
}

#pragma mark check number
- (BOOL)isNumber:(NSString*)string {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

@end
