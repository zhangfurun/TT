//
//  UIDevice+TTDevice.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CurrentDeviceTypeNone,              // 未知类型
    CurrentDeviceTypeIPhone,            // 手机
    CurrentDeviceTypeIPad,              // pad
    CurrentDeviceTypeIPod,              // pod
    CurrentDeviceTypeIPhoneSimulator    // 模拟器
} CurrentDeviceType;


@interface UIDevice (TTDevice)

/**
 获取当前的APP的运行的手机系统版本号
 e.g. @"9.3.5"
 */
+ (NSString *)getOSVersion;

/**
 获取当前的APP的运行的手机类型名称
 e.g. @"iPhone", @"iPod touch"
 */
+ (NSString *)getOSModel;

/**
 获取当前的APP的运行的手机系统名称(这个感觉有点鸡肋)
 e.g. @"iOS"
 */
+ (NSString *)getOSName;


/**
 判断当前设备是不是手机(iPhone)
 */
+ (BOOL)currentDeviceIsIPhone;

/**
 判断当前设备是不是IPad
 */
+ (BOOL)currentDeviceIsIPad;

/**
 判断当前设备是不是IPod
 */
+ (BOOL)currentDeviceIsIPod;


/**
 获取当前设备类型
 */
+ (CurrentDeviceType)currentDeviceType;

/**
 获取当前设备的具体型号
 */
+ (NSString *)currentDeviceTypeString;



#warning 特殊

/**
 快速获得当前设备是不是ipad或者iphone
 */
+ (BOOL)isPad;
@end
