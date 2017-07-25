//
//  TTRequest.m
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTRequest.h"

#import "TTServerManager.h"
#import "TTBaseReqCommon.h"

#import "UIDevice+TTDevice.h"
#import "NSBundle+TTBundle.h"

NSString * const FORMAL_SERVER_URL = @""; //正式服务器
NSString * const TEST_SERVER_URL = @""; //测试服务器
NSString * const LOCAL_SERVER_URL = @""; //本地服务器(客户端方便与服务端)

NSString * const STATUS_KEY = @"status";
NSString * const PAGE_KEY = @"page";

// 数据请求最长时间
const NSTimeInterval CC_REQUEST_TIMEOUT_INTERVAL = 15;

@implementation TTRequest
- (NSString *)getRequestHost {
    TTReqServerType serverType = TTServerManager.reqServerType;
    switch (serverType) {
        case TTReqServerTypeFormal:
        case TTReqServerTypeBeta:
        default: //首次启动时
            return FORMAL_SERVER_URL;
        case TTReqServerTypeTest:
            return TEST_SERVER_URL;
        case TTReqServerTypeLocal:
            return LOCAL_SERVER_URL;
    }
}

- (NSTimeInterval)getTimeoutInterval {
    return CC_REQUEST_TIMEOUT_INTERVAL;
}

- (NSDictionary *)getDefaultParameters {
    NSMutableDictionary *defaultParamDict = [NSMutableDictionary dictionary];
    [defaultParamDict setObject:[UIDevice getDeviceTypeString] forKey:@"device"];
    [defaultParamDict setObject:[NSBundle appVersion] forKey:@"ver"];
    return defaultParamDict;
}

- (NSString *)getUserAgent {
    NSString *agent = [NSString stringWithFormat:@"phone_version:%@; ios_version:%@; app_version:%@;", [UIDevice getDeviceTypeString], [UIDevice getOSVersion], [NSBundle appVersion]];
    return agent;
}

// 针对数据读取的方便操作,重写isSuccess属性的get重写
- (BOOL)isSuccess {
    return [self success];
}

/*
 e.g.:
 "status": {
 "code": 0,
 "msg": "string"
 }
 */

- (BOOL)success {
    return [self statusCode] == 1;
}

- (NSInteger)statusCode {
    NSInteger code = REQUEST_DEFAULT_ERROR_CODE;
    if ([self isResultDictContainsKey:STATUS_KEY]) {
        NSDictionary *dict = self.resultDict[STATUS_KEY];
        static NSString *codeKey = @"code";
        if ([dict.allKeys containsObject:codeKey]) {
            code = [[NSString stringWithFormat:@"%@", [dict objectForKey:codeKey]] integerValue];
        }
    }
    return code;
}

- (NSString *)errorMsg {
    if ([self.resultDict.allKeys containsObject:@"status"]) {
        NSDictionary *dict = self.resultDict[@"status"];
        return dict[@"msg"];
    }
    return @"";
}

// 请求相关的信息
- (NSString *)msg {
    if ([self isResultDictContainsKey:STATUS_KEY]) {
        NSDictionary *dict = self.resultDict[STATUS_KEY];
        static NSString *msgKey = @"msg";
        if ([dict.allKeys containsObject:msgKey]) {
            return dict[@"msg"];
        }
    }
    return @"未知消息信息";
}

/*
 e.g.:
 "page": {
 "hasNext": true,
 "pageCount": 0,
 "pageNo": 0,
 "pageSize": 0,
 "rsCount": 0
 }
 */

// 请求总个数
- (NSInteger)totalCount {
    NSInteger totalCount = 0;
    static NSString *rsCountKey = @"rsCount";
    if ([self isResultDictContainsKey:PAGE_KEY]) {
        NSDictionary *pages = self.resultDict[PAGE_KEY];
        if ([pages.allKeys containsObject:rsCountKey]) {
            totalCount = [[pages objectForKey:rsCountKey] integerValue];
        }
    }
    return totalCount;
}

// 是否还有请求数据
- (BOOL)hasMoreData {
    BOOL result = NO;
    static NSString *hasNextKey = @"hasNext";
    if ([self isResultDictContainsKey:PAGE_KEY]) {
        NSDictionary *pages = self.resultDict[PAGE_KEY];
        if ([pages.allKeys containsObject:hasNextKey]) {
            result = [[pages objectForKey:hasNextKey] boolValue];
        }
    }
    return result;
}

- (BOOL)isResultDictContainsKey:(NSString *)key {
    if (!self.resultDict || self.resultDict.count == 0) {
        return NO;
    }
    return [self.resultDict.allKeys containsObject:key];
}


@end
