//
//  DataProvider.h
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject

+ (instancetype)sharedProvider;

- (NSArray *)recordForCustomerNumber:(NSString*)number;
@end
