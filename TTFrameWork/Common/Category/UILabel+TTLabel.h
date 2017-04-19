//
//  UILabel+TTLabel.h
//  StoryShip
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TTLabel)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
