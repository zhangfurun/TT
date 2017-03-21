//
//  TTManager.h
//  TT
//
//  Created by 张福润 on 2017/3/11.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kLogStatus = @"kLogStatus";

@interface TTManager : NSObject

+ (void)setLogStatus:(BOOL)logStatus;
+ (BOOL)logStatus;
@end
