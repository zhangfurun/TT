//
//  TTSinaCenter.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTSinaCenter.h"

#import "SinaAuthRequest.h"

NSString * const RedirectURI = @"https://api.weibo.com/oauth2/default.html";
NSString * const WBErrorDomain = @"WBErrorDomain";

static TTSinaCenter *instance;

@interface TTSinaCenter ()
@property (nonatomic, strong) WBAuthorizeResponse *responseInfo;
@property (nonatomic, copy) ShareSuccessBlock successBlock;
@property (nonatomic, copy) ShareCancelBlock  cancelBlock;
@property (nonatomic, copy) ShareFailureBlock failureBlock;
@end

@implementation TTSinaCenter

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([NSUserDefaults isExistsForKey:SinaAppIdKey]) {
            NSString *sinaAppId = [NSUserDefaults stringValueForKey:SinaAppIdKey];
            [WeiboSDK registerApp:sinaAppId];
        }
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)copy {
    return self;
}

#pragma mark - Property Method
- (InstallClientType)isInstalledClient {
    return self.isInstalledWeibo ? InstallClientType_Weibo : InstallClientType_None;
}

- (BOOL)isInstalledWeibo {
    return [WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanSSOInWeiboApp];
}

#pragma mark - Method
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TTSinaCenter new];
    });
    return instance;
}

- (void)openSinaClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failureBlock = failureBlock;
    
    [WeiboSDK sendRequest:[self getAuthorizeRequest]];
}

- (WBAuthorizeRequest *)getAuthorizeRequest {
    WBAuthorizeRequest *req = [WBAuthorizeRequest request];
    NSString *uri = RedirectURI;
    if ([NSUserDefaults isExistsForKey:SinaRedirectURIKey]) {
        uri = [NSUserDefaults stringValueForKey:SinaRedirectURIKey];
    }
    req.redirectURI = uri;
    req.scope = @"all";
    return req;
}

- (void)shareContentInfo:(ShareContentInfo *)contentInfo successBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failureBlock = failureBlock;
    
    ShareContentType contentType = contentInfo.contentType;// == ShareContentType_Link ? ShareContentType_Image : contentInfo.contentType;
    WBMessageObject *message = [WBMessageObject message];
    message.text = contentInfo.content;
    switch (contentType) {
        case ShareContentType_None:
            break;
        case ShareContentType_Text:{
        }
            break;
        case ShareContentType_Image: {
            WBImageObject *image = [WBImageObject object];
            image.imageData = contentInfo.objData;
            message.imageObject = image;
        }
            break;
        case ShareContentType_Link:{
            WBWebpageObject *webpageObject = [WBWebpageObject object];
            webpageObject.objectID = @"VistaKTX";
            webpageObject.title = contentInfo.title;
            webpageObject.description = contentInfo.content?:@"";
            webpageObject.thumbnailData = contentInfo.objData;
            webpageObject.webpageUrl = contentInfo.urlStr;
            message.mediaObject = webpageObject;
        }
            break;
    }
    WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:req];
}

#pragma mark - Request
- (void)getSinaUserInfoRequest {
    __weak typeof(self) WS = self;
    [SinaAuthRequest requestParameters:@{@"access_token":self.authInfo.accessToken, @"uid":self.authInfo.openId} successBlock:^(TTBaseRequest *request) {
        if (WS.successBlock) {
            WS.successBlock();
        }
    } cancelBlock:^(TTBaseRequest *request){
        if (WS.cancelBlock) {
            WS.cancelBlock(YES);
        }
    } failureBlock:^(TTBaseRequest *request, NSError *error) {
        if (WS.failureBlock) {
            [WS executeFailureBlock:WS.failureBlock errorDomain:WBErrorDomain errorMsg:@"获取微博用户信息失败" errorCode:-103];
        }
    }];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    BOOL isWBSendMsgResp = [response isMemberOfClass:[WBSendMessageToWeiboResponse class]];
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        if (isWBSendMsgResp) {
            if (self.successBlock) {
                self.successBlock();
            }
        } else {
            self.responseInfo = (WBAuthorizeResponse *)response;
            TTAuthInfo *authInfo = [[TTAuthInfo alloc] init];
            authInfo.openId = self.responseInfo.userID;
            authInfo.accessToken = self.responseInfo.accessToken;
            authInfo.expiresDate = [NSString stringWithFormat:@"%f",self.responseInfo.expirationDate.timeIntervalSince1970];
            self.authInfo = authInfo;
            [self getSinaUserInfoRequest];
        }
    } else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
        if (self.cancelBlock) {
            self.cancelBlock(YES);
        }
    } else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny)  {
        if (self.failureBlock) {
            [self executeFailureBlock:self.failureBlock errorDomain:WBErrorDomain errorMsg:isWBSendMsgResp ? @"分享失败" : @"授权失败" errorCode:response.statusCode];
        }
    }
}

@end
