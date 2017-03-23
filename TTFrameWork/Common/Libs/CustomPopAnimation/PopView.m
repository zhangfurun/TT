//
//  PopView.m
//  StoryShip
//
//  Created by 张福润 on 2017/1/22.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import "PopView.h"

#import "TTConst.h"

#import "UIView+TTSuperView.h"

@interface PopView()<CAAnimationDelegate>
{
    UIControl *_bgControl;
    UIView *_inView;
}
@end
@implementation PopView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    _bgControl = [[UIControl alloc] init];
    _bgControl.alpha = 0;
    _bgControl.frame = KEY_WINDOW.bounds;
    _bgControl.backgroundColor = [UIColor blackColor];
    _bgControl.userInteractionEnabled = YES;
    [_bgControl addTarget:self action:@selector(onBgClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBgClick {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bounds = KEY_WINDOW.bounds;
    
}

- (void)setCanTouchBgCancel:(BOOL)canTouchBgCancel {
    _canTouchBgCancel = canTouchBgCancel;
    
    if (!canTouchBgCancel) {
        [_bgControl addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showInView:(UIView *)view{
    _inView = view;
    
    [KEY_WINDOW addSubview:_bgControl];
    [KEY_WINDOW addSubview:self];
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    self.center = CGPointMake(KEY_WINDOW.width/2, KEY_WINDOW.height/2);
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        _bgControl.alpha = 0.4;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)cancel {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        _bgControl.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished){
        if (finished) {
            [_bgControl removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)onCancelBtn:(id)sender{
    [self cancel];
}

- (UIControl *)backgroundControl{
    return _bgControl;
}

- (CAKeyframeAnimation *)scaleAnimation:(BOOL)show{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}

@end
