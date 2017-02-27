//
//  NSUserDefaults+TTUserDefaults.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (TTUserDefaults)
+ (void)setBoolValue:(BOOL)value forKey:(NSString *)defaultName;
+ (void)setObjectValue:(id)value forKey:(NSString *)defauletName;
+ (void)setValue:(id)value forKey:(NSString *)defauletName;
+ (void)setIntegerValue:(NSInteger)value forKey:(NSString *)defaultName;
+ (BOOL)boolValueForKey:(NSString *)defaultName;
+ (NSString *)stringValueForKey:(NSString *)defaultName;
+ (NSInteger)integerValueForKey:(NSString *)defaultName;
+ (NSData *)dataValueForKey:(NSString *)defaultName;
+ (BOOL)isExistsForKey:(NSString *)defaultName;
+ (void)removeObjectForKey:(NSString *)defaultName;
+ (NSArray *)arrayValueForKey:(NSString *)defaultName;
+ (NSMutableArray *)mutableArrayValueForKey:(NSString *)defaultName;
@end
