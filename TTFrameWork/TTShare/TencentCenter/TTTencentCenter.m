//
//  TTTencentCenter.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTencentCenter.h"
NSString * const TXErrorDomain = @"TTTencentError";

@interface TTTencentCenter ()
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong) TencentOAuth *oAuth;
@property (nonatomic, copy) ShareSuccessBlock successBlock;
@property (nonatomic, copy) ShareCancelBlock cancelBlock;
@property (nonatomic, copy) ShareFailureBlock failureBlock;
@end

static TTTencentCenter *instance;
@implementation TTTencentCenter

#pragma mark - Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        if ([NSUserDefaults isExistsForKey:QQAppIdKey]) {
            NSString *appId = [NSUserDefaults stringValueForKey:QQAppIdKey];
            _oAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
        }
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)copy {
    return  self;
}

#pragma mark - Property Method
- (InstallClientType)isInstalledClient {
    if (self.isInstalledQQ && self.isInstalledQZone) {
        return InstallClientType_Both_QQ_QZone;
    } else if (self.isInstalledQQ) {
        return InstallClientType_QQ;
    } else if (self.installedQZone) {
        return InstallClientType_QZone;
    }
    return InstallClientType_None;
}

- (BOOL)isInstalledQQ {
    return [TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin];
}

- (BOOL)isInstalledQZone {
    return [TencentOAuth iphoneQZoneInstalled] && [TencentOAuth iphoneQZoneSupportSSOLogin];
}

- (NSArray *)permissions {
    return @[kOPEN_PERMISSION_ADD_TOPIC,
             kOPEN_PERMISSION_GET_INFO,
             kOPEN_PERMISSION_GET_USER_INFO,
             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
}

#pragma mark - Method
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)openQQClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock
                          cancelBlock:(ShareCancelBlock)cancelBlock
                         failureBlock:(ShareFailureBlock)failureBlock {
    self.successBlock = successBlock;
    self.cancelBlock = cancelBlock;
    self.failureBlock = failureBlock;
    [self.oAuth authorize:self.permissions];
}

- (void)openQZoneClientOAuth {
    
}

- (void)shareContentInfo:(ShareContentInfo *)contentInfo successBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    if (!contentInfo || contentInfo.contentType == ShareContentType_None) {
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:TXErrorDomain code:-102 userInfo:@{ErrorDescKey: @"未设置分享内容"}];
            failureBlock(error);
        }
        return;
    }
    QQApiObject *qqApiObj = nil;
    switch (contentInfo.contentType) {
        case ShareContentType_None:
            break;
        case ShareContentType_Text: {
            qqApiObj = [QQApiTextObject objectWithText:contentInfo.content];
        }
            break;
        case ShareContentType_Image: {
            qqApiObj = [QQApiImageObject objectWithData:contentInfo.objData previewImageData:contentInfo.objData title:contentInfo.title description:contentInfo.content];
        }
            break;
        case ShareContentType_Link: {
            NSURL *url = [NSURL URLWithString:contentInfo.urlStr];
            qqApiObj = [QQApiURLObject objectWithURL:url title:contentInfo.title description:contentInfo.content previewImageData:contentInfo.objData targetContentType:QQApiURLTargetTypeNews];
        }
            break;
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:qqApiObj];
    QQApiSendResultCode resultCode = [QQApiInterface sendReq:req];
    [self handleSendResult:resultCode successBlock:successBlock cancelBlock:cancelBlock failureBlock:failureBlock];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult successBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock {
    NSString *errorMsg = nil;
    switch (sendResult) {
        case EQQAPISENDSUCESS: {
            if (successBlock) {
                successBlock();
            }
            return;
        }
        case EQQAPIAPPNOTREGISTED: {
            errorMsg = @"App未注册";
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            errorMsg = @"发送参数错误";
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            errorMsg = @"未安装手Q";
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI: {
            errorMsg = @"API接口不支持";
            break;
        }
        case EQQAPISENDFAILD: {
            errorMsg = @"发送失败";
            break;
        }
        default: {
            break;
        }
    }
    if (errorMsg) {
        [self executeFailureBlock:failureBlock errorDomain:TXErrorDomain errorMsg:errorMsg errorCode:sendResult];
        return;
    }
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (self.cancelBlock) {
        self.cancelBlock(cancelled);
    }
}

- (void)tencentDidNotNetWork {
    if (self.failureBlock) {
        NSError *error = [NSError errorWithDomain:TXErrorDomain code:-100 userInfo:@{ErrorDescKey:@"没有网络，请设置网络连接"}];
        self.failureBlock(error);
    }
}

- (void)tencentDidLogin {
    if (self.oAuth.accessToken && 0 != [self.oAuth.accessToken length]) {
        if ([self.oAuth getUserInfo]) {
            NSLog(@"授权成功");
        }
    } else {
        NSLog(@"授权失败");
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.errorMsg) {
        if (self.failureBlock) {
            NSError *error = [NSError errorWithDomain:TXErrorDomain code:-101 userInfo:@{ErrorDescKey:response.jsonResponse?:@""}];
            self.failureBlock(error);
        }
    } else {
        TTAuthInfo *auth = [[TTAuthInfo alloc] init];
        auth.openId = self.oAuth.openId;
        auth.accessToken = self.oAuth.accessToken;
        auth.expiresDate = [NSString stringWithFormat:@"%f",[self.oAuth.expirationDate timeIntervalSince1970]];
        self.authInfo = auth;
        
        TTShareUser *user = [[TTShareUser alloc] initWithQQDict:response.jsonResponse];
        user.userId = self.oAuth.openId;
        self.user = user;
        if (self.successBlock) {
            self.successBlock();
        }
    }
}

#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}


@end
