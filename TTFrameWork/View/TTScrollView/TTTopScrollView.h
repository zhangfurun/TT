//
//  TTTopScrollView.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TTTopScrollView : UIScrollView<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *headerNameArray;
@property (strong, nonatomic) NSMutableArray *buttonOriginXArray;
@property (strong, nonatomic) NSMutableArray *buttonWidthArray;
@property (assign, nonatomic) NSInteger userSelectedChannelID; //点击按钮选择名字ID
@property (assign, nonatomic) NSInteger scrollViewSelectedChannelID;//滑动列表选择名字ID

/**
 *  获得使用 shareInstanceWithFrame 创建的实例
 *
 *  @return 如果未使用 shareInstanceWithFrame 则返回 nil
 */
+ (instancetype)shareInstance;
+ (instancetype)shareInstanceWithFrame:(CGRect)frame;
/**
 * 加载顶部标签
 */
- (void)initWithNameButtonsWithButtonFont:(UIFont *)btnFont buttonGap:(CGFloat)btnGap;
/**
 * 滑动撤销选中按钮
 */
- (void)setButtonUnSelect;
/**
 * 滑动选择按钮
 */
- (void)setButtonSelect;
/**
 * 滑动顶部标签位置适应
 */
- (void)setScrollViewContentOffset;
@end
