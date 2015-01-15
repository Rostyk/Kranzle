//
//  DataProvider.h
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchCSVRecordsSuccess)(NSArray *records);

@interface DataProvider : NSObject
@property (nonatomic, strong) NSArray *rows;

+ (instancetype)sharedProvider;
- (void)fetchRecordsForSalesmenNumber:(NSString*)number sucess:(FetchCSVRecordsSuccess)successBlock;

@end
