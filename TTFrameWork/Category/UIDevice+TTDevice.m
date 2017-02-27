//
//  UIDevice+TTDevice.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "UIDevice+TTDevice.h"
#import <sys/utsname.h>

@implementation UIDevice (TTDevice)
+ (NSString *)getOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getOSModel{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)getOSName {
    return [[UIDevice currentDevice] name];
}

+ (BOOL)currentDeviceIsIPhone {
    return [UIDevice currentDeviceType] == CurrentDeviceTypeIPhone;
}

+ (BOOL)currentDeviceIsIPad {
    return [UIDevice currentDeviceType] == CurrentDeviceTypeIPad;
}

+ (BOOL)currentDeviceIsIPod {
    return [UIDevice currentDeviceType] == CurrentDeviceTypeIPod;
}


+ (CurrentDeviceType)currentDeviceType {
    NSString *type = [UIDevice currentDeviceTypeString];
    if ([UIDevice getOSVersion].doubleValue >= 8.0 ) {
        if ([type containsString:@"iPhone"] && ![type containsString:@"Simulator"] ) {
            return CurrentDeviceTypeIPhone;
        }else {
            if ([type containsString:@"iPhone"] && [type containsString:@"Simulator"]) {
                return CurrentDeviceTypeIPhoneSimulator;
            }else {
                if ([type containsString:@"iPad"]) {
                    return CurrentDeviceTypeIPad;
                }else {
                    if ([type containsString:@"iPod"]) {
                        return CurrentDeviceTypeIPod;
                    }else {
                        return CurrentDeviceTypeNone;
                    }
                }
            }
        }
        
    }else {
        BOOL isPhone = [type rangeOfString:@"iPhone"].location != NSNotFound;
        BOOL isSimulator = [type rangeOfString:@"Simulator"].location != NSNotFound;
        BOOL isPad = [type rangeOfString:@"iPad"].location != NSNotFound;
        BOOL isPod = [type rangeOfString:@"iPod"].location != NSNotFound;
        if (isPhone && !isSimulator) {
            return CurrentDeviceTypeIPhone;
        }else {
            if (isPhone && isSimulator) {
                return CurrentDeviceTypeIPhoneSimulator;
            }else {
                if (isPad) {
                    return CurrentDeviceTypeIPad;
                }else {
                    if (isPod) {
                        return CurrentDeviceTypeIPod;
                    }else {
                        return CurrentDeviceTypeNone;
                    }
                }
            }
        }
    }
}

+ (NSString *)currentDeviceTypeString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (BOOL)isPad {
    switch ([[UIDevice currentDevice] userInterfaceIdiom]) {
        case UIUserInterfaceIdiomPad:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

@end
