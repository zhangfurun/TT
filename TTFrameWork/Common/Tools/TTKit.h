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
+ (void)saveData:(id)obj forKey:(NSString *)key;
+ (NSData *)readDataForKey:(NSString *)key;
+ (id)readCacheForKey:(NSString *)key;
+ (TTShareUser *)readTTShareUserForKey:(NSString *)key;
+ (TTAuthInfo *)readTTAuthInfoForKey:(NSString *)key;
+ (void)deleteObjectForKey:(NSString *)key;
@end
