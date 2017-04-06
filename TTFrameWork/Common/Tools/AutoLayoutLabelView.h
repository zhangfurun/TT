//
//  AutoLayoutLabelView.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

// 这个主要是一个View用于展示的标签
// 一般是用于搜索热词
// 每个Button针对屏幕情况进行自适应

typedef void (^BtnBlock)(NSInteger index);

@interface AutoLayoutLabelView : UIView
@property (strong, nonatomic) UIColor *labelBGColor;
@property (nonatomic,copy) BtnBlock btnBlock;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray <NSString *> *labels;
@end
