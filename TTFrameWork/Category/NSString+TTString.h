//
//  NSString+TTString.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TTString)
- (BOOL)isNilOrEmpty; // 字符串判空
- (NSString *)md5Str; // md5加密
+ (NSString *)GUIDString; //
@end
