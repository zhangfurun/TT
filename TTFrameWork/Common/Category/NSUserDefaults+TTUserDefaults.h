//
//  NSUserDefaults+TTUserDefaults.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (TTUserDefaults)
#pragma mark - Set Data

/**
 添加BOOL类型的数据

 @param value 数据
 @param defaultName 标志字符
 */
+ (void)setBoolValue:(BOOL)value forKey:(NSString *)defaultName;

/**
 添加Object类型的数据(任意常用类型,非自定义)
 
 @param value 数据 // 注意,却别与setValue,这里的参数value不能为空
 @param defauletName 标志字符
 */
+ (void)setObjectValue:(id)value forKey:(NSString *)defauletName;

/**
 添加任意常用数据

 @param value 数据 Value参数可以为空
 @param defauletName 标志字符
 */
+ (void)setValue:(id)value forKey:(NSString *)defauletName;

/**
 添加Integer类型的数据

 @param value 数据
 @param defaultName 标志字符
 */
+ (void)setIntegerValue:(NSInteger)value forKey:(NSString *)defaultName;


#pragma mark - Get Data

/**
 获取NSString类型的数据

 @param defaultName 标志字符
 */
+ (NSString *)stringValueForKey:(NSString *)defaultName;

/**
 获取BOOL类型的数据

 @param defaultName 标志字符
 */
+ (BOOL)boolValueForKey:(NSString *)defaultName;

/**
 获取NSInteger类型的数据

 @param defaultName 标志字符
 */
+ (NSInteger)integerValueForKey:(NSString *)defaultName;

/**
 获取NSData类型的数据

 @param defaultName 标志字符
 */
+ (NSData *)dataValueForKey:(NSString *)defaultName;
/**
 获取NSArray类型的数据
 
 @param defaultName 标志字符
 */
+ (NSArray *)arrayValueForKey:(NSString *)defaultName;
/**
 获取NSMutableArray类型的数据
 
 @param defaultName 标志字符
 */
+ (NSMutableArray *)mutableArrayValueForKey:(NSString *)defaultName;

#pragma mark - Delete Data

/**
 删除数据

 @param defaultName 需要删除的标志字符
 */
+ (void)removeObjectForKey:(NSString *)defaultName;

#pragma mark - Other

/**
 查看本地保存数据中的所有标志字符是不是包括传入的参数
 即:判断是不是存在参数key

 @param defaultName 需要判断的标志字符
 */
+ (BOOL)isExistsForKey:(NSString *)defaultName;
@end
