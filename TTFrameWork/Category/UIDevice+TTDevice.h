//
//  UIDevice+TTDevice.h
//  TT
//
//  Created by 张福润 on 2017/2/27.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TTDevice)
+ (NSString *)osVersion;
+ (NSString *)model;
+ (BOOL)supportIphone;
+ (NSString *)iphoneType;
+ (BOOL)isPad;
@end
