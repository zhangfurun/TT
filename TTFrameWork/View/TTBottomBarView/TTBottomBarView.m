//
//  TTBottomBarView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTBottomBarView.h"
#import "UIView+TTSuperView.h"

static NSTimeInterval duration = 0.25;

@interface TTBottomBarView () {
    UIControl *_bgControl;
    UIView *_inView;
}
@end

@implementation TTBottomBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgControl = [[UIControl alloc] init];
    _bgControl.backgroundColor = [UIColor blackColor];
    [_bgControl addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:self.bounds];
    [toolBar setAutoresizeMaskAll];
    [self insertSubview:toolBar atIndex:0];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Method
- (void)showInWindow {
    [self showInView:[UIView keyWindow]];
}

- (void)showInView:(UIView *)aView {
    _inView = aView;
    
    _bgControl.frame = aView.bounds;
    [aView addSubview:_bgControl];
    self.width = aView.width;
    [aView addSubview:self];
    
    self.top = aView.height;
    _bgControl.alpha = 0;
    
    [UIView animateWithDuration:duration animations:^{
        _bgControl.alpha = 0.2;
        self.bottom = aView.height;
        _bgControl.bottom = self.top;
    }];
}

- (void)cancel {
    [UIView animateWithDuration:duration animations:^{
        self.top = _inView.height;
        _bgControl.bottom = self.top;
        _bgControl.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_bgControl removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

@end

