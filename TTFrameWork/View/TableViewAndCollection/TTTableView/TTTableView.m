//
//  TTTableView.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTableView.h"

#import "TTMoreFooterView.h"
#import "TTRefreshHeaderView.h"

#import "UIView+TTSuperView.h"

@interface TTTableView ()<TTMoreFooterViewDelegate> {
    TTMoreFooterView *_moreView;
    TTRefreshHeaderView *_refreshView;
    void(^_moreBlock)();
    void(^_refreshBlock)();
    
}
@end

@implementation TTTableView

- (void)setRefreshHeaderViewBottom:(float)bottom {
    _refreshView.bottom = bottom;
}

- (void)setMoreBlock:(void (^)())moreBlock {
    _moreBlock = moreBlock;
    
    if (moreBlock) {
        if (!_moreView) {
            _moreView = [TTMoreFooterView loadFromNib];
            _moreView.delegate = self;
        }
        self.tableFooterView = _moreView;
    } else {
        self.tableFooterView = nil;
    }
}

- (void)setRefreshBlock:(void (^)())refreshBlock {
    _refreshBlock = refreshBlock;
    
    if (_refreshBlock) {
        if (!_refreshView) {
            _refreshView = [TTRefreshHeaderView loadFromNib];
            _refreshView.frame = CGRectMake(0, -_refreshView.height, self.width, _refreshView.height);
        }
        [self addSubview:_refreshView];
    } else {
        [_refreshView removeFromSuperview];
    }
}

- (BOOL)isNeedLoad {
    return self.contentOffset.y + self.height > self.contentSize.height + 50 && _moreView.state != RefreshViewStateLoading && _moreBlock;
}

- (BOOL)isNeedRefresh {
    return _refreshBlock && self.contentOffset.y < -100 && _refreshView.state != RefreshViewStateLoading;
}

- (void)loadMore {
    if (_moreBlock) {
        _moreBlock();
    }
}

- (void)startRefresh {
    [self setContentOffset:CGPointMake(0, -40) animated:YES];
    if (_refreshBlock) {
        _refreshBlock();
    }
}

- (void)didFinishedLoading {
    _moreView.state = RefreshViewStateNormal;
    _refreshView.state = RefreshViewStateNormal;
    
    if (self.contentOffset.y < 0) {
        [self setContentOffset:CGPointZero animated:YES];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    if ([self isNeedLoad]) {
        [_moreView setState:RefreshViewStateLoading];
        [self loadMore];
    }
    if ([self isNeedRefresh]) {
        if (self.isDragging) {
            [_refreshView setState:RefreshViewStateWillLoad];
        }
        if (self.isDecelerating) {
            [_refreshView setState:RefreshViewStateLoading];
            [self startRefresh];
        }
    } else {
        if (_refreshView.state == RefreshViewStateWillLoad) {
            [_refreshView setState:RefreshViewStateWillLoad];
        }
    }
    [_refreshView scrollViewDidScroll:self];
}

@end
