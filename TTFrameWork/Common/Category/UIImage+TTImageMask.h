//
//  UIImage+TTImageMask.h
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TTImageMask)

/**
 给图片添加信息,类似的新浪微博的图片的作者名称
 */
+ (UIImage *)imageAddTitleWithSubtitle:(NSString *)title
                            attributes:(NSDictionary *)attributes
                             withImage:(UIImage *)image
                                InRect:(CGRect)rect;

/**
 图片添加水印

 @param maskImage 添加水印的图片
 @param rect 添加水印的frame
 */
- (UIImage *)imageWithWaterMaskImage:(UIImage*)maskImage inRect:(CGRect)rect;

/**
 获取系统的icon
 */
+ (UIImage *)getAppIconLogo;
@end
