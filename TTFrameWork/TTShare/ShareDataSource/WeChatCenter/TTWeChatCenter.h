//
//  TTWeChatCenter.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseShareCenter.h"

#import "WXApi.h"

@interface TTWeChatCenter : TTBaseShareCenter <WXApiDelegate>
@property (nonatomic, assign, readonly, getter=isInstalledWeChat) BOOL installedWeChat;

+ (instancetype)shareInstance;
- (void)openWXClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock;
@end
