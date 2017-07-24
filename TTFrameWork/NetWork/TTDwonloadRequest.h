//
//  TTDwonloadRequest.h
//  TT
//
//  Created by zhangfurun on 2017/7/24.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TTDownloadErrorReasonKey;
extern NSString * const TTDownloadDoDownloadBlockKey;
extern NSString * const TTDownloadAllowUseMobileNetworkKey;
extern NSString * const TTDownloadAllowUseMobileNetworkNotification;

@class TTDownloadRequest;

typedef void(^ProgressBlock)(float progress, NSUInteger bytesRead, unsigned long long totalRead, unsigned long long totalExpectedToRead);
typedef void(^SuccessBlock)(TTDownloadRequest *request, id responseObject);
typedef void(^CancelBlock)(TTDownloadRequest *request);
typedef void(^FailureBlock)(TTDownloadRequest *request, NSError *error);

@interface TTDownloadRequest : NSObject

@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

/**
 * 下载路径(文件夹)
 */
@property (nonatomic, strong, readonly) NSString *downloadPath;
@property (nonatomic, strong, readonly) NSString *fileName;
/**
 * 下载文件绝对路径
 */
@property (nonatomic, strong, readonly) NSString *filePath;

/**
 *  下载文件
 *
 *  @param URLStirng     文件链接
 *  @param fileName      文件名
 *  @param progressBlock 下载进度回调
 *  @param successBlock  下载成功回调
 *  @param failureBlock  下载失败回调
 *
 *  @return 下载任务
 */
+ (TTDownloadRequest *)downloadFileWithURLString:(NSString *)URLStirng
                                        fileName:(NSString *)fileName
                                   progressBlock:(ProgressBlock)progressBlock
                                    successBlock:(SuccessBlock)successBlock
                                     cancelBlock:(CancelBlock)cancelBlock
                                    failureBlock:(FailureBlock)failureBlock;
/**
 *  下载文件
 *
 *  @param URLStirng     文件链接
 *  @param fileName      文件名
 *  @param downloadPath  下载位置
 *  @param progressBlock 下载进度回调
 *  @param successBlock  下载成功回调
 *  @param failureBlock  下载失败回调
 *
 *  @return 下载任务
 */
+ (TTDownloadRequest *)downloadFileWithURLString:(NSString *)URLStirng
                                    downloadPath:(NSString *)downloadPath
                                        fileName:(NSString *)fileName
                                   progressBlock:(ProgressBlock)progressBlock
                                    successBlock:(SuccessBlock)successBlock
                                     cancelBlock:(CancelBlock)cancelBlock
                                    failureBlock:(FailureBlock)failureBlock;

/**
 *  暂停下载文件
 *
 *  @param downloadRequest 下载任务
 */
+ (void)pauseWithDownloadRequest:(TTDownloadRequest *)downloadRequest;

/**
 *  恢复下载文件
 *
 *  @param downloadRequest 下载请求
 */
+ (void)resumeWithDownloadRequest:(TTDownloadRequest *)downloadRequest;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;
- (void)pauseDownload;
- (void)resumeDownload;
- (void)cancelDownload;
- (BOOL)isDownloading;
- (BOOL)finished;
+ (void)removeAllCache;
@end
