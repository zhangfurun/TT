//
//  TTKit.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTKit.h"

#import "TTShareUser.h"
#import "TTAuthInfo.h"

#import "TTConst.h"

#import "NSUserDefaults+TTUserDefaults.h"

@implementation TTKit
+ (void)saveData:(id)obj forKey:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [NSUserDefaults setObjectValue:data forKey:key];
}

+ (NSData *)readDataForKey:(NSString *)key {
    return [NSUserDefaults dataValueForKey:key];
}

+ (id)readCacheForKey:(NSString *)key {
    NSData *data = [NSUserDefaults dataValueForKey:key];
    if (data) {
        @try {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return obj;
        }
        @catch (NSException *exception) {
            TTLog(@"readCacheForKey:%@, error:%@",key, exception);
        }
        @finally {
            
        }
    }
    return nil;
}

+ (TTShareUser *)readTTShareUserForKey:(NSString *)key {
    NSData *data = [self readDataForKey:key];
    TTShareUser *user = data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

+ (TTAuthInfo *)readTTAuthInfoForKey:(NSString *)key {
    NSData *data = [self readDataForKey:key];
    TTAuthInfo *authInfo = data == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return authInfo;
}

+ (void)deleteObjectForKey:(NSString *)key {
    [NSUserDefaults removeObjectForKey:key];
}
@end
