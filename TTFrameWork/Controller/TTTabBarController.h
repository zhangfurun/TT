//
//  TTTabBarController.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTabBarController : UITabBarController

@end


@interface TTTabBarView : UIToolbar

/**
 创建TTTabBarView
 */
+ (instancetype)createTabBarView;

/**
 获取当前的TabBarView
 */
+ (instancetype)getTabBarView;

/**
 通过Index选择TabBar对应的Controller
 */
+ (void)selectedIndex:(NSInteger)idx;

/**
 设置相对应的点击事件
 */
- (IBAction)onButtonTouched:(id)sender;//tag:0,1,2....

/**
 获取当前的TTTabBarController
 */
- (TTTabBarController *)tabBarController;

/**
 获取当前选择的Controller
 */
- (UINavigationController *)currentNavigationController;

#pragma mark - SubClass
- (NSArray<Class> *)getViewControllersClass;
@end
