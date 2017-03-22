//
//  TTBaseModel.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBaseModel : NSObject

/**
 将Model转化为字典
 */
- (NSDictionary *)tt_toKeyValue;

/**
 替换属性名称
 e.g.:@{@"baseID" : @"id"};
 */
+ (NSDictionary *)tt_replaceKeyFromPropertyName;

/**
 替换字段中为Class类型的
 e.g.: @{@"custom"  : [Custom class]};
 */
+ (NSDictionary *)tt_objectClassInArray;

/**
 忽略哪些属性转换
 */
+ (NSArray *)tt_ignoredPropertyNames;

/**
 将字典转换成Model

 @param keyValue 需要转换的字典数据
 */
+ (instancetype)tt_modelFromKeyValue:(NSDictionary *)keyValue;

/**
 将存放当前Model类型的数组转换成字典泛型的数组

 @param models 存放当前模型的数组
 */
+ (NSArray *)tt_keyValuesFromModels:(NSArray *)models;

/**
 将字典泛型的数组转换成对应当前模型泛型的数组

 @param keyvalues 存放字典类型的数组
 */
+ (NSArray *)tt_modelsFromKeyValues:(NSArray *)keyvalues;

/**
 模型归档
 */
+ (NSArray *)tt_allowedCodingPropertyNames;

/**
 模型解档
 */
+ (NSArray *)tt_ignoredCodingPropertyNames;
@end
