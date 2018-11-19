//
//  NSString+LBDate.m
//  app
//
//  Created by LINAICAI on 16/6/8.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import "NSString+LBDate.h"

@implementation NSString (LBDate)

+ (NSDateFormatter *)sharedDateFormatter
{
    static dispatch_once_t onceToken;
    
    static NSDateFormatter *shareFormatter = nil;
    
    dispatch_once(&onceToken, ^{
        shareFormatter = [[NSDateFormatter alloc] init];
    });
    return shareFormatter;
}

+ (BOOL)isBetweenWithIntervalSince1970:(NSTimeInterval)startTime end:(NSTimeInterval)endTime{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970]*1000;
    if (now > startTime && now < endTime) {
        return YES;
    }
    return NO;
}
+ (NSString *)dateWithIntervalSince1970:(NSString *)TimeInterval{
    
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= str.length==10?[str doubleValue]:[str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSString *)dateTimeWithIntervalSince1970:(NSString *)TimeInterval{
    
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= str.length==10?[str doubleValue]:[str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSString *)timeWithIntervalSince1970:(NSString *)TimeInterval{
    
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= str.length==10?[str doubleValue]:[str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSString *)otherStyleDateWithIntervalSince1970:(NSString *)TimeInterval{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= str.length==10?[str doubleValue]:[str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
//时间戳转换成年月日字符串:(自定义格式)
+ (NSString *)dateWithIntervalSince1970:(NSString *)TimeInterval format:(NSString *)format{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= str.length==10?[str doubleValue]:[str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:format];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSString *)getHHMMdateTimeWithIntervalSince1970:(NSString *)TimeInterval{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= [str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;

}
+ (NSString *)getHHmmdateTimeWithIntervalSince1970:(NSString *)TimeInterval{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    
    NSString*str=TimeInterval;
    
    NSTimeInterval time= [str doubleValue]/1000.0;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}
+ (NSDate *)dateFromTimeInterVal:(NSTimeInterval)interval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSString *) stringWithFormat:(NSString *)format
                    CurrentDate:(NSDate *)currentDate
{
    NSDateFormatter *formatter = [self sharedDateFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:currentDate];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval withFormat:(NSString *)string
{
    NSTimeInterval time= interval/1000.0;
    
    NSDate *date = [self dateFromTimeInterVal:time];

    return [self stringWithFormat:string CurrentDate:date];
}
+ (NSString *)stringFromTimeIntervalStr:(NSString *)intervalStr withFormat:(NSString *)string{
    
    NSTimeInterval time= intervalStr.length==10?[intervalStr doubleValue]:[intervalStr doubleValue]/1000.0;
    
    NSDate *date = [self dateFromTimeInterVal:time];
    
    return [self stringWithFormat:string CurrentDate:date];
}
//NSDate转换成年月日字符串:(yyyy-MM-dd)
+ (NSString *)dateStringWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//NSDate转换成月日字符串:(MM-dd)
+ (NSString *)monthStringWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
+ (NSString *)dateStringWithDate:(NSDate *)date format:(NSString *)string {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:string];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//NSDate转换成年月日字符串:(yyyy-MM-dd-HH-mm-ss)
+ (NSString *)dateStringWithDetailsDate:(NSDate *)date withFormat:(NSString *)string{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:string];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//NSDate转换成年月日时分秒字符串:(yyyy-MM-dd HH:mm:ss)
+ (NSString *)dateTimeStringWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//NSDate转换成时分字符串:(HH:mm)
+ (NSString *)timeStringWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString*currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data/1000.0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
+ (NSString *)getWeekDayWithDate:(NSDate *)date{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;

}


+(NSString *)dateOrTimeStringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    return dateSMS;
}

+ (NSString *)earlierTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSString *timeDes = @"";
    long long  time;
    NSDate *earlierTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeInterval timeInt = [[NSDate date] timeIntervalSinceDate:earlierTime];
    if (timeInt >= NSStringDateTimeYEAR)
    {
        time = timeInt/ (NSStringDateTimeYEAR);
        timeDes = [NSString stringWithFormat:@"%@",[self dateStringWithDate:earlierTime] ];
        
    }
    else if (timeInt >= NSStringDateTimeDAY)
    {
        time = timeInt/ (NSStringDateTimeMONTH);
        timeDes = [NSString stringWithFormat:@"%@",[self monthStringWithDate:earlierTime] ];
    }
    else if (timeInt >= NSStringDateTimeHOUR)
    {
        time = timeInt/ ( NSStringDateTimeHOUR);
        timeDes = [NSString stringWithFormat:@"%ld小时前", (long)time];
    }
    else if (timeInt >= NSStringDateTimeMINUTE)
    {
        time = timeInt/ (NSStringDateTimeMINUTE);
        timeDes = [NSString stringWithFormat:@"%ld分钟前", (long)time];
    }
    else {
        timeDes = @"刚刚";
    }
    
    return timeDes;
}
//一种格式化时间字符串转另一种格式化时间字符串
+ (NSString *)dateStringWithOtherDateString:(NSString *)string oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat{
    //先把旧的字符串日期转日期对象
    NSDateFormatter *formatter = [self sharedDateFormatter];
    formatter.dateFormat = oldFormat;
    NSDate* date = [formatter dateFromString:string];
    //再把日期对象转另一个新格式的日期字符串
    return [NSString dateStringWithDetailsDate:date withFormat:newFormat];
}
@end
