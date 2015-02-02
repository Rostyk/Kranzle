//
//  NSDateHelper.m
//
//  Created by umbrella on 7/18/14.
//  Copyright (c) 2014 Orange Harp. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#import "NSDateHelper.h"

@implementation NSDateHelper


+ (NSDate *)nsdateStartOfToDay {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    return [today dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:today]];
}

+ (NSDate *)nsdateStartOfThisMonth {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    NSDate *startingDate;
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    NSInteger thisMonth = [cal components:NSMonthCalendarUnit fromDate:today].month;
    // Find the starting date of the month and how many days in that month
    [components setYear:2014];
    [components setMonth:thisMonth];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    startingDate = [cal dateFromComponents:components];
    startingDate = [startingDate dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:startingDate]];
    
    return startingDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)timeRemainingUntilDate:(NSDate *)date {
    if (date == nil) {
        return @"";
    }
    NSTimeInterval interval = [date timeIntervalSinceNow];
    NSString * timeRemaining = nil;
    
    if (interval > 0) {
        
        div_t d = div(interval, 86400);
        int day = d.quot;
        
        NSString * nbday = nil;
        if(day > 1)
            nbday = @"days";
        else if(day == 1)
            nbday = @"day";
        else
            nbday = @"";
        timeRemaining = [NSString stringWithFormat:@"%@ %@", day ? @(day) : @"", nbday];
    }
    else
        timeRemaining = @"Expire";
    
    return timeRemaining;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter stringFromDate:date];

    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromStringWithoutTimeZone:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateShortFromStringWithoutTimeZone:(NSString *)dateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)dateFromUnixTimeStamp:(NSString *)time {
    double unixTimeStamp = [time doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    return [NSDate dateWithTimeIntervalSince1970:_interval];
}

@end
