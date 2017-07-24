//
//  TTBaseReqCommon.h
//  TT
//
//  Created by zhangfurun on 2017/7/24.
//  Copyright © 2017年 张福润. All rights reserved.
//

#ifndef TTBaseReqCommon_h
#define TTBaseReqCommon_h

@class TTBaseRequest;

typedef NS_ENUM(NSUInteger, TTRequestMethod) {
    TTRequestMethodGet,
    TTRequestMethodPost,
    TTRequestMethodPut,
    TTRequestMethodDelete
};

typedef NS_ENUM(NSInteger, TTNetworkReachabilityStatus) {
    TTNetworkReachabilityStatusUnknown          = -1,
    TTNetworkReachabilityStatusNotReachable     = 0,
    TTNetworkReachabilityStatusReachableViaWWAN = 1,
    TTNetworkReachabilityStatusReachableViaWiFi = 2,
};


typedef NS_ENUM(NSUInteger, TTRequestError) {
    TTRequestErrorNetwork = 0
};

typedef NS_ENUM(NSInteger, TTReqServerType) {
    TTReqServerTypeUnKnown  = -1,
    TTReqServerTypeFormal   = 0,
    TTReqServerTypeTest     = 1,
    TTReqServerTypeBeta     = 2,
    TTReqServerTypeLocal    = 3
};

typedef void(^reqSuccessBlock)(TTBaseRequest *request);
typedef void(^reqCancelBlock)(TTBaseRequest *request);
typedef void(^reqFailureBlock)(TTBaseRequest *request, NSError *error);
typedef void(^reqUploadBlock)(TTBaseRequest *request, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

#endif /* TTBaseReqCommon_h */
