//
//  TTAudioTool.h
//  TT
//
//  Created by 张福润 on 2017/4/6.
//  Copyright © 2017年 张福润. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ComplitionBlock)(BOOL success, NSString *msg);

@protocol TTAudioToolDelegate <NSObject>
@optional
- (void)audioToolProgress:(float)progress currentTime:(NSTimeInterval)currentTime;
- (void)audioToolPlayCompeted;
@end

@interface TTAudioTool : NSObject
@property (nonatomic, weak) id<TTAudioToolDelegate> delegate;

@property (nonatomic, strong) NSURL *audioPath;
@property (nonatomic, assign, readonly) float progress;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

+ (instancetype)shareInstance;

- (void)play;
- (void)playWithBlock:(ComplitionBlock)complition;
- (void)playWithTime:(NSTimeInterval)time;
- (void)pause;
- (void)stop;
@end
