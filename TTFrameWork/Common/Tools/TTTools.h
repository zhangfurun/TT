//
//  TTTools.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface TTTools : NSObject

/**
 判断字符串是不是空

 @param string 判断的字符串
 */
+ (BOOL)isNilOrEmpty:(NSString *)string;

/**
 去除字符串首尾空格换行

 @param str 处理的字符串
 */
+ (NSString *)trimmedString:(NSString *)str;

/**
 计算文本尺寸

 @param string 被计算的字符串
 @param font 设定字符串的文字大小
 @param maxSize 设置最大的尺寸
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 MD5加密

 @param str 要加密的字符串
 @return 加密后的值
 */
+ (NSString *)md5:(NSString *)str;

/**
 遍历文件夹中文件
 */
+ (void)readFolderFiles:(NSString *)path;

/**
 Json转字典
 */
+ (NSDictionary *)jsonToDict:(NSString *)jsonString;

/**
 字典转Json
 */
+ (NSString*)dictToJson:(NSDictionary *)dic;

#pragma mark - 正则匹配
/**
 手机正则
 */
+ (BOOL) validateMobile:(NSString *)mobile;

/**
 邮箱正则
 */
+ (BOOL) validateEmail:(NSString *)email;

/**
 身份证正则
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 银行卡号正则
 */
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;


@end

