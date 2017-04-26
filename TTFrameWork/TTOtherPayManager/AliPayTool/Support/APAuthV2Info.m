//
//  APAuthV2Info.m
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import "APAuthV2Info.h"

@implementation APAuthV2Info


- (NSString *)description
{
    if (self.appID.length != 16||self.pid.length != 16) {
        return nil;
    }
    
    // NOTE: 增加不变部分数据
    NSMutableDictionary *tmpDict = [NSMutableDictionary new];
    [tmpDict addEntriesFromDictionary:@{@"app_id":_appID,
                                        @"pid":_pid,
                                        @"apiname":@"com.alipay.account.auth",
                                        @"method":@"alipay.open.auth.sdk.code.get",
                                        @"app_name":@"mc",
                                        @"biz_type":@"openservice",
                                        @"product_id":@"APP_FAST_LOGIN",
                                        @"scope":@"kuaijie",
                                        @"target_id":(_targetID?:@"20141225xxxx"),
                                        @"auth_type":(_authType?:@"AUTHACCOUNT")}];
    
    
    // NOTE: 排序，得出最终请求字串
    NSArray* sortedKeyArray = [[tmpDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self itemWithKey:key andValue:[tmpDict objectForKey:key]];
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    return [tmpArray componentsJoinedByString:@"&"];
}

- (NSString*)itemWithKey:(NSString*)key andValue:(NSString*)value
{
    if (key.length > 0 && value.length > 0) {
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    return nil;
}

@end
