//
//  TTCollectionView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTConst.h"

@class TTCollectionView;
@protocol TTCollectionViewDelegate <NSObject>
- (void)collectionViewRefresh:(TTCollectionView *)collectionView;
- (void)collectionViewLoadMore:(TTCollectionView *)collectionView;
@end

@interface TTCollectionView : UICollectionView
@property (nonatomic, weak) id<TTCollectionViewDelegate> loadDelegate;
@property (nonatomic, assign) float footHeight;
@property (nonatomic, readonly) RefreshViewState state;
- (void)setRefreshHeaderViewBottom:(float)bottom;
- (void)isHiddenHeaderRefreshView:(BOOL)isHidden;
- (void)isDisplayMoreView:(BOOL)isDisplay;
- (void)didFinishedLoading;
- (void)startRefresh;
@end
