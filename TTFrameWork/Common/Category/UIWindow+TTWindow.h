//
//  UIWindow+TTWindow.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (TTWindow)
/**
 获取当前显示的ViewController
 */
+ (UIViewController *)getCurrentViewController;


/**
 删除当前导航栏中的某个控制器(前提是,删除的控制器存在导航栏的内存栈中)

 @param navigationController 当前的导航栏
 @param viewController 删除的控制器
 @return 删除情况
 */
+ (BOOL)deleteViewControllerFromNavigationController:(UINavigationController *)navigationController deleteViewController:(UIViewController *)viewController;
@end
