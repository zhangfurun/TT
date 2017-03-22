//
//  TTMoreFooterView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTConst.h"

@protocol TTMoreFooterViewDelegate <NSObject>
- (void)loadMore;
@end

@interface TTMoreFooterView : UIView
@property (nonatomic, weak) id<TTMoreFooterViewDelegate> delegate;
@property (nonatomic) RefreshViewState state;
@end
