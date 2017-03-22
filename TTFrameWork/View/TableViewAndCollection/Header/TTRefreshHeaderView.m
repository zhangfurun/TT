//
//  TTRefreshHeaderView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTRefreshHeaderView.h"

#import "UIView+TTSuperView.h"

@interface TTRefreshHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;
@property (weak, nonatomic) IBOutlet UIImageView *aniLoadingImgView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *aniImages;
@end

@implementation TTRefreshHeaderView
- (void)removeFromSuperview {
    [super removeFromSuperview];
        [self.loadingImgView stopRotationDisableViews:nil];
//    [_aniLoadingImgView stopAnimating];
}

#pragma mark - Methods
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
                        title = @"下拉可以刷新哦!";
                        [self.loadingImgView stopRotationDisableViews:nil];
            break;
        case RefreshViewStateLoading:
                        title = @"正在刷新，请稍后...";
                        [self.loadingImgView startRotationWithDisableViews:nil];
            [self setAniImage];
            break;
        case RefreshViewStateWillLoad:
                        title = @"松开就能刷新哦!";
                        [self.loadingImgView stopRotationDisableViews:nil];
            break;
    }
    self.stateLabel.text = title;
}

- (void)dealloc {
    NSLog(@"TTRefreshHeaderView dealloc");
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<0 && _state != RefreshViewStateLoading) {
//        int idx = -1 * (scrollView.contentOffset.y/10);
//        NSString *picName = [NSString stringWithFormat:@"A_%d", idx % 10];
//        [_aniLoadingImgView setImage:[UIImage imageNamed:picName]];
                float angle = degreesToRadian(-scrollView.contentOffset.y * 3);
                self.loadingImgView.transform = CGAffineTransformMakeRotation(angle);
    }
}
@end
