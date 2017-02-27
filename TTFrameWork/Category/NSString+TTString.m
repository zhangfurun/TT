//
//  NSString+TTString.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSString+TTString.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (TTString)
- (BOOL)isNilOrEmpty {
    if (!self) {
        return YES;
    }
    NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!temp || temp.length == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)md5Str {
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    };
    return [hash lowercaseString];
}

+ (NSString *)GUIDString {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    uuidObj = nil;
    return uuidString;
}

@end
