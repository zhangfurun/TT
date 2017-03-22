//
//  TTRefreshHeaderView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTConst.h"

@interface TTRefreshHeaderView : UIView
@property (nonatomic) RefreshViewState state;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
