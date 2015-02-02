//
//  Settings.m
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "Settings.h"

@implementation Settings

NSString * const kBaseURL = @"http://kraenzle.mmx.me";
NSString * const kRootURL = @"kraenzle.mmx.me";

//ftp://Kraenzle.mmx.me
//kraenzle-user
//Qbt11d8%
//@"ftp://user:password@host:port/path"
//ftp://kraenzle-user:Qbt11d8%@kraenzle.mmx.me/customers.xml


//keys:
static NSString * const kList = @"list.json";

NSString * const kUser = @"kraenzle-user";
NSString * const kPassword = @"Qbt11d8%";

+ (NSString *)URLStringWithRoot:(NSString *)root path:(NSString const *)path {
    NSUInteger firstSlashIndex = [path rangeOfString:@"/"].location;
    NSString *tempPath;
    if (firstSlashIndex != NSNotFound){
        tempPath = [NSString stringWithFormat:@"%@%@", [path substringToIndex:firstSlashIndex], [path substringFromIndex:firstSlashIndex]];
    } else {
        tempPath = [NSString stringWithFormat:@"%@", path];
    }
    return root.length > 0 ? [NSString stringWithFormat:[root hasSuffix:@"/"] ? @"%@%@" : @"%@/%@", root, tempPath] : nil;
}

+ (NSString *)serviceURL {
    return (NSString *)kBaseURL;
}

+ (NSString *)listServiceURL {
    return [self URLStringWithRoot:(NSString *)kBaseURL path:kList];
}

//+ (NSString *)customersServiceURL {
//    return [NSString stringWithFormat:@"ftp://%@:%@@%@",kUser,kPassword,[self URLStringWithRoot:(NSString *)kRootURL path:kCustomers]];
//}

@end
