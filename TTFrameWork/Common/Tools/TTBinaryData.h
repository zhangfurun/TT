//
//  TTBinaryData.h
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

// 有关二进制文件的处理

extern NSString * const MIMEType_TEXT;
extern NSString * const MIMEType_Plain;
extern NSString * const MIMEType_JPG;
extern NSString * const MIMEType_PNG;
extern NSString * const MIMEType_WAV;
extern NSString * const MIMEType_MP3;
extern NSString * const MIMEType_Audio;
extern NSString * const MIMEType_JSON;
extern NSString * const MIMEType_MP4;

@interface TTBinaryData : NSObject
/**
 *  发送参数名称 + 扩展名
 */
@property (nonatomic, copy, readonly) NSString *filename;
@property (nonatomic, copy, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSData *binaryData;
/**
 *  发送二进制文件的 MIME-Type
 */
@property (nonatomic, copy, readonly) NSString *MIMEType;

+ (instancetype)binDataWithData:(NSData *)data filenameWithExtension:(NSString *)filename mimeType:(NSString *)mimeType;
+ (instancetype)binDataWithFileURL:(NSURL *)filePath filenameWithExtension:(NSString *)filename mimeType:(NSString *)mimeType error:(NSError **)error;
@end
