//
//  TTManager.m
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTManager.h"

#import "NSUserDefaults+TTUserDefaults.h"

@implementation TTManager

#pragma mark - Property Method
+ (void)setLogStatus:(BOOL)logStatus{
    [NSUserDefaults setBoolValue:logStatus forKey:kLogStatus];
}

+ (BOOL)logStatus{
    if ([NSUserDefaults isExistsForKey:kLogStatus]) {
        return [NSUserDefaults boolValueForKey:kLogStatus];
    }
    return YES;
}

@end
