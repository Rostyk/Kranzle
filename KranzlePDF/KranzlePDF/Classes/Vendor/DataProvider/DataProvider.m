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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"customers" ofType:@"csv"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.rows = [NSArray arrayWithContentsOfDelimitedURL:url delimiter:';'];
    if(!self.rows)
        NSLog(@"Error constructing data provider");
    return self;
}

#pragma mark search records

- (NSArray *)recordForCustomerNumber:(NSString*)number {
    for(NSArray *record in self.rows) {
        int cloumnNumber = 0;
        for(NSString *value in record) {
            if(cloumnNumber == COLUMN_NUMBER)  {
                if([value isEqualToString:number])
                    return record;
            }
            cloumnNumber++;
        }
    }
    
    return nil;
}

@end
