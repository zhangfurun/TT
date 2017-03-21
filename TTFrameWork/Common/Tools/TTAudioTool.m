//
//  TTAudioTool.m
//  TT
//
//  Created by 张福润 on 2017/3/21.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTAudioTool.h"

#import <AVFoundation/AVFoundation.h>

@implementation TTAudioTool
+ (float)fetchSystemVolume {
    return [[AVAudioSession sharedInstance] outputVolume];
}

@end
