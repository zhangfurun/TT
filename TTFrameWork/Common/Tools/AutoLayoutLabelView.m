//
//  AutoLayoutLabelView.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "AutoLayoutLabelView.h"

#import "TTConst.h"

#define BUTTON_TAG_BEGIN 1000

@implementation AutoLayoutLabelView

- (void)setLabels:(NSArray<NSString *> *)labels {
    
    _labels = labels;
    for (int i = 0; i < _labels.count; i ++) {
        NSString *title = _labels[i];
        static UIButton *recordBtn =nil;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        CGRect rect = [title boundingRectWithSize:CGSizeMake(self.frame.size.width -20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
        
        CGFloat BtnW = rect.size.width + 20;
        CGFloat BtnH = rect.size.height + 10;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = BtnH/2;
        if (i == 0) {
            btn.frame =CGRectMake(10, 10, BtnW, BtnH);
        }
        else{
            CGFloat yuWidth = self.frame.size.width - 20 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
            if (yuWidth >= rect.size.width) {
                btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
            }else {
                btn.frame =CGRectMake(10, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
            }
        }
        btn.backgroundColor = (self.labelBGColor == nil) ? [UIColor whiteColor] : self.labelBGColor;
        [btn setTitleColor:RGBA_COLOR(47, 152, 234, 0.8) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        
        //        self.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20,CGRectGetMaxY(btn.frame)+10);
        recordBtn = btn;
        btn.tag = BUTTON_TAG_BEGIN + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)BtnClick:(UIButton *)sender {
    __weak typeof(self) WS = self;
    if (WS.btnBlock) {
        WS.btnBlock(sender.tag - BUTTON_TAG_BEGIN);
    }
}


@end
