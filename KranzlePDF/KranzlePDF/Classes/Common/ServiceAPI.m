//
//  ServiceAPI.m
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "ServiceAPI.h"
#import "Settings.h"
#import "NSString+PNAdditions.h"
#import "NSDateHelper.h"

@interface ServiceAPI () <WRRequestDelegate>
@property (nonatomic, strong) CompletionBlock succsses;
@property (nonatomic, strong) FailureFtp failure;
@property (nonatomic, strong) ProgressFtp progress;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@end

@implementation ServiceAPI

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[ServiceAPI alloc] init];
    });
}

- (void)getLisOfVersions:(CompletionBlock)completion
                 failure:(FailureBlock)failure progress:(ProgressFtp)progress{
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request  = [self addValueforHTTPHeaderField:[Settings listServiceURL]];
    [self startAFJSONRequestOperation:request completion:^(id responseObject, ...) {
        NSLog(@"responseObject:%@",responseObject);
        NSLog(@"M:%@",responseObject[0][@"m"]);

        NSDate *lastModificationDate = [NSDateHelper dateFromUnixTimeStamp:responseObject[0][@"m"]];

        NSLog(@"lastModificationDate:%@",lastModificationDate);

        NSDate *lastSavedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSavedDate"];
        if(!lastSavedDate || ([lastSavedDate compare:lastModificationDate] == NSOrderedAscending)) {

            [weakSelf downloadFile:^(id responseObject, ...) {
                //Write to file
                [weakSelf setUpAsynchronousContentSave:responseObject completion:completion error:failure];
                
                //Update time stamp
                [[NSUserDefaults standardUserDefaults] setObject:lastModificationDate forKey:@"lastSavedDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(WRRequestError *error) {
                failure(nil, (id)error);
            }
             progress:progress];
        } else {
            completion(nil);
        }
    } failure:^(id responseObject, NSError *error) {
        failure(responseObject, error);
    }];
}

- (void)downloadFile:(CompletionBlock)completion
             failure:(FailureFtp)failure progress:(ProgressFtp)progress{

    self.succsses = completion;
    self.failure = failure;
    self.progress = progress;

    WRRequestDownload * downloadFile = [[WRRequestDownload alloc] init];
    downloadFile.delegate = self;
    downloadFile.path = @"/customers.xml";
    downloadFile.hostname = @"kraenzle.mmx.me";
    downloadFile.username = kUser;
    downloadFile.password = kPassword;
    [downloadFile start];
}

- (void)requestCompleted:(WRRequest *)request {
    NSLog(@"%@ completed!", request);
    WRRequestDownload * downloadFile = (WRRequestDownload *)request;
    NSData * data = downloadFile.receivedData;
//    NSLog(@"%@ data!", data);
    self.succsses(data);
}

- (void)requestFailed:(WRRequest *)request {
    //called after 'request' ends in error
    //we can print the error message
    NSLog(@"%@", request.error.message);
    self.failure(request.error);

}

- (void)requestProgress:(WRRequest *)request progress:(float)downLoadprogress {
    self.progress(downLoadprogress);
}

- (void) setUpAsynchronousContentSave:(NSData *) data completion:(CompletionBlock)sucess error:(FailureBlock)failure{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    if(basePath) {
        NSString *newFilePath = [basePath  stringByAppendingPathComponent:@"/customers.csv"];
        if(![[NSFileManager defaultManager]  fileExistsAtPath:newFilePath]) {
            
        }
        else {
            [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:NULL];
        }
        
        [[NSFileManager defaultManager] createFileAtPath:newFilePath contents:nil attributes:nil];
        
        self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:newFilePath];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.fileHandle seekToEndOfFile];
            [self.fileHandle writeData:data];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.fileHandle closeFile];
                sucess(nil);
            });
        });
    }
    else {
        failure(nil, nil);
    }
    
}

#pragma mark - Start JSON Request Operation

- (void)startAFJSONRequestOperation:(NSURLRequest *)request
                         completion:(CompletionBlock)completion
                            failure:(FailureBlock)failure {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completion(JSON);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(JSON, error);
    }];
    [operation start];
}

- (NSMutableURLRequest *)addValueforHTTPHeaderField:(NSString *)serviceUrl {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serviceUrl]];
    return request;
}

@end
