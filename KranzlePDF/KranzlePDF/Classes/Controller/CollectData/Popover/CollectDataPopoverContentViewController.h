//
//  CollectDataPopoverController.h
//  KranzlePDF
//
//  Created by Ross on 1/14/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectDataPopoverDelegate <NSObject>
- (void)defaultValueDidSelect;
- (void)removeValueDidSelect;
@end

@interface CollectDataPopoverContentViewController : UIViewController
@property (nonatomic, weak) id<CollectDataPopoverDelegate> delegate;
@end
