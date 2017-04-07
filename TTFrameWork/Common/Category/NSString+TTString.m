//
//  NSString+TTString.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSString+TTString.h"
#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIKit.h>

#import <AdSupport/ASIdentifierManager.h>

@implementation NSString (TTString)

+ (BOOL)isNilOrEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!temp || temp.length == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)md5Str {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    };
    return [hash lowercaseString];
}

/**
 在2013年3月21日苹果已经通知开发者，从2013年5月1日起，访问UIDID的应用将不再能通过审核，替代的方案是开发者应该使用“在iOS 6中介绍的Vendor或Advertising标示符”。
 分散式系統中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端來做辨识资讯的指定。如此一來，每個人都可以建立不与其它人冲突的 UUID。在這样的情況下，就不需考虑资料库建立时的名称重复问题
 UUID OR GUID最大优点在於算法不依赖数据库，可以入库前预生成。
 */
+ (NSString *)GUIDString {
    return [self UUIDString];
}

+ (NSString *)NSUUIDString {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

/**
 一个Vendor是CFBundleIdentifier（反转DNS格式）的前两部分
 */
+ (NSString *)vendorString {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

/**
 UDID的全名为 Unique Device Identifier :设备唯一标识符
 UDID是一个40位十六进制序列
 在iOS5 中可以获取,但是,在此之后,被苹果禁用了
 + (NSString *)UDIDString {
 NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
 return udid;
 }
 */

+ (NSString *)UUIDString {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString *)IDFAString {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

@end
