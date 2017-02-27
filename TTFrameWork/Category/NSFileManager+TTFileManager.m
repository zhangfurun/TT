//
//  NSFileManager+TTFileManager.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSFileManager+TTFileManager.h"

@implementation NSFileManager (TTFileManager)

+ (BOOL)isDirectoryExist:(NSString *)path {
    BOOL isDirectory;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isExist && isDirectory;
}

+ (BOOL)isFileExistAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)isEmptyFolderWithPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:error];
    if (contents && contents.count > 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)deleteFileAtPath:(NSString *)path isDirectory:(BOOL)isDir {
    if (isDir) {
        if (![self isDirectoryExist:path]) {
            return YES;
        }
    } else {
        if (![self isFileExistAtPath:path]) {
            return YES;
        }
    }
    NSError *error;
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    return isSuccess;
}

+ (BOOL)createDirectorysAtPath:(NSString *)path {
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 * 获得文件夹大小
 */
+ (long long)folderSizeAtPath:(NSString*)folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

/**
 * 获得单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString*)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 * 转换大小单位
 */
+ (NSString *)sizeFormatByteCount:(long long)size {
    if (size == 0) {
        return @"0.00M";
    }
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}


@end
