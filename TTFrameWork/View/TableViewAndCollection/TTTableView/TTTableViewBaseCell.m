//
//  TTTableViewBaseCell.m
//  TT
//
//  Created by 张福润 on 2017/3/22.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTTableViewBaseCell.h"
#import "UIView+TTSuperView.h"

@interface TTTableViewBaseCell ()

@end

@implementation TTTableViewBaseCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:[self getIdentifier]];
    if (!cell) {
        cell = [self loadFromNib];
    }
    return cell;
}

+ (NSString *)getIdentifier {
    return NSStringFromClass([self class]);
}

@end

