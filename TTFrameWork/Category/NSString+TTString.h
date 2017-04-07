//
//  NSString+TTString.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TTString)
/**
 字符串的判空

 @param str 判断的字符串
 */
+ (BOOL)isNilOrEmpty:(NSString *)str;

/**
 字符串的MD5加密
 */
- (NSString *)md5Str;

/**
 生成唯一标识符(默认采用CFUUID,无限制)
 */
+ (NSString *)GUIDString;

/**
 通过NSUUID获取唯一标识符,限制:当前系统>=6.0
 */
+ (NSString *)NSUUIDString;

/**
 Vindor标示符 
 不过获取这个IDFV的新方法被添加在已有的UIDevice类中.跟advertisingIdentifier一样，该方法返回的是一个NSUUID对象

 */
+ (NSString *)vendorString;

/**
 生成广告的唯一标识符
 */
+ (NSString *)IDFAString;
@end
