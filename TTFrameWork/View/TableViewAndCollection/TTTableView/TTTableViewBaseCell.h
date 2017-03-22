//
//  TTTableViewBaseCell.h
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableViewBaseCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *indexPath;

/**
 选择是否重写getIdentifier,如果不重写,Identifier为类名
 
 注意:xib上面的Identifier一定要与此一致
 */
+ (NSString *)getIdentifier;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
