//
//  TTAuthInfo.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseModel.h"

typedef enum : NSUInteger {
    ShareType_None = 0,
    ShareType_WeChat = 1,
    ShareType_QQ = 2,
    ShareType_Sina = 3,
    ShareType_QZone,
    ShareType_WeChatTimeline,
    ShareType_Phone
} ShareType;

@interface TTAuthInfo : TTBaseModel
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *expiresDate;
/**
 *  wechat使用
 */
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *unionId;
@end
