//
//  NSBundle+TTBundle.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//


// NSBoundle的信息设置可以点击项目->TARGETS->当前项目->General->Identity->Version or Build

#import <Foundation/Foundation.h>

@interface NSBundle (TTBundle)
/**
 获取APP的Version信息(获取APP版本号)
 */
+ (NSString *)appVersion;


/**
 获取APP的Build的信息
 */
+ (NSString *)appBuild;
@end
