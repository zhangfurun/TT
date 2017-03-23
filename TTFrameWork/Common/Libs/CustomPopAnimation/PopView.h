//
//  PopView.h
//  StoryShip
//
//  Created by 张福润 on 2017/1/22.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView
@property (nonatomic, assign, getter=isCanTouchBgCancel) BOOL canTouchBgCancel;
- (UIControl *)backgroundControl;
- (void)showInView:(UIView *)view;
- (void)cancel;
- (IBAction)onCancelBtn:(id)sender;
@end
