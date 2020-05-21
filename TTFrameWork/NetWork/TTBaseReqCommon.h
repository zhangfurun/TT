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

static NSString * TT_FetchFailureErrorMsg(NSError *error) {
    NSString *msg = @"发生了一个未知的错误";
    switch (error.code) {
        case NSURLErrorTimedOut:
            msg = @"网络请求超时";
            break;
        case NSURLErrorCannotFindHost:
        case NSURLErrorDNSLookupFailed:
        case NSURLErrorCannotConnectToHost:
            msg = @"未能连接服务器";
            break;
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
            msg = @"网络似乎丢失了，请检查网络是否还在";
            break;
        case NSURLErrorBadURL:
        case NSURLErrorUnsupportedURL:
        case NSURLErrorHTTPTooManyRedirects:
        case NSURLErrorRedirectToNonExistentLocation:
            msg = @"当前请求地址暂时不支持";
            break;
        case NSURLErrorFileIsDirectory:
        case NSURLErrorFileDoesNotExist:
        case NSURLErrorZeroByteResource:
        case NSURLErrorBadServerResponse:
            msg = @"服务器资源错误";
            break;
        case NSURLErrorCannotDecodeRawData:
        case NSURLErrorResourceUnavailable:
        case NSURLErrorCannotParseResponse:
        case NSURLErrorCannotDecodeContentData:
        case NSURLErrorRequestBodyStreamExhausted:
            msg = @"服务器内部错误,暂时无法显示";
            break;
        case NSURLErrorDataNotAllowed:
        case NSURLErrorUserCancelledAuthentication:
            msg = @"网络使用权未获得允许，无法联网";
            break;
        case NSURLErrorNoPermissionsToReadFile:
            msg = @"文件似乎没有权限获得";
            break;
        case NSURLErrorDataLengthExceedsMaximum:
            msg = @"获取的数据太大了，超出显示能力了";
            break;
        case NSURLErrorCancelled:
            msg = @"请求已取消";
            break;
        default:
            break;
    }
    return msg;
}

#endif /* TTBaseReqCommon_h */
