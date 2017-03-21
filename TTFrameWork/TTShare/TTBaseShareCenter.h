//
//  TTBaseShareCenter.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTShareUser.h"
#import "TTAuthInfo.h"
#import "ShareContentInfo.h"

#import "NSUserDefaults+TTUserDefaults.h"

typedef void(^ShareSuccessBlock)();
typedef void(^ShareCancelBlock)(BOOL cancelled);
typedef void(^ShareFailureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, InstallClientType) {
    InstallClientType_None,
    InstallClientType_QQ,
    InstallClientType_QZone,
    InstallClientType_Both_QQ_QZone,
    InstallClientType_Weibo,
    InstallClientType_WeChat
};

typedef enum : NSUInteger {
    SourceAppTypeUnknow,
    SourceAppTypeQQ,
    SourceAppTypeWX,
    SourceAppTypeWB,
} SourceAppType;

FOUNDATION_EXTERN NSString * const ErrorDescKey;

FOUNDATION_EXTERN NSString * const QQAppIdKey;
FOUNDATION_EXTERN NSString * const SinaAppIdKey;
FOUNDATION_EXTERN NSString * const SinaRedirectURIKey;
FOUNDATION_EXTERN NSString * const WeChatAppIdKey;
FOUNDATION_EXTERN NSString * const WeChatAppSecretKey;

@interface TTBaseShareCenter : NSObject
@property (nonatomic, strong) TTShareUser *user;
@property (nonatomic, strong) TTAuthInfo *authInfo;
@property (nonatomic, strong, readonly) NSDictionary *AppIdDict;
@property (nonatomic, assign, readonly, getter=isInstalledClient) InstallClientType installedClient;

- (void)openClientAuthWithShareType:(ShareType)shareType successBlock:(ShareSuccessBlock)shareSuccessBlock cancelBlock:(ShareCancelBlock)shareCancelBlock failureBlock:(ShareFailureBlock)shareFailureBlock;
+ (SourceAppType)sourceAppTypeWithSourceAppString:(NSString *)sourceApplication;
+ (BOOL)handlerOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
/**
 *  设置各平台的AppId、AppSecret、RedirectURI
 *
 *  @param appIdDict       key 为QQAppIdKey,SinaAppIdKey,WeChatAppIdKey value 为各平台AppId
 *  @param appSecretDict   key 为WeChatAppSecretKey,... value为各平台的Secret
 *  @param redirectURIDict key 为SinaRedirectURIKey,... value为各平台的RedirectURI
 */
+ (void)setAppId:(NSDictionary *)appIdDict appSecret:(NSDictionary *)appSecretDict redirectURI:(NSDictionary *)redirectURIDict;
+ (TTBaseShareCenter *)getShareCenterWithShareType:(ShareType)shareType;
- (void)shareContentInfo:(ShareContentInfo *)contentInfo successBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock;
- (void)executeFailureBlock:(ShareFailureBlock)failureBlock errorDomain:(NSString *)ErrorDomain errorMsg:(NSString *)errorMsg errorCode:(NSInteger)errorCode;

@end
