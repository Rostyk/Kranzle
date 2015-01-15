//
//  KRScrollView.m
//  KranzlePDF
//
//  Created by Ross on 1/14/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "KRScrollView.h"

@implementation KRScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    UITouch *touch = [touches anyObject];
    
    if(touch.phase == UITouchPhaseMoved)
    {
        return NO;
    }
    else
    {
        return [super touchesShouldBegin:touches withEvent:event inContentView:view];
    }
}

@end
