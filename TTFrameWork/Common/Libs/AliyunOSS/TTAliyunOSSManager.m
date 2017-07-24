//
//  TTAliyunOSSManager.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTAliyunOSSManager.h"

#import "TTConst.h"
#import "TTBaseReqCommon.h"
#import "TTServerManager.h"

#import <AliyunOSSiOS/OSSService.h>

NSString * const AliyunAccessKey = @"";
NSString * const AliyunSecretKey = @"";
NSString * const AliyunEndpoint  = @"";

// 服务器
NSString * const TEST_BUCKET_NAME = @"";    // 测试
NSString * const FORMAL_BUCKET_NAME = @"";  // 正式

NSString * const ALIYUN_OSSMANAGER_UPLOAD_COMPLETED_ERROR_KEY = @"ALIYUN_OSSMANAGER_UPLOAD_COMPLETED_ERROR_KEY";

static TTAliyunOSSManager *instance = nil;

@interface TTAliyunOSSManager () {
    BOOL _cancelled;
}
@property (nonatomic, copy) NSString *bucketName;
@property (nonatomic, strong) OSSClient *client;
@property (nonatomic, copy) OSSMProgressUploadBlock progressBlock;
@property (nonatomic, copy) OSSMCompletedBlock completedBlock;
@property (nonatomic, strong) NSArray<OSSObjectModel *> *objects;
@end

@implementation TTAliyunOSSManager
#pragma mark - Property Method
- (NSString *)bucketName {
    if (STR_ISNULL_OR_EMPTY(_bucketName)) {
        switch (TTServerManager.reqServerType) {
            case TTReqServerTypeFormal:
            case TTReqServerTypeBeta:
            case TTReqServerTypeUnKnown:
            default:
                _bucketName = FORMAL_BUCKET_NAME;
                break;
            case TTReqServerTypeTest:
            case TTReqServerTypeLocal:
                _bucketName = TEST_BUCKET_NAME;
        }
    }
    return _bucketName;
}

- (OSSClient *)client {
    if (!_client) {
        id<OSSCredentialProvider> credentialPro = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKey secretKey:AliyunSecretKey];
        _client = [[OSSClient alloc] initWithEndpoint:AliyunEndpoint credentialProvider:credentialPro];
    }
    return _client;
}

- (NSArray<OSSObjectModel *> *)allUploadModels {
    return [self.objects copy];
}

- (BOOL)isAllCompleted {
    BOOL result = YES;
    for (OSSObjectModel *item in self.objects) {
        if (!item.isUploadCompleted) {
            result = NO;
            break;
        }
    }
    return result;
}

- (BOOL)isCanceled {
    return _cancelled;
}

#pragma mark - Method
- (void)uploadFileWithOSSObject:(OSSObjectModel *)ossObjModel hasError:(BOOL **)hasError {
    self.objects = [NSArray arrayWithObject:ossObjModel];
    OSSPutObjectRequest *putReq = [OSSPutObjectRequest new];
    putReq.bucketName = self.bucketName;
    putReq.objectKey = ossObjModel.fileName;
    switch (ossObjModel.objType) {
        case OSSObjectTypeBinary:
            putReq.uploadingData = ossObjModel.objData;
            break;
        case OSSObjectTypeFileUrl:
            putReq.uploadingFileURL = ossObjModel.fileUrl;
            break;
    }
    __weak typeof(self) WS = self;
    putReq.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        if (WS.progressBlock) {
            WS.progressBlock(ossObjModel, bytesSent, totalByteSent, totalBytesExpectedToSend);
        }
    };
    
    BOOL defaultResult = NO;
    __block BOOL *result = hasError == nil ? &defaultResult : *hasError;
    OSSTask *putTask = [self.client putObject:putReq];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            ossObjModel.uploadCompleted = YES;
            if (WS.completedBlock) {
                WS.completedBlock(YES, nil);
            }
        } else {
            _cancelled = YES;
            *result = YES;
            if (WS.completedBlock) {
                NSError *error = [NSError errorWithDomain:@"AliyunOSSManager" code:task.error.code userInfo:@{ALIYUN_OSSMANAGER_UPLOAD_COMPLETED_ERROR_KEY: task.error.localizedDescription}];
                WS.completedBlock(NO, error);
            }
        }
        return nil;
    }];
}

- (void)uploadFileWithOSSObject:(OSSObjectModel *)ossObjModel progressBlock:(OSSMProgressUploadBlock)progressBlock completedBlock:(OSSMCompletedBlock)completedBlock {
    self.progressBlock = progressBlock;
    self.completedBlock = completedBlock;
    [self uploadFileWithOSSObject:ossObjModel hasError:nil];
}

- (void)uploadFileWithOSSObjects:(NSArray<OSSObjectModel *> *)ossObjs progressBlock:(OSSMProgressUploadBlock)progressBlock completedBlock:(OSSMCompletedBlock)completedBlock {
    self.progressBlock = progressBlock;
    self.completedBlock = completedBlock;
    self.objects = ossObjs;
    __weak typeof(self) WS = self;
    [ossObjs enumerateObjectsUsingBlock:^(OSSObjectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.isCancelled || *stop) {
            return;
        }
        [WS uploadFileWithOSSObject:obj hasError:&stop];
    }];
}

@end

@implementation OSSObjectModel

- (id)copy {
    OSSObjectModel *ossObj = [OSSObjectModel new];
    ossObj.fileName = [self.fileName copy];
    ossObj.objData = [self.objData copy];
    ossObj.fileUrl = [self.fileUrl copy];
    ossObj.objType = self.objType;
    ossObj.tag = [self.tag copy];
    ossObj.uploadCompleted = self.uploadCompleted;
    return ossObj;
}

@end
