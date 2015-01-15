//
//  DataProvider.m
//  KranzlePDF
//
//  Created by Ross on 1/12/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "DataProvider.h"
#import "CHCSVParser.h"
#import "Constants.h"
#import "CSVParser.h"

@interface DataProvider()
@property (nonatomic, strong) NSArray *rows;
@end

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

- (void)fetchRecordForCustomerNumber:(NSString*)number sucess:(FetchCSVRecordSuccess)successBlock {
    if(self.rows) {
        [self searchrecordNumber:number success:successBlock];
    }
    else {
        [self parseAndSearchRecordNumber:number succes:successBlock];
    }
    
}

- (void)searchrecordNumber:(NSString *)number success:(FetchCSVRecordSuccess)successBlock {
    for(NSArray *record in self.rows) {
        int cloumnNumber = 0;
        for(NSString *value in record) {
            if(cloumnNumber == COLUMN_NUMBER)  {
                if([value isEqualToString:number])
                { successBlock(record); return; }
                
            }
            cloumnNumber++;
        }
    }
    
    successBlock(nil);
}

#pragma mark parse csv

- (void)parseAndSearchRecordNumber:(NSString *)number succes:(FetchCSVRecordSuccess)success{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"customers" ofType:@"csv"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
       // weakSelf.rows = [NSArray arrayWithContentsOfDelimitedURL:url delimiter:';'];
        weakSelf.rows = [CSVParser parseCSVIntoArrayOfArraysFromFile:[url path]
                                        withSeparatedCharacterString:@";"
                                                quoteCharacterString:nil];
        if(!weakSelf.rows)
            NSLog(@"Error constructing data provider");
                
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf searchrecordNumber:number success:success];
        });
            
    });
   
}
@end
