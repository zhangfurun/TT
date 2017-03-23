//
//  TTStarView.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTStarView;

@protocol TTStarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TTStarView *)view score:(float)score;

@end

@interface TTStarView : UIView

@property (nonatomic, readonly) int numberOfStar;

@property (nonatomic, weak) id <TTStarRatingViewDelegate> delegate;

/**
 *  初始化TTStarRatingView
 *
 *  @param frame         Rectangles
 *  @param allowHalfStar 是否允许有半颗星
 *
 *  @return TTStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame allowHalfStar:(BOOL)allowHalfStar;

/**
 *  初始化TTStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TTStarRatingViewObject
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStar:(int)number allowHalfStar:(BOOL)allowHalfStar;

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate;

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end

#define kBACKGROUND_STAR @"ratingbar_bgstar.png"
#define kFOREGROUND_STAR @"ratingbar_fgstar.png"
#define kNUMBER_OF_STAR  5
