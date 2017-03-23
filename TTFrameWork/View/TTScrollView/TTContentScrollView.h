//
//  TTContentScrollView.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTContentScrollView;

@protocol TTContentScrollViewDelegate <NSObject>
- (void)TTcontentScrollView:(TTContentScrollView *)TTcontentView didScrollToView:(UIView *)view;
@end

@interface TTContentScrollView : UIScrollView<UIScrollViewDelegate>
@property (weak, nonatomic) id<TTContentScrollViewDelegate> contentScrollViewDelegate;
@property (assign, nonatomic) CGFloat contentPageWidth;
@property (strong, nonatomic) NSArray *subViewArray;
@property (assign, nonatomic) CGFloat userContentOffsetX;
@property (assign, nonatomic, readonly, getter=isLeftScroll) BOOL leftScroll;

/**
 *  获得使用 shareInstanceWithFrame 创建的实例
 *
 *  @return 如果未使用 shareInstanceWithFrame 则返回 nil
 */
+ (instancetype)shareInstance;
+ (instancetype)shareInstanceWithFrame:(CGRect)frame;

- (void)layoutWithSubviews;
- (void)loadData;
- (void)releaseSubviews;
@end

