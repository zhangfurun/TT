//
//  CarouselManager.h
//  StoryShip
//
//  Created by 张福润 on 2017/3/10.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**
 具体的展示形式请参考iCarousel对应的Github的地址,选用相应的形式
 */

#import "iCarousel.h"
@interface CarouselManager : NSObject

/**
 展示轮播效果的View(容器)
 */
@property (nonatomic, strong) UIView *carouselView;

/**
 轮播数据(存档图片的地址)
 */
@property (nonatomic, strong) NSArray *dataArray;


/**
 记录实际数组中存在的个数
 说明:这个必须要设置,不然pageControl不显示
 考虑到iCarouselTypeRotary样式的圆形3D样式,需要在
 dataArray == 1 -> dataCount == 3
 dataArray == 2 -> dataCount == 4 or 6
 dataArray >= 3 -> dataCount == dataArray.count
 */
@property (assign, nonatomic) NSInteger dataCount;

/**
 设置iCarousel的类型
 默认:iCarouselTypeRotary
 */
@property (nonatomic, assign) iCarouselType type;

/**
 设置图片的类型
 默认:UIViewContentModeScaleToFill
 */
@property (nonatomic, assign) UIViewContentMode imageViewType;

/**
 设置图片的大小
 */
@property (nonatomic, assign) CGSize imageViewSize;
/** 点击事件 会返回点击的index  和 数据数组 */

/**
 轮播图的点击事件
 */
@property (nonatomic, copy) void (^clickAction)(NSInteger index, NSArray *dataArray);

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadWithFrame:(CGRect)frame;
@end
