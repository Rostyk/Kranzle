//
//  NSDateHelper.h
//
//  Created by umbrella on 7/18/14.
//  Copyright (c) 2014 Orange Harp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "time.h"

@interface NSDateHelper : NSObject

+ (NSDate *)nsdateStartOfToDay;
+ (NSDate *)nsdateStartOfThisMonth;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)timeRemainingUntilDate:(NSDate *)date;
+ (NSDate *)dateFromStringWithoutTimeZone:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateShortFromStringWithoutTimeZone:(NSString *)dateString;
+ (NSDate *)dateFromUnixTimeStamp:(NSString *)time;
@end
