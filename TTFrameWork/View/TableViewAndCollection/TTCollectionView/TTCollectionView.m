//
//  TTCollectionView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTCollectionView.h"

#import "TTMoreFooterView.h"
#import "TTRefreshHeaderView.h"
#import "UIView+TTSuperView.h"

@interface TTCollectionView ()<TTMoreFooterViewDelegate> {
    BOOL _isDisplay;
}
@property (nonatomic, strong) TTRefreshHeaderView *refreshView;
@property (nonatomic, strong) TTMoreFooterView *moreView;
@property (nonatomic, assign) BOOL isHiddenHeaderView;
@end

@implementation TTCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.refreshView = [TTRefreshHeaderView loadFromNib];
    self.refreshView.frame = CGRectMake(0, -self.refreshView.height, self.width, self.refreshView.height);
    [self addSubview:self.refreshView];
    self.alwaysBounceVertical = YES;
}

- (void)setRefreshHeaderViewBottom:(float)bottom {
    _refreshView.bottom = bottom;
}

- (void)isHiddenHeaderRefreshView:(BOOL)isHidden {
    _isHiddenHeaderView = isHidden;
}

- (void)isDisplayMoreView:(BOOL)isDisplay {
    _isDisplay = isDisplay;
}

- (BOOL)isNeedLoad {
    return self.contentOffset.y + self.height > self.contentSize.height + 30 && self.moreView.state != RefreshViewStateLoading && _isDisplay;
}

- (BOOL)isNeedRefresh {
    return self.contentOffset.y < -80 && self.refreshView.state != RefreshViewStateLoading;
}

- (void)startRefresh {
    if (!_isHiddenHeaderView) {
        [_refreshView setState:RefreshViewStateLoading];
        [self setContentOffset:CGPointMake(0, -40) animated:YES];
        
        if ([_loadDelegate respondsToSelector:@selector(collectionViewRefresh:)]) {
            [_loadDelegate collectionViewRefresh:self];
        }
    }
}

- (void)loadMore {
    if ([_loadDelegate respondsToSelector:@selector(collectionViewLoadMore:)]) {
        [_loadDelegate collectionViewLoadMore:self];
    }
}

- (void)didFinishedLoading {
    _refreshView.state = RefreshViewStateNormal;
    _moreView.state = RefreshViewStateNormal;
    
    if (self.contentOffset.y < 0) {
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)setContentSize:(CGSize)contentSize {
    contentSize = CGSizeMake(contentSize.width, contentSize.height + 40);
    [super setContentSize:contentSize];
    _refreshView.hidden = _isHiddenHeaderView;
    
    if (_isDisplay) {
        if (!_moreView) {
            _moreView = [TTMoreFooterView loadFromNib];
            _moreView.delegate = self;
        }
        _moreView.frame = CGRectMake(0, self.contentSize.height - _footHeight - _moreView.height, self.width, _moreView.height);
        [self addSubview:_moreView];
    } else {
        [_moreView removeFromSuperview];
        _moreView = nil;
    }
}

- (BOOL)isAnimating {
    return !self.dragging && !self.decelerating;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    if ([self isNeedLoad]) {
        [_moreView setState:RefreshViewStateLoading];
        [self loadMore];
    }
    if ([self isNeedRefresh]) {
        if (self.dragging) {
            [_refreshView setState:RefreshViewStateWillLoad];
        }
        if (self.decelerating) {
            [self startRefresh];
        }
    } else {
        if (_refreshView.state == RefreshViewStateWillLoad) {
            [_refreshView setState:RefreshViewStateNormal];
        }
    }
    [_refreshView scrollViewDidScroll:self];
}

- (RefreshViewState)state {
    return _refreshView.state;
}

@end
