//
//  SinaAuthRequest.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "SinaAuthRequest.h"

#import "TTSinaCenter.h"

@implementation SinaAuthRequest
- (NSString *)getRequestHost {
    return @"https://api.weibo.com/2/users/show.json?";
}

- (NSDictionary *)getDefaultParameters {
    NSString *appId = [NSUserDefaults stringValueForKey:SinaAppIdKey];
    return @{@"source" : appId};
}

- (void)processResult {
    TTShareUser *user = [[TTShareUser alloc] initWithWBDict:self.resultDict];
    [TTSinaCenter shareInstance].user = user;
}

@end
