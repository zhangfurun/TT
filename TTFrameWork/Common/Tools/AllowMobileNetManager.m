//
//  AllowMobileNetManager.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "AllowMobileNetManager.h"

#import "TTConst.h"

#import "TTAlertView.h"

#import "NSUserDefaults+TTUserDefaults.h"

//#define USER_ALLOW_DOWNLOAD_2G3G4G      [NSString stringWithFormat:@"%@_ALLOW_DOWNLOAD_2G3G4G", [User getLoginUserId]]
//#define USER_ALLOW_DOWNLOAD_SETHISTORY  [NSString stringWithFormat:@"%@_ALLOW_DOWNLOAD_SETHISTORY", [User getLoginUserId]]

#define USER_ALLOW_DOWNLOAD_2G3G4G      @"ALLOW_DOWNLOAD_2G3G4G"
#define USER_ALLOW_DOWNLOAD_SETHISTORY  @"ALLOW_DOWNLOAD_SETHISTORY"

NSString *const TTAllowUseMobileNetworkKey = @"TTAllowUseMobileNetworkKey";

NSString * const UserAllowNetChoose = @"UserAllowNetChoose";

static AllowMobileNetManager *standardManager = nil;

@implementation AllowMobileNetManager
+ (AllowMobileNetManager *)standardManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        standardManager=[[AllowMobileNetManager alloc]init];
    });
    return standardManager;
}

- (void)setAllowDownload:(BOOL)allowDownload {
    [NSUserDefaults setBoolValue:YES forKey:USER_ALLOW_DOWNLOAD_SETHISTORY];
    [NSUserDefaults setBoolValue:allowDownload forKey:TTAllowUseMobileNetworkKey];
}

- (BOOL)isAllowDownload {
    if ([NSUserDefaults boolValueForKey:USER_ALLOW_DOWNLOAD_SETHISTORY]) {
        return [NSUserDefaults boolValueForKey:TTAllowUseMobileNetworkKey];
    }else {
        // 带弹框的
        __block BOOL userChooseFlag = NO;
        [TTAlertView alertViewTitle:@"提示"
                            message:@"是否允许移动网络下载绘本?"
                        cancelTitle:@"不允许"
                       confirmTitle:@"允许"
                        cancelBlock:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:UserAllowNetChoose object:nil];
                            self.allowDownload = NO;
                        }
                       confirmBlock:^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:UserAllowNetChoose object:nil];
                           self.allowDownload = YES;
                       }];
        return userChooseFlag;
        
//        //不带弹框提示,目前,默认是不使用
//        [self setAllowDownload:NO];
//        return NO;
    }
}
@end
