//
//  TTBaseViewController.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UINavigationController+TTFullscreenPopGesture.h"

typedef void(^DismissBlock)();

@interface TTBaseViewController : UIViewController

/**
 导航栏标题
 */
@property (nonatomic, copy) NSString *navigationTitle;

/**
 导航栏标题的颜色
 */
@property (nonatomic, strong) UIColor *navigationTitleColor;

/**
 导航栏背景颜色
 */
@property (nonatomic, strong) UIColor *navigationBarColor;

/**
 导航栏是否隐藏
 */
@property (nonatomic, assign, getter=isHideNavigationBar) BOOL hideNavigationBar;

/**
 状态栏是否隐藏
 */
@property (nonatomic, assign, getter=isHideStatusBar) BOOL hideStatusBar;

/**
 状态栏的样式
 YES:黑色   NO:白色
 */
@property (nonatomic, assign, getter=isStatusBarStyleDefault) BOOL statusBarStyleDefault;

/**
 是否旋转
 YES:当前页面设定的orientation  NO:默认为UIInterfaceOrientationPortrait
 */
@property (nonatomic, assign, readonly, getter=isAllowRotate) BOOL allowRotate;

/**
 导航栏的颜色是否改变
 这里自定义颜色,设定一个主题基调颜色,还有备用颜色
 */
@property (nonatomic, assign, getter=isNavBarColorChange) BOOL navBarColorChange;

/**
 左侧按钮
 */
@property (nonatomic, strong) UIButton *leftBtn;

/**
 右侧按钮
 */
@property (nonatomic, strong) UIButton *rightBtn;

/**
 右侧的按钮数组
 */
@property (nonatomic, strong) NSArray<UIButton *> *rightBtns;

/**
 页面的方向
 系统给出的有UIInterfaceOrientation和UIInterfaceOrientationMask(iOS6.0+)两种,为了方便和统一,采用后者
 */
@property (nonatomic, assign) UIInterfaceOrientationMask orientation;

/**
 页面消失的代理(仅限Dismiss)
 */
@property (nonatomic, copy) DismissBlock dismissBlock;

/**
 *  Image Named
 *  Normal       : nav_back.png
 *  Highlighted  : nav_back_tap.png
 *  Size: 48 * 48
 */
- (void)showBackBtn;
- (void)onBackBtnTap:(UIButton *)sender;
/**
 * 用于处理pop、dismiss事件完成Controller
 */
//- (void)destoryHandler;

/**
 取消当前页面的数据请求
 不是所有的页面都需要调用这个方法,比如,通知点入首页数据还未请求完成,这是跳转到别的页面,首页的数据请求不需要取消
 */
- (void)cancelAllRequest;

/**
 当前页面名称

 @return <#return value description#>
 */
+ (NSString *)classStr;

@end
