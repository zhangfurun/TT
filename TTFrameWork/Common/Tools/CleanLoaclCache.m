//
//  CleanLoaclCache.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "CleanLoaclCache.h"

#import "SDImageCache.h"

#import "FRAlertView.h"

#import "TTConst.h"
#import "TTHUDMessage.h"

NSString *const CacheCleanSuccess = @"CacheCleanSuccess";

@implementation CleanLoaclCache

+ (NSString *)getLoaclCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize] / 1024.00 / 1024.00;
    return [NSString stringWithFormat:@"%.2lf M", imageCache];
}

+ (void)clean {
    float imageCache = [[SDImageCache sharedImageCache] getSize] / 1024.00 / 1024.00;
    
    NSString * CacheString = [NSString stringWithFormat:@"确定要清除 %.2lf M 的缓存么?",imageCache];
    [FRAlertView alertViewWithMessage:CacheString confirmTitle:@"清除" confirmBlock:^{
        [TTHUDMessage showInView:KEY_WINDOW showText:@"开始清除..."];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [TTHUDMessage showCompletedText:@"清除完毕" withCompletedType:HUDShowCompletedTypeCompleted];
            [[NSNotificationCenter defaultCenter] postNotificationName:CacheCleanSuccess object:nil];
        }];
    }];
}

@end
