//
//  NSFileManager+TTFileManager.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (TTFileManager)
+ (BOOL)isDirectoryExist:(NSString *)path;
+ (BOOL)isFileExistAtPath:(NSString *)path;
+ (BOOL)isEmptyFolderWithPath:(NSString *)path error:(NSError **)error;
+ (BOOL)deleteFileAtPath:(NSString *)path isDirectory:(BOOL)isDir;
+ (BOOL)createDirectorysAtPath:(NSString *)path;
/**
 * 获得文件夹大小
 */
+ (long long)folderSizeAtPath:(NSString*)folderPath;
/**
 * 获得单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;
/**
 * 转换大小单位
 */
+ (NSString *)sizeFormatByteCount:(long long)size;
@end
