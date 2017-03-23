//
//  TTKit.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTShareUser;
@class TTAuthInfo;

@interface TTKit : NSObject

/**
 沙盒中保存数据
 
 @param obj 保存数据
 @param key 保存数据的key
 */
+ (void)saveData:(id)obj forKey:(NSString *)key;

/**
 通过key获取数据

 @param key 数据对应的key
 */
+ (NSData *)readDataForKey:(NSString *)key;

/**
 获取保存在cache中的数据(解档)

 @param key 保存在cache中的key
 */
+ (id)readCacheForKey:(NSString *)key;

/**
 获取保存的shareUser

 @param key user对应的key
 */
+ (TTShareUser *)readTTShareUserForKey:(NSString *)key;

/**
 获取保存的AuthInfo

 @param key 保存的AuthInfo的key
 */
+ (TTAuthInfo *)readTTAuthInfoForKey:(NSString *)key;

/**
 删除保存的数据

 @param key 数据的key
 */
+ (void)deleteObjectForKey:(NSString *)key;
@end
