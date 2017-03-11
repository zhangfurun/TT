//
//  TTBinaryData.m
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBinaryData.h"
#import "TTConst.h"

NSString * const MIMEType_TEXT  = @"text/html";
NSString * const MIMEType_Plain = @"text/plain";
NSString * const MIMEType_JPG   = @"image/jpeg";
NSString * const MIMEType_PNG   = @"image/png";
NSString * const MIMEType_WAV   = @"audio/wav";
NSString * const MIMEType_MP3   = @"audio/mp3";
NSString * const MIMEType_Audio = @"audio/mpeg";
NSString * const MIMEType_JSON  = @"application/json";
NSString * const MIMEType_MP4   = @"video/mp4";

@implementation TTBinaryData

- (instancetype)init {
    NSAssert(false, @"Plase Use Class Method -> + binWithXXX");
    return nil;
}

- (instancetype)initWithData:(NSData *)data filename:(NSString *)filename mimeType:(NSString *)mimeType{
    self = [super init];
    if (self) {
        _binaryData = data;
        _filename = filename;
        _name = [filename stringByDeletingPathExtension];
        _MIMEType = mimeType;
    }
    return self;
}

+ (instancetype)binDataWithData:(NSData *)data filenameWithExtension:(NSString *)filename mimeType:(NSString *)mimeType{
    if (STR_ISNULL_OR_EMPTY(filename)) {
        return nil;
    }
    if (STR_ISNULL_OR_EMPTY(mimeType)) {
        return nil;
    }
    if (!data) {
        return nil;
    }
    return [[self alloc] initWithData:data filename:filename mimeType:mimeType];
}

+ (instancetype)binDataWithFileURL:(NSURL *)filePath filenameWithExtension:(NSString *)filename mimeType:(NSString *)mimeType error:(NSError **)error{
    if (STR_ISNULL_OR_EMPTY(filename)) {
        *error = [NSError errorWithDomain:NSStringFromClass(self) code:-1 userInfo:@{@"error":@"参数名称不能为空!"}];
        return nil;
    }
    if (STR_ISNULL_OR_EMPTY(mimeType)) {
        *error = [NSError errorWithDomain:NSStringFromClass(self) code:-1 userInfo:@{@"error":@"文件类型不能为空!"}];
        return nil;
    }
    NSData *tempData = [NSData dataWithContentsOfURL:filePath options:NSDataReadingUncached error:error];
    if (!tempData || error) {
        return nil;
    }
    return [[self alloc] initWithData:tempData filename:filename mimeType:mimeType];
}
@end

