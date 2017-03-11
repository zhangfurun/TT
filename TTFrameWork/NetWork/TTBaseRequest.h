//
//  TTBaseRequest.h
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class TTBaseRequest;

typedef enum : NSUInteger {
    TTRequestTypeGet, // Default
    TTRequestTypePost,
    TTRequestTypePut,
    TTRequestTypeDelete
} TTRequestType;

typedef enum : NSUInteger {
    TTNetworkReachabilityStatusUnknown = -1,
    TTNetworkReachabilityStatusNoNetWork = 0,
    TTNetworkReachabilityStatusMobileNet = 1,
    TTNetworkReachabilityStatusWIFI = 2,
} TTNetworkReachabilityStatus;

typedef NS_ENUM(NSUInteger, TTRequestError) {
    TTRequestErrorNetwork = 0
};

static NSString *Key_Model = @"Key_Model";

typedef void(^reqSuccessBlock)(TTBaseRequest *request);
typedef void(^reqCancelBlock)(TTBaseRequest *request);
typedef void(^reqFailureBlock)(TTBaseRequest *request, NSError *error);
typedef void(^reqUploadBlock)(TTBaseRequest *request, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface TTBaseRequest : NSObject
@property (nonatomic, copy,   readonly) NSString *requestUrl;
@property (nonatomic, strong, readonly) NSDictionary *requestParameters;
@property (nonatomic, strong, readonly) NSMutableArray *binaryParameterArray;
@property (nonatomic, strong, readonly) NSMutableDictionary *resultDict;
@property (nonatomic, strong, readonly) NSMutableArray *resultArray;
@property (nonatomic, copy)             NSString *resultString;
@property (nonatomic, strong, readonly) UIImage *responseImage;
@property (nonatomic, assign, readonly) BOOL isSuccess;

#pragma mark - Class Methods
/**
 基本数据请求

 @param parameters      请求参数,将需要的参数名称+参数实体(非二进制)
 @param successBlock    成功回调
 @param cancelBlock     取消回调
 @param failureBlock    失败回调
 */
+ (void)requestParameters:(NSDictionary *)parameters
             successBlock:(reqSuccessBlock)successBlock
              cancelBlock:(reqCancelBlock)cancelBlock
             failureBlock:(reqFailureBlock)failureBlock;
/**
 上传执行数据请求

 @param parameters          请求参数,主要是对接服务器接口所需要的参数
 @param binaryArray         二进制文件(这里采用封装的TTBinaryData对象)
 @param successBlock        成功回调
 @param cancelBlock         失败回调
 @param failureBlock        取消回调
 @param uploadProcessBlock  上传进度回调
 */
+ (void)requestParameters:(NSDictionary *)parameters
              binaryArray:(NSMutableArray *)binaryArray
             successBlock:(reqSuccessBlock)successBlock
              cancelBlock:(reqCancelBlock)cancelBlock
             failureBlock:(reqFailureBlock)failureBlock
        uplodProcessBlock:(reqUploadBlock)uploadProcessBlock;


/**
 获取请求的URL地址(可以理解为请求地址)
 */
- (NSString *)getRequestUrl;
/**
 当前是不是正在请求数据的过成功
 e.g.主要是解决数据重复请求的问题
 */
+ (BOOL)isRequesting;

/**
 启动网络监听
 PS:这个要在系统启动的时候调用,进行网络数据监听
 */
+ (void)starNetWorkReachability;

/**
 当前网络状态
 */
+ (TTNetworkReachabilityStatus)fetchReachabilityStatus;


#pragma mark - Children Class

/**
 设置请求地址
 这里我们可以理解为,在整个项目的请求连接中,所有数据请求的根目录
 e.g.http://IP地址:端口/根文件夹/
 */
- (NSString *)getRequestHost;
- (NSString *)getRequestQuery;
- (NSString *)getUserAgent;

/**
 自定义请求头
 PS:一般会出现在,项目数据请求的加密,在某阶段临时添加的请求头,区别于公司定制的Base请求头数据
 */
- (NSDictionary<NSString *, NSString *> *)getCustomHeaders;

/**
 设置当前的数据请求类型
 PS:这个的主要是针对实际的单个数据请求,进行重写
 针对四个主流的请求类型,默认为Get,在进行Get数据请求的时候,不需要进行重写
 */
- (TTRequestType)getRequestMethod;

/**
 请求参数
 这里可以看做是当前项目中,对所有请求的参数中,需要上传的参数
 e.g.:服务器需要获取当前用户的操作网络,项目运行的系统环境等等
 针对我们在进行数据请求的过程中,实际需要上传的参数,做出的处理就是讲Base参数采用NSMutableDictionary形式,统一合并
 */
- (NSDictionary *)getDefaultParameters;

- (void)processResult;
+ (void)cancelTheRequest;
- (BOOL)success;
- (NSString *)errorMsg;
- (NSInteger)totalCount;
- (BOOL)hasMoreData;

@end
