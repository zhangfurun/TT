//
//  TTBottomBarView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 一个底部的View,一般用于底部的评论等等
 建议:frame的设置为CGRectMake(0, KEY_WINDOW.height - 44, KEY_WINDOW.width, 44)
 */
@interface TTBottomBarView : UIView
- (void)showInWindow;
- (void)showInView:(UIView *)aView;

- (void)cancel;
@end
