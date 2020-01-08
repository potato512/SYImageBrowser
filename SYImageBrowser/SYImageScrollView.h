//
//  SYImageScrollView.h
//  zhangshaoyu
//
//  Created by herman on 2017/8/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//  图片视图，浏览时使用

#import <UIKit/UIKit.h>

@interface SYImageScrollView : UIScrollView

/// 显示子视图
@property (nonatomic, strong) UIView *showView;

/// 初始化大小
@property (nonatomic, assign) BOOL isInitialize;

/// 单击隐藏回调
@property (nonatomic, copy) void (^hiddenClick)(void);

@end
