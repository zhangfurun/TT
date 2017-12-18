//
//  NSTimer+TTTimer.h
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (TTTimer)
/*
 *  暂停定时器
 **/
- (void)pauseTimer;
/*
 *  恢复定时器
 **/
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
