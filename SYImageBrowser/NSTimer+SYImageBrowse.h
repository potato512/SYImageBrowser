//
//  NSTimer+SYImageBrowse.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TimerBlock)(NSTimer *timer);

@interface NSTimer (SYImageBrowse)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)time userInfo:(id)userInfo repeats:(BOOL)isRepeat handle:(TimerBlock)handle;

- (void)timerStop;

- (void)timerStart;

- (void)timerKill;

@end
