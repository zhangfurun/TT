//
//  TTWebView.h
//  TT
//
//  Created by 张福润 on 2017/3/23.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWebView : UIWebView
@property (nonatomic, assign, getter=isAllowUserSelected) BOOL allowUserSelected;
/**
 *  当设置scalesPageToFit为true时，以下两个属性不起作用
 */
@property (nonatomic, assign, getter=isScaleImageWidthEqualWindowWidth) BOOL scaleImageWidthEqualWindowWidth;
@property (nonatomic, assign) CGFloat imageScaleWidth;
/****/
@end
