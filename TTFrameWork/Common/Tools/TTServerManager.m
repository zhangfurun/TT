//
//  TTServerManager.m
//  TT
//
//  Created by zhangfurun on 2017/7/24.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTServerManager.h"

#import "NSBundle+TTBundle.h"
#import "NSUserDefaults+TTUserDefaults.h"

NSString * const LOG_STATUS_KEY         = @"LogStatus";
NSString * const REQ_SERVER_TYPE_KEY    = @"ReqServerType";

NSString * const UNKNOWN_SERVER_NAME    = @"未知服务器";
NSString * const FORMAL_SERVER_NAME     = @"正式服务器";
NSString * const TEST_SERVER_NAME       = @"测试服务器";
NSString * const BETA_SERVER_NAME       = @"Beta服务器";
NSString * const LOCAL_SERVER_NAME      = @"本地服务器";

@implementation TTServerManager
#pragma mark - Property Method

static BOOL _debugVersion = NO;
+ (BOOL)isDebugVersion {
    _debugVersion = [[NSBundle appVersion] hasPrefix:@"0."];
    return _debugVersion;
}

static BOOL _switchServer = NO;
+ (BOOL)isSwitchServer {
    return _switchServer;
}

static TTReqServerType _reqServerType = TTReqServerTypeUnKnown;
+ (void)setReqServerType:(TTReqServerType)reqServerType {
    _switchServer = _reqServerType != reqServerType;
    if (!self.isSwitchServer) {
        return;
    }
    _reqServerType = reqServerType;
    [NSUserDefaults setIntegerValue:reqServerType forKey:REQ_SERVER_TYPE_KEY];
}

+ (TTReqServerType)reqServerType {
    if (!self.isSwitchServer && _reqServerType != TTReqServerTypeUnKnown) {
        return _reqServerType;
    }
    if ([NSUserDefaults isExistsForKey:REQ_SERVER_TYPE_KEY]) {
        _switchServer = NO;
        _reqServerType = [NSUserDefaults integerValueForKey:REQ_SERVER_TYPE_KEY];
    } else {
        _reqServerType = TTReqServerTypeFormal;
    }
    return _reqServerType;
}

+ (NSString *)serverName {
    switch (self.reqServerType) {
        case TTReqServerTypeFormal:
            return FORMAL_SERVER_NAME;
        case TTReqServerTypeBeta:
            return BETA_SERVER_NAME;
        case TTReqServerTypeTest:
            return TEST_SERVER_NAME;
        case TTReqServerTypeLocal:
            return LOCAL_SERVER_NAME;
        case TTReqServerTypeUnKnown:
            return UNKNOWN_SERVER_NAME;
    }
}

static BOOL _logStatusOpen = NO;
+ (void)setLogStatusOpen:(BOOL)logStatusOpen {
    _logStatusOpen = logStatusOpen;
    [NSUserDefaults setBoolValue:logStatusOpen forKey:LOG_STATUS_KEY];
}

+ (BOOL)isLogStatusOpen {
    if ([NSUserDefaults isExistsForKey:LOG_STATUS_KEY]) {
        _logStatusOpen = [NSUserDefaults boolValueForKey:LOG_STATUS_KEY];
    }
    return _logStatusOpen;
}

#pragma mark - Method
+ (BOOL)isCurrentServerType:(TTReqServerType)serverType {
    return self.reqServerType == serverType;
}


@end
