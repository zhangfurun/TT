//
//  TTAliyunOSSManager.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSSObjectModel;

#define COMMON_BLOCK progressBlock:(OSSMProgressUploadBlock)progressBlock completedBlock:(OSSMCompletedBlock)completedBlock

typedef void(^OSSMCompletedBlock)(BOOL isSuccess, NSError *error);
typedef void(^OSSMProgressUploadBlock)(OSSObjectModel *ossObj, int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend);

extern NSString * const ALIYUN_OSSMANAGER_UPLOAD_COMPLETED_ERROR_KEY;

typedef enum : NSUInteger {
    OSSObjectTypeBinary,
    OSSObjectTypeFileUrl
} OSSObjectType;

@interface TTAliyunOSSManager : NSObject
@property (nonatomic, copy, readonly) NSArray<OSSObjectModel *> *allUploadModels;
@property (nonatomic, assign, readonly, getter=isAllCompleted) BOOL allCompleted;
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

- (void)uploadFileWithOSSObject:(OSSObjectModel *)ossObjModel COMMON_BLOCK;
- (void)uploadFileWithOSSObjects:(NSArray<OSSObjectModel *> *)ossObjs COMMON_BLOCK;
@end

@interface OSSObjectModel : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSData *objData;
@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, assign) OSSObjectType objType;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, assign, getter=isUploadCompleted) BOOL uploadCompleted;
@end

