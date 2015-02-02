//
//  Settings.h
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

extern NSString * const kUser;
extern NSString * const kPassword;

+ (NSString *)serviceURL;
+ (NSString *)listServiceURL;

@end
