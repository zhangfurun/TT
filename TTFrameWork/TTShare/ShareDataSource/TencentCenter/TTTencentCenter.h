//
//  TTTencentCenter.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseShareCenter.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface TTTencentCenter : TTBaseShareCenter<TencentSessionDelegate,QQApiInterfaceDelegate>
@property (nonatomic, assign, readonly, getter=isInstalledQQ) BOOL installedQQ;
@property (nonatomic, assign, readonly, getter=isInstalledQZone) BOOL installedQZone;

+ (instancetype)shareInstance;
- (void)openQQClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock;
- (void)openQZoneClientOAuth;
@end
