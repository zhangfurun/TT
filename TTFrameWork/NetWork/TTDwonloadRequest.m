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

#import <objc/runtime.h>

static NSString *TTDownloadErrorDomain = @"TTDownloadErrorDomain";
NSString * const TTDownloadErrorReasonKey = @"TTDownloadErrorReasonKey";
NSString * const TTDownloadDoDownloadBlockKey = @"TTDownloadDoDownloadBlockKey";
NSString * const TTDownloadAllowUseMobileNetworkKey = @"TTDownloadAllowUseMobileNetworkKey";
NSString * const TTDownloadAllowUseMobileNetworkNotification = @"TTDownloadAllowUseMobileNetworkNotification";

typedef void(^DownloadProgressBlock)(NSProgress * _Nonnull downloadProgress);
typedef NSURL * (^DownloadDestinationBlock)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);
typedef void(^DownloadCompletionBlock)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);

typedef enum : NSUInteger {
    TTDownloadTaskStatus_None,
    TTDownloadTaskStatus_Downloading,
    TTDownloadTaskStatus_Pause,
    TTDownloadTaskStatus_Cancel,
    TTDownloadTaskStatus_Finish,
} TTDownloadTaskStatus;

@interface TTDownloadRequest () {
    SuccessBlock    _successBlock;
    CancelBlock     _cancelBlock;
    FailureBlock    _failureBlock;
    ProgressBlock   _progressBlock;
    NSString        *_urlString;
    NSString        *_downloadPath;
    NSString        *_fileName;
    NSString        *_filePath;
    CGFloat         _progress;
    BOOL            _isUseAllNetDownload;
}

@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) TTDownloadTaskStatus taskStatus;
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
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        
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
- (NSString *)downloadPath {
    return _downloadPath;
}

- (NSString *)fileName {
    return _fileName;
}

- (NSString *)filePath {
    return _filePath;
}

- (NSString *)urlString {
    return _urlString;
}

- (CGFloat)progress {
    return _progress;
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
   NSString *url = self.urlString;
    
    
    __block typeof(self) WS = self;
    DownloadProgressBlock progressBlock = ^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        if (WS->_progressBlock) {
            float downloadMB = (downloadProgress.completedUnitCount) / 1024.f / 1024.0f;
            float totalMB = (downloadProgress.totalUnitCount) / 1024.f / 1024.0f;
            float progress = (1.f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            _progress = progress;
            NSLog(@"==> %lf", progress);
            dispatch_sync(dispatch_get_main_queue(), ^{
                WS->_progressBlock(progress, downloadMB, totalMB);
            });
        }
    };
    
    
    DownloadDestinationBlock destinationBlock = ^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:_filePath];
    };
    
    DownloadCompletionBlock completionBlock = ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            
            if (error.code == -999 || error.code == -1001) {
                // 取消请求 或者 请求超时, 如果处于暂停状态, 不做处理
                if (WS.taskStatus == TTDownloadTaskStatus_Pause) {
                    return;
                }
            }
            
            NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
            [self saveResumeData:resumeData withUrl:response.URL.absoluteString];
            // 下载失败
            
            WS.taskStatus = TTDownloadTaskStatus_None;
            if (WS.taskStatus == TTDownloadTaskStatus_Cancel) {
                if (WS->_cancelBlock) {
                    WS->_cancelBlock(WS);
                }
            } else {
                if (WS->_failureBlock) {
                    WS->_failureBlock(WS, error);
                }
            }
        } else {
            // 下载成功
            WS.taskStatus = TTDownloadTaskStatus_Finish;
            [self removeResumeInfoWithUrl:response.URL.absoluteString];
            [self removeTempFileInfoWithUrl:response.URL.absoluteString];
            if (WS->_successBlock) {
                WS->_successBlock(WS);
            }
        }
    };
    
    // 参数
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //下载请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 60000;
    configuration.timeoutIntervalForResource = 60000;

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    self.sessionManager = manager;
    
    // 1. 生成任务
    NSData *resumeData = [self getResumeDataWithUrl:url];
    
    if (resumeData) {
        // 1.1 有断点信息，走断点下载
        self.downloadTask = [manager downloadTaskWithResumeData:resumeData
                                                       progress:progressBlock
                                                    destination:destinationBlock
                                              completionHandler:completionBlock];
        // 删除历史恢复信息，重新下载后该信息内容已不正确，不使用，
        [self removeResumeInfoWithUrl:url];
    } else {
        // 1.2 普通下载
        self.downloadTask = [manager downloadTaskWithRequest:request
                                                    progress:progressBlock
                                                 destination:destinationBlock
                                           completionHandler:completionBlock];
        
        // 1.3 保存临时文件名
        NSString *tempFileName = [self getTempFileNameWithDownloadTask:self.downloadTask];
        [self saveTempFileName:tempFileName withUrl:url];
    }

    [self.downloadTask resume];
}

+ (void)pauseWithDownloadRequest:(TTDownloadRequest *)downloadRequest {
    [downloadRequest pauseDownload];
}

+ (void)resumeWithDownloadRequest:(TTDownloadRequest *)downloadRequest {
    [downloadRequest resumeDownload];
}

- (void)pauseDownload {
    __weak typeof(self) WS = self;
    WS.taskStatus = TTDownloadTaskStatus_Pause;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [WS saveResumeData:resumeData withUrl:WS.downloadTask.currentRequest.URL.absoluteString];
    }];
}

- (void)resumeDownload {
    [self doDownloadWithPath:_downloadPath fileName:_fileName];
}

- (void)cancelDownload {
    __weak typeof(self) WS = self;
    self.taskStatus = TTDownloadTaskStatus_Cancel;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [WS saveResumeData:resumeData withUrl:WS.downloadTask.currentRequest.URL.absoluteString];
    }];
}

// 取消
- (void)cancleDownloadTask {
   
}


- (BOOL)isDownloading {
    return self.downloadTask && self.downloadTask.state == NSURLSessionTaskStateRunning;
}

- (BOOL)finished {
    return self.downloadTask && self.downloadTask.state == NSURLSessionTaskStateCompleted;
}

+ (void)removeAllCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


#pragma mark - tempFile

/// 获取临时文件名
- (NSString *)getTempFileNameWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    //NSURLSessionDownloadTask --> 属性downloadFile：__NSCFLocalDownloadFile --> 属性path
    NSString *tempFileName = nil;
    
    // downloadTask的属性(NSURLSessionDownloadTask) dt
    unsigned int dtpCount;
    objc_property_t *dtps = class_copyPropertyList([downloadTask class], &dtpCount);
    for (int i = 0; i<dtpCount; i++) {
        objc_property_t dtp = dtps[i];
        const char *dtpc = property_getName(dtp);
        NSString *dtpName = [NSString stringWithUTF8String:dtpc];
        
        // downloadFile的属性(__NSCFLocalDownloadFile) df
        if ([dtpName isEqualToString:@"downloadFile"]) {
            id downloadFile = [downloadTask valueForKey:dtpName];
            unsigned int dfpCount;
            objc_property_t *dfps = class_copyPropertyList([downloadFile class], &dfpCount);
            for (int i = 0; i<dfpCount; i++) {
                objc_property_t dfp = dfps[i];
                const char *dfpc = property_getName(dfp);
                NSString *dfpName = [NSString stringWithUTF8String:dfpc];
                // 下载文件的临时地址
                if ([dfpName isEqualToString:@"path"]) {
                    id pathValue = [downloadFile valueForKey:dfpName];
                    NSString *tempPath = [NSString stringWithFormat:@"%@",pathValue];
                    tempFileName = tempPath.lastPathComponent;
                    break;
                }
            }
            free(dfps);
            break;
        }
    }
    free(dtps);
    
    return tempFileName;
}

/// 保存临时文件名
- (void)saveTempFileName:(NSString *)name withUrl:(NSString *)url {
    if (url.length < 1 || name.length < 1) {
        return;
    }
    
    NSString *mapPath = [self tempFileMapPath];
    NSMutableDictionary *tempFileMap = [NSMutableDictionary dictionaryWithContentsOfFile:mapPath];
    if([tempFileMap[url] length] > 0){
        [[NSFileManager defaultManager] removeItemAtPath:[self tempFilePathWithName:tempFileMap[url]] error:nil];
    }
    if (!tempFileMap) {
        tempFileMap = [NSMutableDictionary dictionary];
    }
    tempFileMap[url] = name;
    [tempFileMap writeToFile:mapPath atomically:YES];
}

/// 移除临时文件相关信息
- (void)removeTempFileInfoWithUrl:(NSString *)url {
    if (url.length < 1) {
        return;
    }
    
    NSString *mapPath = [self tempFileMapPath];
    NSMutableDictionary *tempFileMap = [NSMutableDictionary dictionaryWithContentsOfFile:mapPath];
    if([tempFileMap[url] length] > 0){
        [[NSFileManager defaultManager] removeItemAtPath:[self tempFilePathWithName:tempFileMap[url]] error:nil];
        [tempFileMap removeObjectForKey:url];
        [tempFileMap writeToFile:mapPath atomically:YES];
    }
}

/// 手动创建resume信息
- (NSData *)createResumeDataWithUrl:(NSString *)url {
    if (url.length < 1) {
        return nil;
    }
    
    // 1. 从map文件中获取resumeData的name
    NSMutableDictionary *resumeMap = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    NSString *resumeDataName = resumeMap[url];
    if (resumeDataName.length < 1) {
        resumeDataName = [self getRandomResumeDataName];
        resumeMap[url] = resumeDataName;
        [resumeMap writeToFile:[self resumeDataMapPath] atomically:YES];
    }
    
    // 2. 获取data
    NSString *resumeDataPath = [self resumeDataPathWithName:resumeDataName];
    NSDictionary *tempFileMap = [NSDictionary dictionaryWithContentsOfFile:[self tempFileMapPath]];
    NSString *tempFileName = tempFileMap[url];
    if (tempFileName.length > 0) {
        NSString *tempFilePath = [self tempFilePathWithName:tempFileName];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:tempFilePath]) {
            // 获取文件大小
            NSDictionary *tempFileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:tempFilePath error:nil ];
            unsigned long long fileSize = [tempFileAttr[NSFileSize] unsignedLongLongValue];
            
            // 手动建一个resumeData
            NSMutableDictionary *fakeResumeData = [NSMutableDictionary dictionary];
            fakeResumeData[@"NSURLSessionDownloadURL"] = url;
            // ios8、与>ios9方式稍有不同
            if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0) {
                fakeResumeData[@"NSURLSessionResumeInfoTempFileName"] = tempFileName;
            } else {
                fakeResumeData[@"NSURLSessionResumeInfoLocalPath"] = tempFilePath;
            }
            fakeResumeData[@"NSURLSessionResumeBytesReceived"] = @(fileSize);
            [fakeResumeData writeToFile:resumeDataPath atomically:YES];
            
            // 重新加载信息
            return [NSData dataWithContentsOfFile:resumeDataPath];
        }
    }
    return nil;
}
#pragma mark - resumeData
- (NSString *)getRandomResumeDataName{
    return [NSString stringWithFormat:@"ResumeData_%@.dat",[NSUUID UUID].UUIDString];
}

- (NSString *)saveResumeData:(NSData *)resumeData withUrl:(NSString *)url{
    if (resumeData.length < 1 || url.length < 1) {
        return nil;
    }
    
    // 1. 用一个map文件记录resumeData的位置
    NSString *resumeDataName = [self getRandomResumeDataName];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    if (!map) {
        map = [NSMutableDictionary dictionary];
    }
    // 删除旧的resumeData
    if (map[url]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self resumeDataPathWithName:map[url]] error:nil];
    }
    // 更新resumeInfo
    map[url] = resumeDataName;
    [map writeToFile:[self resumeDataMapPath] atomically:YES];
    
    // 2. 存储resumeData
    NSString *resumeDataPath = [self resumeDataPathWithName:resumeDataName];
    [resumeData writeToFile:resumeDataPath atomically:YES];
    
    return resumeDataName;
}

/// 获取恢复文件，文件不存在尝试手动建一个
- (NSData *)getResumeDataWithUrl:(NSString *)url {
    if (url.length < 1) {
        return nil;
    }
    
    // 1. 从map文件中获取resumeData的name
    NSMutableDictionary *resumeMap = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    NSString *resumeDataName = resumeMap[url];
    
    // 2. 获取data
    NSData *resumeData = nil;
    NSString *resumeDataPath = [self resumeDataPathWithName:resumeDataName];
    if (resumeDataName.length > 0) {
        resumeData = [NSData dataWithContentsOfFile:resumeDataPath];
    }
    
    // 3. 如果没有data，找到临时文件，尝试自己建一个
    if (!resumeData) {
        resumeData = [self createResumeDataWithUrl:url];
    }
    
    return resumeData;
}

/// 删除恢复文件信息
- (void)removeResumeInfoWithUrl:(NSString *)url {
    
    // 1. 从map文件中获取resumeData的name
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithContentsOfFile:[self resumeDataMapPath]];
    NSString *resumeDataName = map[url];
    
    if (resumeDataName) {
        // 2. 删除记录
        [map removeObjectForKey:url];
        [map writeToFile:[self resumeDataMapPath] atomically:YES];
        
        // 3. 删除resumeData
        NSString *resumeDataPath = [self resumeDataPathWithName:resumeDataName];
        [[NSFileManager defaultManager] removeItemAtPath:resumeDataPath error:nil];
    }
}

#pragma mark - 路径

/// 记录resumeData位置的map文件
- (NSString *)resumeDataMapPath {
    // key: url  value: resumeDataName
    return [[self downloadTempFilePath] stringByAppendingPathComponent:@"ResumeDataMap.plist"];
}

/// resumeData的路径
- (NSString *)resumeDataPathWithName:(NSString *)fileName {
    return [[self downloadTempFilePath] stringByAppendingPathComponent:fileName];
}

/// 记录tempFile位置的map文件
- (NSString *)tempFileMapPath {
    // key: url  value: tempFileName
    return [[self downloadTempFilePath] stringByAppendingPathComponent:@"TempFileMap.plist"];
}

/// 临时文件路径
- (NSString *)tempFilePathWithName:(NSString *)fileName {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}

/// 记录下载信息的文件夹
- (NSString *)downloadTempFilePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"DownloadTempFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end


