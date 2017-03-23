//
//  WaterfallCollectionViewLayout.h
//  WaterfallCollectionView
//
//  Created by Miroslaw Stanek on 12.07.2013.
//  Copyright (c) 2013 Event Info Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallCollectionViewLayout;

@protocol WaterfallCollectionViewLayoutDelegate <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(WaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
                    itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(WaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterfallCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) id<WaterfallCollectionViewLayoutDelegate> delegate;

@property (nonatomic) NSInteger columnsCount;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;

@property (nonatomic) BOOL stickyHeader; // default : YES

@property (assign, nonatomic, getter=isShowHeaderNoneDate) BOOL showHeaderNoneDate;  // default : YES
@end
