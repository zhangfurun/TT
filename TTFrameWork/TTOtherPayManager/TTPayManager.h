//
//  TTPayManager.h
//  StoryShip
//
//  Created by 张福润 on 2017/4/23.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTBaseModel.h"

#define TTPAY_MANAGER [TTPayManager sharedManager]

@class WeChatPayModel;

typedef enum : NSUInteger {
    ErrorCodeType_Success,
    ErrorCodeType_Failure,
    ErrorCodeType_Cancel,
} ErrorCodeType;

typedef void(^SuccessBlock)();
typedef void(^CancelBlock)();
typedef void(^FailureBlock)(NSString *errStr);

@interface TTPayManager : NSObject
+ (instancetype)sharedManager;

/**
 注册微信和支付宝
 */
- (void)registerApp;

/**
 处理跳转url，回到应用，需要在delegate中实现
 */
- (BOOL)handleUrl:(NSURL *)url;

/**
 支付

 @param orderMessage 支付信息 微信为OrderPayModel 支付宝为NSString
 @param successBlock 成功的回调
 @param cancelBlock 取消的回调
 @param failureBlock 失败的回调
 */
- (void)payWithOrderMessage:(id)orderMessage
               successBlock:(SuccessBlock)successBlock
                cancelBlock:(CancelBlock)cancelBlock
               failureBlock:(FailureBlock)failureBlock;

@end

@interface WeChatPayModel : TTBaseModel
@property (copy, nonatomic) NSString *payTitle;
@property (copy, nonatomic) NSString *orderNo; // orderCode
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *notifyUrl; // 微信的回调地址
@end


@interface AliPayModel : TTBaseModel
@property (copy, nonatomic) NSString *payTitle;
@property (copy, nonatomic) NSString *orderNo; // orderCode
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *notifyUrl; // 微信的回调地址
@property (copy, nonatomic) NSString *body; // 描述
@end
