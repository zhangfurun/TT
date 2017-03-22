//
//  TTTableView.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableView : UITableView
- (void)setRefreshHeaderViewBottom:(float)bottom;
- (void)didFinishedLoading;
- (void)setRefreshBlock:(void (^)())refreshBlock;
/**
 *  在 TableView reload执行后再设置
 *
 *  @param moreBlock 加载更多Block
 */
- (void)setMoreBlock:(void (^)())moreBlock;
@end
