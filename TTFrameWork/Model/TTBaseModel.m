//
//  TTBaseModel.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseModel.h"

#import "MJExtension.h"

@interface TTBaseModel () <MJCoding>

@end

@implementation TTBaseModel

- (NSDictionary *)zz_toKeyValue {
    return [self mj_keyValues];
}

- (void)zz_modelsDidFinishConvertingToKeyValues {
    
}

- (void)zz_keyvaluesDidFinishConvertingToModels {
    
}

/**
 *  字典转模型完毕后执行
 */
- (void)mj_keyValuesDidFinishConvertingToObject {
    [self zz_keyvaluesDidFinishConvertingToModels];
}

/**
 *  模型转字典完毕后执行
 */
- (void)mj_objectDidFinishConvertingToKeyValues {
    [self zz_modelsDidFinishConvertingToKeyValues];
}

+ (NSDictionary *)zz_replaceKeyFromPropertyName {
    return @{};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self zz_replaceKeyFromPropertyName];
}

+ (NSDictionary *)zz_objectClassInArray {
    return @{};
}

+ (NSArray *)mj_ignoredPropertyNames {
    return [self zz_ignoredPropertyNames];
}

+ (NSArray *)zz_ignoredPropertyNames {
    return @[];
}

+ (NSDictionary *)mj_objectClassInArray {
    return [self zz_objectClassInArray];
}

+ (instancetype)zz_modelFromKeyValue:(NSDictionary *)keyValue {
    return [self mj_objectWithKeyValues:keyValue];
}

+ (NSArray *)zz_keyValuesFromModels:(NSArray *)models {
    NSArray *array = [self mj_keyValuesArrayWithObjectArray:models];
    return array?:[NSArray array];
}

+ (NSArray *)zz_modelsFromKeyValues:(NSArray *)keyvalues {
    NSArray *array = [self mj_objectArrayWithKeyValuesArray:keyvalues];
    return  array?:[NSArray array];
}

#pragma mark - 归档和解归档
+ (NSArray *)mj_allowedCodingPropertyNames {
    return [self zz_allowedCodingPropertyNames];
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return [self zz_ignoredCodingPropertyNames];
}

+ (NSArray *)zz_allowedCodingPropertyNames {
    return @[];
}

+ (NSArray *)zz_ignoredCodingPropertyNames {
    return @[];
}

MJExtensionCodingImplementation

@end
