//
//  UIWindow+TTWindow.m
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "UIWindow+TTWindow.h"

@implementation UIWindow (TTWindow)
+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)result;
        result = navVC.visibleViewController;
    } else if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)result;
        result = tabBarVC.selectedViewController;
    }
    return result;
}

+ (BOOL)deleteViewControllerFromNavigationController:(UINavigationController *)navigationController deleteViewController:(UIViewController *)viewController {
    for (UIViewController *VC in navigationController.viewControllers) {
        if ([VC isKindOfClass:[viewController class]]) {
            [VC removeFromParentViewController];
            return YES;
        }
    }
    return NO;
}
@end
