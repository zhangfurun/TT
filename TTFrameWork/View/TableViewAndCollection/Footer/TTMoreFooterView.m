//
//  TTMoreFooterView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTMoreFooterView.h"

@interface TTMoreFooterView()
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *aniLoadingImgView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *aniImages;
@end

@implementation TTMoreFooterView
- (void)removeFromSuperview {
    [super removeFromSuperview];
    //    [self.loadingImgView stopRotationDisableViews:nil];
    [_aniLoadingImgView stopAnimating];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setAniImage];
}

#pragma mark - Methdos
- (NSMutableArray<UIImage *> *)aniImages {
    if (!_aniImages) {
        _aniImages = [NSMutableArray arrayWithCapacity:10];
        int i = 0;
        do {
//            [_aniImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"A_%d", i]]];
            i++;
        } while (i < 10);
    }
    return _aniImages;
}

- (void)setAniImage {
    _aniLoadingImgView.animationImages = self.aniImages;
    _aniLoadingImgView.animationRepeatCount = 0;
    [_aniLoadingImgView setAnimationDuration:1];
    [_aniLoadingImgView startAnimating];
}

- (void)setState:(RefreshViewState)state {
    _state = state;
    
    NSString *title = nil;
    switch (state) {
        case RefreshViewStateNormal:
            //            title = @"更多...";
            //            _moreBtn.userInteractionEnabled = YES;
                        [_indicatorView stopAnimating];
            break;
        case RefreshViewStateLoading:
            //            title = @"正在加载，请稍候...";
            //            _moreBtn.userInteractionEnabled = NO;
                        [_indicatorView startAnimating];
            break;
        case RefreshViewStateWillLoad:
            //            title = @"松开就能加载哦!";
            //            _moreBtn.userInteractionEnabled = YES;
                        [_indicatorView stopAnimating];
            break;
    }
    [_moreBtn setTitle:title forState:UIControlStateNormal];
    [_moreBtn setTitle:title forState:UIControlStateHighlighted];
}

- (IBAction)onMoreBtnTap:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(loadMore)]) {
        [self setState:RefreshViewStateLoading];
        [_delegate loadMore];
    }
}

@end
