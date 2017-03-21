//
//  TTSinaCenter.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseShareCenter.h"

#import "WeiboSDK.h"

@interface TTSinaCenter : TTBaseShareCenter<WeiboSDKDelegate>
@property (nonatomic, assign, readonly, getter=isInstalledWeibo) BOOL installedWeibo;

+ (instancetype)shareInstance;
- (void)openSinaClientOAuthSuccessBlock:(ShareSuccessBlock)successBlock cancelBlock:(ShareCancelBlock)cancelBlock failureBlock:(ShareFailureBlock)failureBlock;

@end
