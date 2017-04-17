//
//  NSDate+TTDate.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TTDate)
#pragma mark - Base
/**
 *  NSString转NSDate
 *
 *  @param dateString 日期字符串
 *
 *  @return 日期
 */
- (NSDate *)dateFromString:(NSString *)dateString;

/**
 *  NSDate转NSString
 *
 *  @param date 日期
 *
 *  @return 日期字符串
 */
- (NSString *)stringFromDate:(NSDate *)date;

/**
 分钟转换(默认是显示小时)

 @param totalSecond 总时间
 */
+ (NSString *)secondFormatTime:(NSInteger)totalSecond;

/**
 分钟时间转换

 @param totalSecond 总时间
 @param hasHour 是不是显示小时 e.g. 100:10   or  1:40:10
 */
+ (NSString *)secondFormatTime:(NSInteger)totalSecond hasHour:(BOOL)hasHour;

/**
 时间合适转换
 
 @param dateStr 当前时间
 @param dateFormat 原格式
 @param targetFormat 转换格式
 */
+ (NSString *)date:(NSString *)dateStr dateFormat:(NSString *)dateFormat withFormat:(NSString *)targetFormat;

/**
 通过时间戳格式化时间

 @param timeStamp 时间戳
 @param format 时间格式
 */
+ (NSString *)dateWithTimeStamp:(NSString *)timeStamp format:(NSString *)format;

/**
 时间字符串的格式化
 
 @param format 时间格式
 e.g. yyyy-MM-dd  ->   2017-2-28
 */
- (NSString *)dateWithFormat:(NSString *)format;


/**
 获取当前时间的信息,年月日等

 */
+ (NSInteger)getCurrentYear;    // 年
+ (NSInteger)getCurrentMounth;  // 月
+ (NSInteger)getCurrentDay;     // 日
+ (NSInteger)getCurrentHour;    // 小时
+ (NSInteger)getCurrentMinute;  // 分钟
+ (NSInteger)getCurrentSecond;  // 秒
+ (NSInteger)getCurrentWeekday; //星期
+ (NSDateComponents *)getCurrentDateDetail; //当前时间的类型


#pragma mark - Other
/**
 计算这个月有多少天

 @return 天数
 */
- (NSUInteger)numberOfDaysInCurrentMonth;

/**
 获取这个月有多少周

 @return 周数
 */
- (NSUInteger)numberOfWeeksInCurrentMonth;

/**
 计算这个月的第一天是礼拜几

 @return 礼拜几
 */
- (NSUInteger)weeklyOrdinality;

/**
 计算这个月最开始的一天

 @return 最开始的一天
 */
- (NSDate *)firstDayOfCurrentMonth;

/**
 计算这个月最后的一天

 @return 最后的一天
 */
- (NSDate *)lastDayOfCurrentMonth;

/**
 上一个月

 @return 上一个月
 */
- (NSDate *)dayInThePreviousMonth;

/**
 下一个月
 
 @return 下一个月
 */
- (NSDate *)dayInTheFollowingMonth;

/**
 获取当前日期之后的几个月

 @param month 当前月
 @return 当前日期之后的几个月
 */
- (NSDate *)dayInTheFollowingMonth:(int)month;
/**
 *  获取当前日期之后的几天
 *
 *  @param day 当前天
 *
 *  @return 当前日期之后的几天
 */


/**
 获取当前日期之后的几天

 @param day 当前天
 @return 当前日期之后的几天
 */
- (NSDate *)dayInTheFollowingDay:(int)day;

/**
 获取年月日对象

 @return 年月日对象
 */
- (NSDateComponents *)YMDComponents;


/**
 两个日期之间相差多少月

 @param today 第一个日期
 @param beforday 第二个日期
 @return 两个日期之间相差多少月
 */
+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

/**
 周日是“1”，周一是“2”...
 */
-(int)getWeekIntValueWithDate;


/**
 判断日期是今天,明天,后天,周几
 */
-(NSString *)compareIfTodayWithDate;

/**
 通过数字返回星期几

 @param week 周日是“1”，周一是“2”...
 */
+(NSString *)getWeekStringFromInteger:(int)week;



@end
