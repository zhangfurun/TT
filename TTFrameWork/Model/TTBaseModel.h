//
//  TTBaseModel.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTBaseModel : NSObject
- (NSDictionary *)zz_toKeyValue;
- (void)zz_modelsDidFinishConvertingToKeyValues;
- (void)zz_keyvaluesDidFinishConvertingToModels;

+ (NSDictionary *)zz_replaceKeyFromPropertyName;
+ (NSDictionary *)zz_objectClassInArray;
+ (NSArray *)zz_ignoredPropertyNames;
+ (instancetype)zz_modelFromKeyValue:(NSDictionary *)keyValue;
+ (NSArray *)zz_keyValuesFromModels:(NSArray *)models;
+ (NSArray *)zz_modelsFromKeyValues:(NSArray *)keyvalues;
+ (NSArray *)zz_allowedCodingPropertyNames;
+ (NSArray *)zz_ignoredCodingPropertyNames;
@end
