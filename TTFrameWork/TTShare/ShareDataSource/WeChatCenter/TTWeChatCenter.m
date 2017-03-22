//
//  TTWeChatCenter.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTWeChatCenter.h"

#import "TTKit.h"

#import "WXAuthRequest.h"

NSString * const WXErrorDomain = @"TTWeChatCenter";

static TTWeChatCenter *instance;

@interface TTWeChatCenter ()
@property (nonatomic, strong) SendAuthResp *authResp;
@property (nonatomic, copy) ShareSuccessBlock successBlock;
@property (nonatomic, copy) ShareCancelBlock  cancelBlock;
@property (nonatomic, copy) ShareFailureBlock failuerBlok;
@end

@implementation TTWeChatCenter

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([NSUserDefaults isExistsForKey:WeChatAppIdKey]) {
            NSString *wechatAppId = [NSUserDefaults stringValueForKey:WeChatAppIdKey];
            [WXApi registerApp:wechatAppId];
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
    if (self.isInstalledWeChat) {
        return InstallClientType_WeChat;
    }
    return InstallClientType_None;
}

- (BOOL)isInstalledWeChat {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

#pragma mark - Method
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TTWeChatCenter new];
    });
    return instance;
}

- (void)openWXClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failuerBlok = failureBlock;
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"TTState";
    [WXApi sendReq:req];
}

- (void)shareContentInfo:(ShareContentInfo *)contentInfo successBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failuerBlok = failureBlock;
    
    ShareContentType contentType = contentInfo.contentType;
    ShareType shareType = contentInfo.shareType;
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    if (contentType != ShareContentType_None || contentType != ShareContentType_Text) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = contentInfo.title;
        message.description = contentInfo.content;
        [message setThumbData:contentInfo.objData];
        req.bText = NO;
        req.message = message;
    }
    switch (contentType) {
        case ShareContentType_None:
            break;
        case ShareContentType_Text:
            req.text = contentInfo.content;
            req.bText = YES;
            break;
        case ShareContentType_Image: {
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = contentInfo.objData;
            
            WXMediaMessage *message = req.message;
            message.mediaObject = imageObject;
            req.message = message;
        }
            break;
        case ShareContentType_Link: {
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = contentInfo.urlStr;
            
            WXMediaMessage *message = req.message;
            message.mediaObject = webpageObject;
            req.message = message;
        }
            break;
    }
    req.scene = shareType == ShareType_WeChat ? WXSceneSession : WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark - Request
- (void)getAccessTokenRequst {
    __weak typeof(self) WS = self;
    [WXGetAccessTokenRequest requestParameters:@{@"code": self.authResp.code} successBlock:^(TTBaseRequest *request) {
        [WS getUserInfoRequest];
    } cancelBlock:^(TTBaseRequest *request) {
        
    } failureBlock:^(TTBaseRequest *request, NSError *error) {
        if (WS.failuerBlok) {
            [WS executeFailureBlock:WS.failuerBlok errorDomain:WXErrorDomain errorMsg:WS.authResp.errStr errorCode:WS.authResp.errCode];
        }
    }];
    
}

- (void)getUserInfoRequest {
    __weak typeof(self) WS = self;
    TTAuthInfo *authInfo = self.authInfo;
    [WXGetUserInfoReqeust requestParameters:@{@"access_token":authInfo.accessToken,@"openid":authInfo.openId} successBlock:^(TTBaseRequest *request) {
        if (WS.successBlock) {
            WS.successBlock();
        }
    } cancelBlock:^(TTBaseRequest *request) {
        
    } failureBlock:^(TTBaseRequest *request, NSError *error) {
        if (WS.failuerBlok) {
            [WS executeFailureBlock:WS.failuerBlok errorDomain:WXErrorDomain errorMsg:WS.authResp.errStr errorCode:WS.authResp.errCode];
        }
    }];
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    self.authResp = (SendAuthResp *)resp;
    BOOL isSendMsgResp = [resp isMemberOfClass:[SendMessageToWXResp class]];
    if (self.authResp.errCode == 0) {
        if (isSendMsgResp) {
            self.successBlock();
        } else {
            [self getAccessTokenRequst];
        }
    } else if (self.authResp.errCode == -2) {
        if (self.cancelBlock) {
            self.cancelBlock(YES);
        }
    } else {
        if (self.failuerBlok) {
            [self executeFailureBlock:self.failuerBlok errorDomain:WXErrorDomain errorMsg:resp.errStr errorCode:resp.errCode];
        }
    }
}

@end

