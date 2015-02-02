//
//  ServiceAPI.h
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WhiteRaccoon.h"

typedef void(^ProgressBlock)(NSInteger progressCount, NSInteger totalCount);
typedef void(^CompletionBlock)(id responseObject, ...);
typedef void(^FailureBlock)(id responseObject, NSError * error);
typedef void(^FailureFtp)(WRRequestError *error);
typedef void(^ProgressFtp)(float progress);

@interface ServiceAPI : NSObject

+ (instancetype)sharedInstance;

// Requests with Completion Blocks
//-----------------------------------------------------------------------------
- (void)getLisOfVersions:(CompletionBlock)completion
                 failure:(FailureBlock)failure progress:(ProgressFtp)progress;

- (void)downloadFile:(CompletionBlock)completion
             failure:(FailureFtp)failure progress:(ProgressFtp)progress;

@end
