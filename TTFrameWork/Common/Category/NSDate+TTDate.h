//
//  NSDate+TTDate.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TTDate)

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
@end
