//
//  TTTools.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kDeviceTypeUnknowDevice = 0,
    kDeviceType4,
    kDeviceType5,
    kDeviceType6,
    kDeviceType6Plus
}kDeviceType;

@interface TTTools : NSObject

/**
 *  日期时间
 */
+ (NSDictionary *)getCurrentDate;

/**
 *  去除字符串首尾空格换行
 */
+ (NSString *)trimmedString:(NSString *)str;

/**
 *  计算文本尺寸
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  MD5加密
 *  @param str 要加密的字符串
 *  @return 加密后的值
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  遍历文件夹中文件
 *  @param path 遍历的文件夹
 */
+ (void)readFolderFiles:(NSString *)path;

/**
 *  获取手机型号
 */
+ (kDeviceType)getDeviceModel;

#pragma mark - 正则匹配
/**
 *  手机正则
 */
+ (BOOL) validateMobile:(NSString *)mobile;
/**
 *  邮箱正则
 */
+ (BOOL) validateEmail:(NSString *)email;
/**
 *  身份证正则
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
/**
 *  银行卡号正则
 */
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;

/**
 *  Json转字典
 */
+ (NSDictionary *)jsonToDict:(NSString *)jsonString;
/**
 *  字典转Json
 */
+ (NSString*)dictToJson:(NSDictionary *)dic;


@end

