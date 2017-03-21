//
//  NSUserDefaults+TTUserDefaults.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSUserDefaults+TTUserDefaults.h"

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@implementation NSUserDefaults (TTUserDefaults)

#pragma mark - Set Data

+ (void)setBoolValue:(BOOL)value forKey:(NSString *)defaultName{
    [USER_DEFAULTS setBool:value forKey:defaultName];
    [USER_DEFAULTS synchronize];
}

+ (void)setObjectValue:(id)value forKey:(NSString *)defauletName{
    [USER_DEFAULTS setObject:value forKey:defauletName];
    [USER_DEFAULTS synchronize];
}

+ (void)setValue:(id)value forKey:(NSString *)defauletName {
    [USER_DEFAULTS setValue:value forKey:defauletName];
    [USER_DEFAULTS synchronize];
}

+ (void)setIntegerValue:(NSInteger)value forKey:(NSString *)defaultName{
    [USER_DEFAULTS setInteger:value forKey:defaultName];
    [USER_DEFAULTS synchronize];
}


#pragma mark - Get Data

+ (NSString *)stringValueForKey:(NSString *)defaultName{
    return [USER_DEFAULTS stringForKey:defaultName];
}

+ (BOOL)boolValueForKey:(NSString *)defaultName{
    return [USER_DEFAULTS boolForKey:defaultName];
}

+ (NSInteger)integerValueForKey:(NSString *)defaultName{
    return [USER_DEFAULTS integerForKey:defaultName];
}

+ (NSData *)dataValueForKey:(NSString *)defaultName {
    return [USER_DEFAULTS dataForKey:defaultName];
}

+ (NSArray *)arrayValueForKey:(NSString *)defaultName {
    return [USER_DEFAULTS arrayForKey:defaultName];
}

+ (NSMutableArray *)mutableArrayValueForKey:(NSString *)defaultName {
    return [USER_DEFAULTS mutableArrayValueForKey:defaultName];
}


#pragma mark - Delete Data

+ (void)removeObjectForKey:(NSString *)defaultName {
    if ([self isExistsForKey:defaultName]) {
        [USER_DEFAULTS removeObjectForKey:defaultName];
        [USER_DEFAULTS synchronize];
    }
}

#pragma mark - Other

+ (BOOL)isExistsForKey:(NSString *)defaultName{
    NSArray *allKeys = USER_DEFAULTS.dictionaryRepresentation.allKeys;
    return [allKeys containsObject:defaultName];
}
@end
