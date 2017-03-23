//
//  TTScrollView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTScrollView.h"

@implementation TTScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}
@end
