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
#import "AppDelegate.h"
#import "Customer.h"

@interface DataProvider()
@property (nonatomic, strong) NSString *customerNumber;
@property (nonatomic) NSUInteger totalNumberOfRows;
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

- (void)getTotalNumberOfParsedRows {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(self.totalNumberOfRows == 0) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:appDelegate.managedObjectContext]];
        
        [request setIncludesSubentities:NO];
        
        NSError *err;
        self.totalNumberOfRows = [appDelegate.managedObjectContext countForFetchRequest:request error:&err];
    }
}

- (void)fetchRecordsForSalesmenNumber:(NSString*)number sucess:(FetchCSVRecordsSuccess)successBlock failure:(FetchError)failureBlock{
    /*remember the customre number to later reload if needed (For example if a new customer added)*/
    if(number)
      self.customerNumber = number;
   
    if(number)
       [self fetchCustomersForNumber:number completion:successBlock failure:failureBlock];
    else {
        if(self.customerNumber)
           [self fetchCustomersForNumber:self.customerNumber completion:successBlock failure:failureBlock];
        else
            failureBlock([NSError errorWithDomain:@"com.kranzle.invalidcustomernumber" code:INVALID_CUSTOMER_NUMBER_SPECIFIED userInfo:nil]);
    }
}

- (void)fetchCustomersForNumber:(NSString *)number completion:(FetchCSVRecordsSuccess)successBlock failure:(FetchError)failureBlock {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    __weak typeof(self) weakSelf = self;
    
    [self getTotalNumberOfParsedRows];
    /*number of all rows parsed from csv*/
    NSUInteger totalNumberOfRows = self.totalNumberOfRows;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"vertreterCode == %@", number];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Customer"  inManagedObjectContext: appDelegate.managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entityDescription];
    [fetch setPredicate:pred];
    
    // Initialize Asynchronous Fetch Request
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetch completionBlock:^(NSAsynchronousFetchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.fetchedRows = result.finalResult;
            if(weakSelf.fetchedRows.count > 0)
               successBlock(weakSelf.fetchedRows);
            else {
                /*No customers for sales number found*/
                if(totalNumberOfRows > 0)
                    failureBlock([NSError errorWithDomain:@"com.kranzler.coredata" code:EMPTY_FETCH_RESULT_ERROR userInfo: nil]);
                else
                    [weakSelf parseAndSearchRecordNumber:number succes:successBlock failure:failureBlock];
            }
        });
    }];
    
    // Execute Asynchronous Fetch Request
    [appDelegate.managedObjectContext performBlock:^{
        // Execute Asynchronous Fetch Request
        NSError *asynchronousFetchRequestError = nil;
        [appDelegate.managedObjectContext executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        if (asynchronousFetchRequestError) {
            NSLog(@"Unable to execute asynchronous fetch result.");
            NSLog(@"%@, %@", asynchronousFetchRequestError, asynchronousFetchRequestError.localizedDescription);
        }
    }];

}

#pragma mark parse csv

- (void)parseAndSearchRecordNumber:(NSString *)number succes:(FetchCSVRecordsSuccess)success failure:(FetchError)failureBlock{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"customers" ofType:@"csv"];
        NSURL *url = [NSURL fileURLWithPath:path];
        weakSelf.fetchedRows = [CSVParser parseCSVIntoArrayOfArraysFromFile:[url path]
                                        withSeparatedCharacterString:@";"
                                                quoteCharacterString:nil];
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /*Couldn't parse*/
            if(!weakSelf.fetchedRows) {
                failureBlock([NSError errorWithDomain:@"com.kranzler.parser" code:PARSER_ERROR userInfo: nil]);
                return;
            }
            else {
                weakSelf.totalNumberOfRows = weakSelf.fetchedRows.count;
                [weakSelf fetchCustomersForNumber:number completion:success failure:failureBlock];
            }
            
        });
            
    });
}

#pragma mark new customer

- (void)createNewCustomer {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    Customer *customer = [[Customer alloc] initWithEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:delegate.managedObjectContext] insertIntoManagedObjectContext:delegate.managedObjectContext];
    customer.number = @"787987";
    customer.verbandsNumber = @"345";
    customer.vertreterCode = [[DataProvider sharedProvider] lastUsedVertreterCode];
    customer.name = @"Ross";
    customer.name2 = @"Stepanyak";
    customer.street = @"Stryjska street 78/140";
    customer.ort = @"Lviv";
    customer.plz = @"EE375";
    customer.manuallyCreated = @(YES);
    [delegate saveContext];
}

#pragma mark cached vertreter code
/*vertretercode is called customer number here. == > Rename to avoid confusion */
- (NSString *)lastUsedVertreterCode {
    return self.customerNumber;
}

@end
