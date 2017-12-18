//
//  NSTimer+TTTimer.m
//  TT
//
//  Created by 张福润 on 2017/12/18.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "NSTimer+TTTimer.h"

@implementation NSTimer (TTTimer)
- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
