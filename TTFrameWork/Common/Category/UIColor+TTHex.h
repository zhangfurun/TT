//
//  UIColor+TTHex.h
//  StoryShip
//
//  Created by 张福润 on 2017/4/7.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 设置颜色通过NSString类型,从十六进制字符串获取颜色
 
 PS:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 
 */
@interface UIColor (TTHex)

/**
 通过十六进制字符串设置颜色

 @param color Color的十六进制字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


/**
 通过十六进制字符串设置透明度的颜色

 @param color Color的十六进制字符串
 @param alpha 透明度  0~1
 @return 透明度颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
