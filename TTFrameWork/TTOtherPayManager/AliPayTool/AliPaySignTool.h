//
//  AliPaySignTool.h
//  StoryShip
//
//  Created by 张福润 on 2017/4/24.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AliPayModel;

@interface AliPaySignTool : NSObject
+ (NSString *)doAlipayPay:(AliPayModel *)model;
@end
