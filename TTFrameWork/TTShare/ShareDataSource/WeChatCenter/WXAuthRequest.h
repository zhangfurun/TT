//
//  WXAuthRequest.h
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBaseRequest.h"

@interface WXGetAccessTokenRequest : TTBaseRequest
//code
//appid
//secret
@end

@interface WXRefreshAccessTokenRequest : TTBaseRequest
//appid
//refresh_token
@end

@interface WXGetUserInfoReqeust : TTBaseRequest
//access_token
//openid
@end
