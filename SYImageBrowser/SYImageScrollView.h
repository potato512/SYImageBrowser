//
//  SYImageScrollView.h
//  zhangshaoyu
//
//  Created by herman on 2017/8/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYImageScrollView : UIScrollView

/// 图片
@property (nonatomic, strong) UIImageView *imageView;

/// 初始化大小
@property (nonatomic, assign) BOOL isInitialize;

/// 单击隐藏回调
@property (nonatomic, copy) void (^hiddenClick)(void);

@end
