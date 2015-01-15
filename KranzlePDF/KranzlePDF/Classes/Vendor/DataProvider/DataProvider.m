//
//  DataProvider.m
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "DataProvider.h"
#import "Constants.h"
#import "CSVParser.h"



@implementation DataProvider

#pragma mark shared instance

+ (instancetype)sharedProvider
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}

#pragma mark init

- (id)init {
    self = [super init];
    return self;
}

#pragma mark search records

- (void)fetchRecordsForSalesmenNumber:(NSString*)number sucess:(FetchCSVRecordsSuccess)successBlock {
    if(self.rows) {
        [self fetchRecordsForSalesmenNumber:number success:successBlock];
    }
    else {
        [self parseAndSearchRecordNumber:number succes:successBlock];
    }
    
}

- (void)fetchRecordsForSalesmenNumber:(NSString *)number success:(FetchCSVRecordsSuccess)successBlock {
   
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"vertreterCode == %@", number];
    self.rows = [self.rows filteredArrayUsingPredicate:pred];
    
    successBlock(self.rows);
}

#pragma mark parse csv

- (void)parseAndSearchRecordNumber:(NSString *)number succes:(FetchCSVRecordsSuccess)success{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"customers" ofType:@"csv"];
        NSURL *url = [NSURL fileURLWithPath:path];
        weakSelf.rows = [CSVParser parseCSVIntoArrayOfArraysFromFile:[url path]
                                        withSeparatedCharacterString:@";"
                                                quoteCharacterString:nil];
        if(!weakSelf.rows)
            NSLog(@"Error constructing data provider");
                
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf fetchRecordsForSalesmenNumber:number success:success];
        });
            
    });
   
}
@end
