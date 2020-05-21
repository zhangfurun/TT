//
//  OSSLog.h
//  oss_ios_sdk
//
//  Created by zhouzhuo on 8/16/15.
//  Copyright (c) 2015 aliyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSCocoaLumberjack.h"
static const OSSDDLogLevel ossLogLevel = OSSDDLogLevelAll;

// colorful log configuration
// see https://github.com/robbiehanson/XcodeColors

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define OSSLogVerbose(frmt, ...)\
if ([OSSLog isLogEnable]) {\
OSSDDLogVerbose(@"[Verbose]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define OSSLogDebug(frmt, ...)\
if ([OSSLog isLogEnable]) {\
OSSDDLogDebug(@"[Debug]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define OSSLogDebugNoFile(frmt, ...)\
if ([OSSLog isLogEnable]) {\
NSLog(@"[Debug]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define OSSLogError(frmt, ...)\
if ([OSSLog isLogEnable]) {\
OSSDDLogError(@"[Error]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

#define OSSLogWarn(frmt, ...)\
if ([OSSLog isLogEnable]) {\
OSSDDLogWarn(@"[Warning]: %@", [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);\
}

static BOOL isEnable;

@interface OSSLog : NSObject

+ (void)enableLog;
+ (void)disableLog;
+ (BOOL)isLogEnable;
@end
