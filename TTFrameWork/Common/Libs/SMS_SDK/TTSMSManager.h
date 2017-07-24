//
//  TTSMSManager.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SMSResultBlock)(NSError *error);


extern NSString * const GET_VERIFICATION_CODE_ERROOR_KEY;
extern NSString * const COMMIT_VERIFICATION_CODE_ERROR_KEY;

extern NSString * const GET_VERIFICATION_CODE_ERROR_DEFAULT_MSG;
extern NSString * const COMMIT_VERIFICATION_CODE_ERROR_DEFAULT_MSG;

@interface TTSMSManager : NSObject

/**
 注册APPkey和Secret

 @param appKey AppKey
 @param secret Secret
 */
+ (void)managerRegisterAppKey:(NSString *)appKey withSecret:(NSString *)secret;
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

/**
 获得验证码失败描述信息
 
 @param key UserInfo中的Key，可以使用 extern 定义的字符串常量
 @param error SMSSDK返回的错误信息
 @return SMSSDK返回的错误描述信息
 */
+ (NSString *)fetchDescribeWithKey:(NSString *)key withError:(NSError *)error;
@end
