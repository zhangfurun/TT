//
//  TTTextView.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTextView : UITextView

/**
 占位字符
 */
@property (copy, nonatomic) NSString *placeHolerText;

/**
 占位字符的颜色
 */
@property (strong, nonatomic) UIColor *placeHolerTextColor;
@end
