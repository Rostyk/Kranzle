//
//  DataProvider.h
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchCSVRecordSuccess)(NSArray *record);

@interface DataProvider : NSObject
+ (instancetype)sharedProvider;
- (void)fetchRecordForCustomerNumber:(NSString*)number sucess:(FetchCSVRecordSuccess)successBlock;
@end
