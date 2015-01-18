//
//  DataProvider.h
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchCSVRecordsSuccess)(NSArray *records);
typedef void (^FetchError)(NSError *error);

@interface DataProvider : NSObject
@property (nonatomic, strong) NSArray *fetchedRows;

+ (instancetype)sharedProvider;
- (void)fetchRecordsForSalesmenNumber:(NSString*)number sucess:(FetchCSVRecordsSuccess)successBlock failure:(FetchError)failure;

@end
