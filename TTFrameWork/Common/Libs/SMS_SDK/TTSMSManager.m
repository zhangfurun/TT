//
//  TTSMSManager.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTSMSManager.h"

#import "TTConst.h"

#import "NSString+TTString.h"

#import <SMS_SDK/SMSSDK.h>

NSString * const GET_VERIFICATION_CODE_ERROOR_KEY = @"getVerificationCode";
NSString * const COMMIT_VERIFICATION_CODE_ERROR_KEY = @"commitVerificationCode";

NSString * const GET_VERIFICATION_CODE_ERROR_DEFAULT_MSG = @"获取验证码失败";
NSString * const COMMIT_VERIFICATION_CODE_ERROR_DEFAULT_MSG = @"验证码验证失败";

@implementation TTSMSManager
+ (void)managerRegisterAppKey:(NSString *)appKey withSecret:(NSString *)secret {
    NSAssert(STR_ISNOT_NULL_OR_EMPTY(appKey), @"SMSSDK AppKey is nil");
    NSAssert(STR_ISNOT_NULL_OR_EMPTY(secret), @"SMSSDK Secret is nil");
    [SMSSDK registerApp:appKey withSecret:secret];
}

+ (BOOL)getVerificationCodeByPhoneNum:(NSString *)phoneNum resultBlock:(SMSResultBlock)resultBlock {
    if ([NSString isNilOrEmpty:phoneNum]) {
        return NO;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNum zone:@"86" customIdentifier:nil result:resultBlock];
    return YES;
}

+ (BOOL)commitVerificationCode:(NSString *)code phoneNum:(NSString *)phoneNum resultBlock:(SMSResultBlock)resultBlock {
    if ([NSString isNilOrEmpty:code]) {
        return NO;
    }
    if ([NSString isNilOrEmpty:phoneNum]) {
        return NO;
    }
    [SMSSDK commitVerificationCode:code phoneNumber:phoneNum zone:@"86" result:resultBlock];
    return YES;
}

+ (NSString *)fetchDescribeWithKey:(NSString *)key withError:(NSError *)error {
    NSString *describe = @"";
    if (!error) {
        return describe;
    }
    NSDictionary *errUserInfo = error.userInfo;
    if (!errUserInfo || errUserInfo.allKeys.count == 0 || ![errUserInfo.allKeys containsObject:key]) {
        return describe;
    }
    describe = [errUserInfo objectForKey:key];
    return describe;
}

@end
