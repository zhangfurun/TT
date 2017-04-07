//
//  NSDate+TTDate.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSDate+TTDate.h"



@implementation NSDate (TTDate)

+ (NSString *)secondFormatTime:(NSInteger)totalSecond {
    return [self secondFormatTime:totalSecond hasHour:YES];
}

+ (NSString *)secondFormatTime:(NSInteger)totalSecond hasHour:(BOOL)hasHour {
    NSInteger seconds = totalSecond % 60;
    NSInteger minutes = (totalSecond / 60) % 60;
    NSInteger hours = totalSecond / 3600;
    NSString *result;
    if (hasHour) {
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    } else {
        result = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    }
    return result;
}



+ (NSString *)date:(NSString *)dateStr dateFormat:(NSString *)dateFormat withFormat:(NSString *)targetFormat {
    if (!dateStr) {
        return @"";
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:dateFormat];
    NSDate *date = [formater dateFromString:dateStr];
    if (!date) {
        return @"";
    }
    return [date dateWithFormat:targetFormat];
}

//时间戳
+ (NSString *)dateWithTimeStamp:(NSString *)timeStamp format:(NSString *)format {
    return [self getTimeFormatWithTimestamp:timeStamp format:format];
}

+ (NSString *)getTimeFormatWithTimestamp:(NSString *)timestamp format:(NSString *)format {
    if (!timestamp || !format ) {
        return @"";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp doubleValue]/ 1000.0)];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

// 格式化时间
- (NSString *)dateWithFormat:(NSString *)format {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    return [formater stringFromDate:self];
}

//获取时间的详情
+ (NSInteger)getCurrentYear {
    return [self getCurrentDateDetail].year;
}

+ (NSInteger)getCurrentMounth {
    return [self getCurrentDateDetail].month;
}

+ (NSInteger)getCurrentDay {
    return [self getCurrentDateDetail].day;
}

+ (NSInteger)getCurrentHour {
    return [self getCurrentDateDetail].hour;
}

+ (NSInteger)getCurrentMinute {
    return [self getCurrentDateDetail].minute;
}

+ (NSInteger)getCurrentSecond {
    return [self getCurrentDateDetail].second;
}

+ (NSInteger)getCurrentWeekday {
    return [self getCurrentDateDetail].weekday;
}

+ (NSDateComponents *)getCurrentDateDetail {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate* dt = [NSDate date];
    
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    return comp;
}

- (NSString *)compareCurrentTime:(NSString *)str dateFormat:(NSString *)dataFormat withTurnFormat:(NSString *)turnFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dataFormat];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else {
        result = [NSDate date:str dateFormat:dataFormat withFormat:turnFormat];
    }
    //    else if((temp = temp/24) <30){
    //        result = [NSString stringWithFormat:@"%ld天前",temp];
    //    }
    //    else if((temp = temp/30) <12){
    //        result = [NSString stringWithFormat:@"%ld月前",temp];
    //    }
    //    else{
    //        temp = temp/12;
    //        result = [NSString stringWithFormat:@"%ld年前",temp];
    //    }
    return  result;
}


@end
