//
//  NSFileManager+TTFileManager.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (TTFileManager)

/**
 判断是不是文件夹

 @param path 判断对象的路径
 */
+ (BOOL)isDirectoryExist:(NSString *)path;

/**
 判断文件夹是不是存在

 @param path 判断对象的路径
 */
+ (BOOL)isFileExistAtPath:(NSString *)path;

/**
 判断文件夹内是否有内容

 @param path 文件夹的李靖
 @param error 错误信息指针
 */
+ (BOOL)isEmptyFolderWithPath:(NSString *)path error:(NSError **)error;

/**
 删除文件

 @param path 需要删除文件的路径
 @param isDir 判断是文件还是为文件夹  YES:文件夹  NO:单个文件
 */
+ (BOOL)deleteFileAtPath:(NSString *)path isDirectory:(BOOL)isDir;

/**
 创建文件夹

 @param path 创建文件夹的路径   
 */
+ (BOOL)createDirectorysAtPath:(NSString *)path;

/**
 获取文件大小

 @param folderPath 文件夹path
 */
+ (long long)folderSizeAtPath:(NSString*)folderPath;

/**
  获得单个文件大小

 @param filePath 单个文件的path
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;

/**
 转换大小单位

 @param size 文件的大小
 */
+ (NSString *)sizeFormatByteCount:(long long)size;
@end
