//
//  UIAlertView+MyAlertView.m
//  StoryShip
//
//  Created by 张福润 on 2017/3/7.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "UIAlertView+MyAlertView.h"

#import <objc/message.h>

#import "AlertViewRecorder.h"

@implementation UIAlertView (MyAlertView)

+ (void)load
{
    // 获取将要交换的两个方法
    Method showMethod = class_getInstanceMethod(self, @selector(show));
    Method myShowMethod = class_getInstanceMethod(self, @selector(myShow));
    // 将两个方法互换
    method_exchangeImplementations(showMethod, myShowMethod);
    
}

- (void)myShow
{
    // 将之前所有的alertView取出来消失掉
    NSMutableArray *array =  [AlertViewRecorder shareAlertViewRecorder].alertViewArray;
    for (UIAlertView *alertView in array) {
        if ([alertView isKindOfClass:[UIAlertView class]]) {
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
        }
    }
    
    [array removeAllObjects];
    // 调用自身的方法
    [self myShow];
    [array addObject:self];
}

@end

