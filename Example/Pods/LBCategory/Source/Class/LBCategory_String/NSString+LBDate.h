//
//  NSString+LBDate.h
//  app
//
//  Created by LINAICAI on 16/6/8.
//  Copyright © 2016年 广东联结电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
///以秒为单位的时间
typedef NS_ENUM(long long, NSStringDateTimeType) {
    NSStringDateTimeMINUTE = 60,
    NSStringDateTimeHOUR = 60*60,
    NSStringDateTimeDAY = 60*60*24,
    NSStringDateTimeMONTH = 60*60*24*30,
    NSStringDateTimeYEAR = 60*60*24*30*12,
};

@interface NSString (LBDate)
//判断当前的时间是否在两个时间之间(都是时间戳)
+ (BOOL)isBetweenWithIntervalSince1970:(NSTimeInterval)startTime end:(NSTimeInterval)endTime;

//时间戳转换成年月日字符串:(yyyy-MM-dd)
+ (NSString *)dateWithIntervalSince1970:(NSString *)TimeInterval;
//时间戳转换成年月日时分秒字符串:(yyyy-MM-dd HH:mm:ss)
+ (NSString *)dateTimeWithIntervalSince1970:(NSString *)TimeInterval;
//时间戳转换成时分字符串:(HH:mm)
+ (NSString *)timeWithIntervalSince1970:(NSString *)TimeInterval;
//时间戳转换成年月日字符串:(yyyy/MM/dd)
+ (NSString *)otherStyleDateWithIntervalSince1970:(NSString *)TimeInterval;
//时间戳转换成年月日字符串:(自定义格式)
+ (NSString *)dateWithIntervalSince1970:(NSString *)TimeInterval format:(NSString *)format;

// @"yyyy/MM/dd HH:mm"
+ (NSString *)getHHMMdateTimeWithIntervalSince1970:(NSString *)TimeInterval;
// @"HH:mm"
+ (NSString *)getHHmmdateTimeWithIntervalSince1970:(NSString *)TimeInterval;

//时间戳转任意格式时间 string (yyyy-MM-dd HH:mm:ss 任意组合)
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval withFormat:(NSString *)string;
//时间戳字符串转任意格式时间 string (yyyy-MM-dd HH:mm:ss 任意组合)
+ (NSString *)stringFromTimeIntervalStr:(NSString *)intervalStr withFormat:(NSString *)string;

// NSDate转为任意格式
+ (NSString *)dateStringWithDate:(NSDate *)date format:(NSString *)string;
//NSDate转换成年月日字符串:(yyyy-MM-dd)
+ (NSString *)dateStringWithDate:(NSDate *)date;
//NSDate转换成月日字符串:(MM-dd)
+ (NSString *)monthStringWithDate:(NSDate *)date;
//NSDate转换成年月日字符串
+ (NSString *)dateStringWithDetailsDate:(NSDate *)date withFormat:(NSString *)string;
//NSDate转换成年月日时分秒字符串:(yyyy-MM-dd HH:mm:ss)
+ (NSString *)dateTimeStringWithDate:(NSDate *)date;
//NSDate转换成时分字符串:(HH:mm)
+ (NSString *)timeStringWithDate:(NSDate *)date;
//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data;
//根据NSDate获取星期几
+ (NSString *)getWeekDayWithDate:(NSDate *)date;
//判断时间是否为今天,如果是今天返回HH:MM,如果是今天以后的
+ (NSString *)dateOrTimeStringWithTimeInterval:(NSTimeInterval)timeInterval;

// 与当前时间对比，返回几天前，几小时，几分钟前
+ (NSString *)earlierTimeWithTimeInterval:(NSTimeInterval)timeInterval;

//一种格式化时间字符串转另一种格式化时间字符串
+ (NSString *)dateStringWithOtherDateString:(NSString *)string oldFormat:(NSString *)oldFormat newFormat:(NSString *)newFormat;
@end
