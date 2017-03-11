//
//  TTRequest.m
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTRequest.h"

#import "UIDevice+TTDevice.h"
#import "NSBundle+TTBundle.h"

NSString * const FORMAL_SERVER_URL = @"";
NSString * const TEST_SERVER_URL = @"";
NSString * const LOCAL_SERVER_URL = @"";

@implementation TTRequest
- (NSString *)getRequestHost {
    //    return FORMAL_SERVER_URL;
    return TEST_SERVER_URL;
    //    return LOCAL_SERVER_URL;
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

- (BOOL)isSuccess {
    return [self success];
}

- (BOOL)success {
    if ([self.resultDict.allKeys containsObject:@"status"]) {
        NSDictionary *dict = self.resultDict[@"status"];
        NSInteger code = [[NSString stringWithFormat:@"%@", dict[@"code"]] integerValue];
        return code == 1;
    }
    return false;
}

- (NSString *)errorMsg {
    if ([self.resultDict.allKeys containsObject:@"status"]) {
        NSDictionary *dict = self.resultDict[@"status"];
        return dict[@"msg"];
    }
    return @"";
}

- (NSInteger)totalCount {
    return [self.resultDict[@"page"][@"rsCount"] integerValue];
}

- (BOOL)hasMoreData {
    return [self.resultDict[@"page"][@"hasNext"] boolValue];
}

@end
