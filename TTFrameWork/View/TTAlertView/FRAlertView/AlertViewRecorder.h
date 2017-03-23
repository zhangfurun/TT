//
//  AlertViewRecorder.h
//  StoryShip
//
//  Created by 张福润 on 2017/3/7.
//  Copyright © 2017年 ifenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewRecorder : NSObject
@property (nonatomic, strong)NSMutableArray * alertViewArray;

+ (AlertViewRecorder *)shareAlertViewRecorder;
@end
