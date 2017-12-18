//
//  UIImage+TTResize.h
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TTResize)

/**
 *  返回一张自由拉伸的图片(默认拉伸中心区域)
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 *
 *  @param name 图片名
 *  @param left 拉伸区域左边距
 *  @param top  拉伸区域上边距
 *
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/**
 *  改变图片像素
 *
 *  @param size 缩放尺寸
 *  @param name 图片名字
 *
 *  @return 缩放后的图片
 */
+ (UIImage*)scaleToSize:(CGSize)size withImageName:(NSString *)name;

/**
 *  裁剪图片
 *
 *  @param icon   图片名称
 *  @param border 边框大小
 *  @param color  边框的颜色
 *
 *  @return 裁剪后的图片
 */
+ (instancetype)imageWithIcon:(NSString *)icon border:(NSInteger)border color:(UIColor *)color;

/**
 *  等比缩放
 *
 *  @param image 原图
 *  @param size  缩放后的尺寸
 *
 *  @return 缩放后的图片
 */
+ (UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;


/**
 *  抗锯齿,设置边缘一像素透明框(系统提供方法:layer.allowsEdgeAntialiasing = true)
 */
- (UIImage *)antiAlias;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
