//
//  NSTimer+SYImageBrowser.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/5/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "NSTimer+SYImageBrowser.h"

@implementation NSTimer (SYImageBrowser)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)time userInfo:(id)userInfo repeats:(BOOL)isRepeat handle:(void (^)(NSTimer *timer))handle
{
    TimerBlock timerBlock = [handle copy];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:timerBlock];
    if (userInfo)
    {
        [array addObject:userInfo];
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:time target:weakSelf selector:@selector(timerMethod:) userInfo:array repeats:isRepeat];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer timerStop];
    
    return timer;
}

+ (void)timerMethod:(NSTimer *)timer
{
    NSArray *array = timer.userInfo;
    TimerBlock timerBlock = array.firstObject;
    if (timerBlock)
    {
        timerBlock(timer);
    }
}

/// 开启定时器
- (void)timerStart
{
    [self setFireDate:[NSDate distantPast]];
}

/// 关闭定时器
- (void)timerStop
{
    [self setFireDate:[NSDate distantFuture]];
}

/// 永久停止定时器
- (void)timerKill
{
    [self timerStop];
    [self invalidate];
}

@end
