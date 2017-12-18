//
//  UIImagePickerController+TTPadLandscape.m
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "UIImagePickerController+TTPadLandscape.h"

#import "TTConst.h"

@implementation UIImagePickerController (TTPadLandscape)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (ISIPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return [super supportedInterfaceOrientations];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (ISIPAD) {
        return UIStatusBarStyleLightContent;
    }else {
        return [super preferredStatusBarStyle];
    }
}

- (BOOL)prefersStatusBarHidden {
    if (ISIPAD) {
        return YES;
    }else {
        return NO;
    }
}
@end
