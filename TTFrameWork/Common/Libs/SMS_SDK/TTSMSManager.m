//
//  TTSMSManager.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTSMSManager.h"

#import "NSString+TTString.h"

#import <SMS_SDK/SMSSDK.h>

@implementation TTSMSManager

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

@end
