//
//  TTSMSManager.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SMSResultBlock)(NSError *error);

@interface TTSMSManager : NSObject
/**
 *  获取验证码
 *
 *  @param phoneNum    手机号
 *  @param resultBlock 获取验证码完成回调
 *
 *  @return 发送请求成功或失败
 */
+ (BOOL)getVerificationCodeByPhoneNum:(NSString *)phoneNum resultBlock:(SMSResultBlock)resultBlock;
/**
 *  提交验证码
 *
 *  @param code        验证码
 *  @param phoneNum    手机号
 *  @param resultBlock 提交验证码后回调用
 *
 *  @return 发送请求成功或失败
 */
+ (BOOL)commitVerificationCode:(NSString *)code phoneNum:(NSString *)phoneNum resultBlock:(SMSResultBlock)resultBlock;
@end
