//
//  TTAudioTool.m
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import "TTAudioTool.h"

#import "XTimer.h"

#import <AVFoundation/AVFoundation.h>

@interface TTAudioTool ()<AVAudioPlayerDelegate> {
    float _progress;
}
@property (nonatomic, assign, getter=isAudioUrlExist) BOOL audioUrlExist;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) XTimer *progressTimer;
@end

@implementation TTAudioTool

static TTAudioTool *instance;

#pragma mark - Property Method
- (BOOL)isAudioUrlExist {
    return self.audioPath != nil;
}

- (void)setAudioPath:(NSURL *)audioPath {
    if (audioPath == nil || _audioPath == audioPath) {
        self.player = nil;
        return;
    }
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioPath error:&error];
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    self.error = error;
    if (self.error) {
        self.player = nil;
        return;
    }
    if (![self.player prepareToPlay]) {
        self.error = [NSError errorWithDomain:@"TTFrameWork" code:-10000 userInfo:@{NSLocalizedDescriptionKey: @"预加载失败"}];
        return;
    }
    
    _audioPath = audioPath;
}

- (float)progress {
    return _progress;
}

- (NSTimeInterval)currentTime {
    NSLog(@"currentTime: %f, deviceCurrentTime: %f", self.player.currentTime, self.player.deviceCurrentTime);
    return self.currentTime;
}

- (NSTimeInterval)totalTime {
    NSLog(@"totalTime: %f", self.player.duration);
    return self.player.duration;
}

#pragma mark - Selector
- (void)playProgress {
    NSTimeInterval currentTime = self.player.currentTime;
    _progress = currentTime/self.player.duration;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioToolProgress:currentTime:)]) {
        [self.delegate audioToolProgress:_progress currentTime:currentTime];
    }
}

#pragma mark - Method
+ (instancetype)shareInstance {
    if (!instance) {
        instance = [TTAudioTool new];
    }
    return instance;
}

- (void)play {
    [self playWithBlock:nil];
}

- (void)playWithBlock:(ComplitionBlock)complition {
    if (!self.isAudioUrlExist) {
        if (complition) {
            complition(NO, @"无音乐文件");
            return;
        }
    }
    if (self.player == nil) {
        if (complition) {
            NSString *msg = self.error == nil ? @"" : self.error.localizedDescription;
            complition(NO, msg);
        }
        return;
    }
    [self.player play];
    self.progressTimer = [XTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
    if (complition) {
        complition(YES, @"");
    }
}

- (void)playWithTime:(NSTimeInterval)time {
    if (self.player == nil) {
        return;
    }
    self.player.currentTime = time;
    [self.player prepareToPlay];
    [self.player play];
    [self.progressTimer reStart];
}

- (void)pause {
    [self.player pause];
    [self.progressTimer stop];
}

- (void)stop {
    self.player.currentTime = 0;
    [self.player stop];
    self.player = nil;
    instance = nil;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(audioToolPlayCompeted)]) {
        [self.delegate audioToolPlayCompeted];
    }
    [self.progressTimer invalidate];
}

@end

