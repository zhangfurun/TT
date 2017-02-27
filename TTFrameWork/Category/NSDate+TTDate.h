//
//  NSDate+TTDate.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TTDate)
+ (NSString *)secondFormatTime:(NSInteger)totalSecond;
+ (NSString *)secondFormatTime:(NSInteger)totalSecond hasHour:(BOOL)hasHour;
+ (NSString *)date:(NSString *)dateStr dateFormat:(NSString *)dateFormat withFormat:(NSString *)targetFormat;
+ (NSString *)getTimeFormatWithTimestamp:(NSString *)timestamp format:(NSString *)format; // 时间戳
+ (NSString *)dateWithTimeStamp:(NSString *)timeStamp format:(NSString *)format;
- (NSString *)dateWithFormat:(NSString *)format;

+ (NSInteger)getCurrentYear;
+ (NSInteger)getCurrentMounth;
+ (NSInteger)getCurrentDay;
+ (NSInteger)getCurrentHour;
+ (NSInteger)getCurrentMinute;
+ (NSInteger)getCurrentSecond;
+ (NSInteger)getCurrentWeekday;
+ (NSDateComponents *)getCurrentDateDetail;
@end
