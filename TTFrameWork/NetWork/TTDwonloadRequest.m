//
//  TTDwonloadRequest.m
//  TT
//
//  Created by zhangfurun on 2017/7/24.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTDwonloadRequest.h"

#import "TTBaseRequest.h"
#import "TTBaseReqCommon.h"

#import "TTConst.h"

#import "AFNetworking.h"

#import "NSFileManager+TTFileManager.h"
#import "NSUserDefaults+TTUserDefaults.h"

static NSString *TTDownloadErrorDomain = @"TTDownloadErrorDomain";
NSString * const TTDownloadErrorReasonKey = @"TTDownloadErrorReasonKey";
NSString * const TTDownloadDoDownloadBlockKey = @"TTDownloadDoDownloadBlockKey";
NSString * const TTDownloadAllowUseMobileNetworkKey = @"TTDownloadAllowUseMobileNetworkKey";
NSString * const TTDownloadAllowUseMobileNetworkNotification = @"TTDownloadAllowUseMobileNetworkNotification";

static NSString *TTOperationKey = @"operation";
static NSString *TTPathKey = @"path";

@interface TTDownloadRequest () {
    SuccessBlock    _successBlock;
    CancelBlock     _cancelBlock;
    FailureBlock    _failureBlock;
    ProgressBlock   _progressBlock;
    NSString        *_urlString;
    NSString        *_downloadPath;
    NSString        *_fileName;
    NSString        *_filePath;
    NSHTTPURLResponse *_response;
}
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, assign, getter=isCancelDownload) BOOL cancelDownload;
@end

@implementation TTDownloadRequest

#pragma mark - Lifycycle
- (instancetype)initWithUrlString:(NSString *)urlString
                     downloadPath:(NSString *)downloadPath
                         fileName:(NSString *)fileName
                    progressBlock:(ProgressBlock)progressBlock
                     successBlock:(SuccessBlock)successBlock
                      cancelBlock:(CancelBlock)cancelBlock
                     failureBlock:(FailureBlock)failureBlock {
    self = [super init];
    if (self) {
        _progressBlock  = progressBlock;
        _successBlock   = successBlock;
        _cancelBlock    = cancelBlock;
        _failureBlock   = failureBlock;
        _urlString = urlString;
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlReqeust = [NSURLRequest requestWithURL:url];
        _operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlReqeust];
        
        downloadPath = downloadPath ?: kCachePath;
        _downloadPath = downloadPath;
        _fileName = fileName;
        _filePath = [downloadPath stringByAppendingPathComponent:fileName];
        
        BOOL isWIFI = [TTBaseRequest fetchReachabilityStatus] == TTNetworkReachabilityStatusReachableViaWiFi;
        BOOL isAllowUseMobileNetwork = [NSUserDefaults boolValueForKey:TTDownloadAllowUseMobileNetworkKey];
        if (isWIFI) {
            [self doDownloadWithPath:_downloadPath fileName:_fileName];
        } else if (isAllowUseMobileNetwork) {
            [self doDownloadWithPath:_downloadPath fileName:_fileName];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TTDownloadAllowUseMobileNetworkNotification object:nil userInfo:nil];
        }
    }
    return self;
}

#pragma mark - Property Method
- (NSMutableArray *)paths {
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (NSString *)downloadPath {
    return _downloadPath;
}

- (NSString *)fileName {
    return _fileName;
}

- (NSString *)filePath {
    return _filePath;
}

- (NSHTTPURLResponse *)response {
    return _response;
}

#pragma mark - Method
- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

+ (TTDownloadRequest *)downloadFileWithURLString:(NSString *)URLStirng
                                        fileName:(NSString *)fileName
                                   progressBlock:(ProgressBlock)progressBlock
                                    successBlock:(SuccessBlock)successBlock
                                     cancelBlock:(CancelBlock)cancelBlock
                                    failureBlock:(FailureBlock)failureBlock {
    return [self downloadFileWithURLString:URLStirng
                              downloadPath:nil
                                  fileName:fileName
                             progressBlock:progressBlock
                              successBlock:successBlock
                               cancelBlock:cancelBlock
                              failureBlock:failureBlock];
}

+ (instancetype)downloadFileWithURLString:(NSString *)URLStirng
                             downloadPath:(NSString *)downloadPath
                                 fileName:(NSString *)fileName
                            progressBlock:(ProgressBlock)progressBlock
                             successBlock:(SuccessBlock)successBlock
                              cancelBlock:(CancelBlock)cancelBlock
                             failureBlock:(FailureBlock)failureBlock {
    if (STR_ISNULL_OR_EMPTY(URLStirng)) {
        NSError *error = [NSError errorWithDomain:TTDownloadErrorDomain code:-100 userInfo:@{TTDownloadErrorReasonKey : @"下载地址不能为空"}];
        if (failureBlock) {
            failureBlock(nil,error);
        }
        return nil;
    }
    if (STR_ISNULL_OR_EMPTY(fileName)) {
        NSError *error = [NSError errorWithDomain:TTDownloadErrorDomain code:-101 userInfo:@{TTDownloadErrorReasonKey : @"文件名不能为空"}];
        if (failureBlock) {
            failureBlock(nil, error);
        }
        return nil;
    }
    return [[self alloc] initWithUrlString:URLStirng
                              downloadPath:downloadPath
                                  fileName:fileName
                             progressBlock:progressBlock
                              successBlock:successBlock
                               cancelBlock:cancelBlock
                              failureBlock:failureBlock];
}

- (void)doDownloadWithPath:(NSString *)downloadPath fileName:(NSString *)fileName {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    unsigned long long downloadedBytes = 0;
    if (![NSFileManager isDirectoryExist:downloadPath]) {
        [NSFileManager createDirectorysAtPath:downloadPath];
    } else if ([NSFileManager isFileExistAtPath:_filePath]) {
        //获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:_filePath];
        //检查文件是否已经下载了一部分
        if (downloadedBytes > 0) {
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-",downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    //下载请求
    _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //检查是否已经有该下载任务，如果有，释放掉...
    for (NSDictionary *dict in self.paths) {
        if ([_filePath isEqualToString:dict[TTPathKey]] && ![(AFHTTPRequestOperation *)dict[TTOperationKey] isPaused]) {
            
        } else {
            [(AFHTTPRequestOperation *)dict[TTOperationKey] cancel];
        }
    }
    NSDictionary *dictNew = @{TTPathKey : fileName,
                              TTOperationKey : _operation};
    [self.paths addObject:dictNew];
    //下载路径
    self.operation.outputStream = [NSOutputStream outputStreamToFileAtPath:_filePath append:YES];
    __block typeof(self) WS = self;
    //下载进度回调
    [self.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        if (WS->_progressBlock) {
            float downloadMB = (totalBytesRead + downloadedBytes) / 1024 / 1024.0f;
            float totalMB = (totalBytesExpectedToRead + downloadedBytes) / 1024 / 1024.0f;
            float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
            WS->_progressBlock(progress, downloadMB, totalMB, totalBytesExpectedToRead);
        }
    }];
    
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        WS->_response = operation.response;
        if (WS->_successBlock) {
            WS->_successBlock(WS, responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        WS->_response = operation.response;
        if (WS.isCancelDownload) {
            if (WS->_cancelBlock) {
                WS->_cancelBlock(WS);
            }
            WS.cancelDownload = NO;
        } else {
            if (WS->_failureBlock) {
                WS->_failureBlock(WS, error);
            }
        }
    }];
    [self.operation start];
}

+ (void)pauseWithDownloadRequest:(TTDownloadRequest *)downloadRequest {
    [downloadRequest pauseDownload];
}

+ (void)resumeWithDownloadRequest:(TTDownloadRequest *)downloadRequest {
    [downloadRequest resumeDownload];
}

- (void)pauseDownload {
    [self.operation pause];
}

- (void)resumeDownload {
    [self.operation resume];
}

- (void)cancelDownload {
    [_operation cancel];
    self.cancelDownload = YES;
}

- (BOOL)isDownloading {
    return [_operation isExecuting];
}

- (BOOL)finished {
    return [_operation isFinished];
}

+ (void)removeAllCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end

