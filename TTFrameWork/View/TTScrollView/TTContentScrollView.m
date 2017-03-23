//
//  TTContentScrollView.m
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTContentScrollView.h"
#import "TTTopScrollView.h"
#import "TTConst.h"

#import "UIView+TTSuperView.h"

#define POSITIONID (NSInteger)(scrollView.contentOffset.x/self.contentPageWidth)

static TTContentScrollView *instance;

@implementation TTContentScrollView

+ (instancetype)shareInstance{
    return instance;
}

+ (instancetype)shareInstanceWithFrame:(CGRect)frame{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:frame];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = RGBA_COLOR(243, 243, 243, 1);
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _userContentOffsetX = 0;
    }
    return self;
}

- (void)layoutWithSubviews {
    NSInteger iViewCount = [_subViewArray count];
    CGFloat y = 0;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    for (NSInteger i = 0;i < iViewCount ; i++) {
        UIView *subView = [_subViewArray objectAtIndex:i];
        CGRect frame = CGRectMake(i * w, y, w, h);
        subView.frame = frame;
        [self addSubview:subView];
    }
    self.contentSize = CGSizeMake(self.contentPageWidth * iViewCount, self.frame.size.height - 49);
    [self scrollViewDidEndDecelerating:self];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    _userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_userContentOffsetX < scrollView.contentOffset.x) {
        _leftScroll = YES;
    }else{
        _leftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    [self scrollViewDidScrollSelectedView:scrollView];
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidScrollSelectedView:scrollView];
}

- (void)loadData{
    
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView{
    [TTTopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID + 100;
    [[TTTopScrollView shareInstance] setButtonSelect];
    [[TTTopScrollView shareInstance] setScrollViewContentOffset];
}

- (void)releaseSubviews{
    [self setContentSize:CGSizeZero];
    [self setContentOffset:CGPointZero];
    for (UIView *subView in _subViewArray) {
        [subView removeFromSuperview];
    }
    _subViewArray = nil;
}

- (void)scrollViewDidScrollSelectedView:(UIScrollView *)scrollView{
    if ([_contentScrollViewDelegate respondsToSelector:@selector(TTcontentScrollView:didScrollToView:)]) {
        [_contentScrollViewDelegate TTcontentScrollView:self didScrollToView:[_subViewArray objectAtIndex:POSITIONID]];
    }
}
@end

