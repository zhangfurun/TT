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

- (NSDictionary *)tt_toKeyValue {
    return [self mj_keyValues];
}

/**
 字典转模型完毕后执行
 */
- (void)mj_keyValuesDidFinishConvertingToObject {
    [self tt_keyvaluesDidFinishConvertingToModels];
}

- (void)tt_modelsDidFinishConvertingToKeyValues {
    
}

/**
 模型转字典完毕后执行
 */
- (void)mj_objectDidFinishConvertingToKeyValues {
    [self tt_modelsDidFinishConvertingToKeyValues];
}

- (void)tt_keyvaluesDidFinishConvertingToModels {
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self tt_replaceKeyFromPropertyName];
}

+ (NSDictionary *)tt_replaceKeyFromPropertyName {
    return @{};
}

+ (NSDictionary *)tt_objectClassInArray {
    return @{};
}

+ (NSDictionary *)mj_objectClassInArray {
    return [self tt_objectClassInArray];
}

+ (NSArray *)mj_ignoredPropertyNames {
    return [self tt_ignoredPropertyNames];
}

+ (NSArray *)tt_ignoredPropertyNames {
    return @[];
}

+ (instancetype)tt_modelFromKeyValue:(NSDictionary *)keyValue {
    return [self mj_objectWithKeyValues:keyValue];
}

+ (NSArray *)tt_keyValuesFromModels:(NSArray *)models {
    NSArray *array = [self mj_keyValuesArrayWithObjectArray:models];
    return array?:[NSArray array];
}

+ (NSArray *)tt_modelsFromKeyValues:(NSArray *)keyvalues {
    NSArray *array = [self mj_objectArrayWithKeyValuesArray:keyvalues];
    return  array?:[NSArray array];
}

#pragma mark - 归档和解归档
+ (NSArray *)mj_allowedCodingPropertyNames {
    return [self tt_allowedCodingPropertyNames];
}

+ (NSArray *)mj_ignoredCodingPropertyNames {
    return [self tt_ignoredCodingPropertyNames];
}

+ (NSArray *)tt_allowedCodingPropertyNames {
    return @[];
}

+ (NSArray *)tt_ignoredCodingPropertyNames {
    return @[];
}

MJExtensionCodingImplementation

@end
