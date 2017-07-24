//
//  TTServerManager.h
//  TT
//
//  Created by zhangfurun on 2017/7/24.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTBaseReqCommon.h"

extern NSString * const LOG_STATUS_KEY;
extern NSString * const REQ_SERVER_TYPE_KEY;

extern NSString * const UNKNOWN_SERVER_NAME;
extern NSString * const FORMAL_SERVER_NAME;
extern NSString * const TEST_SERVER_NAME;
extern NSString * const BETA_SERVER_NAME;
extern NSString * const LOCAL_SERVER_NAME;

@interface TTServerManager : NSObject
@property (nonatomic, assign, readonly, class, getter=isDebugVersion) BOOL debugVersion;
@property (nonatomic, assign, readonly, class, getter=isSwitchServer) BOOL switchServer;
@property (nonatomic, assign, class) TTReqServerType reqServerType;
@property (nonatomic, strong, readonly, class) NSString *serverName;
@property (nonatomic, assign, class, getter=isLogStatusOpen) BOOL logStatusOpen;

+ (BOOL)isCurrentServerType:(TTReqServerType)serverType;

@end
