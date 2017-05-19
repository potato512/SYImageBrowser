//
//  SYImageBrowseViewLoopAuto.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageBrowseHelper.h"

@interface SYImageBrowseViewLoopAuto : UIView

@property (nonatomic, strong) NSArray *images;

/// 图片点击
@property (nonatomic, copy) void (^imageClick)(NSInteger index);
/// 图片滚动回调
@property (nonatomic, copy) void (^imageScroll)(NSInteger index);
/// 自动播放后的回调
@property (nonatomic, copy) void (^imageAutoScroll)(NSInteger index);

/// 图片显示样式（等比例显示，放大显示，默认放大）
@property (nonatomic, assign) SYImageBrowseContentMode imageContentMode;

/// 自动播放（默认未启用，启用自动播放，或停止播放）
@property (nonatomic, assign) BOOL isAutoPlay;
/// 自动播放时间长（默认3秒）
@property (nonatomic, assign) NSTimeInterval animationTime;
/// 暂停，或恢复自动播放
- (void)autoPlayStatus:(BOOL)start;

/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger pageIndex;
/// 图片浏览方向（默认向右YES，结合按钮定位图片使用）
@property (nonatomic, assign) BOOL isDirectionRight;

/// 默认图片
@property (nonatomic, strong) UIImage *defaultImage;

/// 刷新信息（最后调用）
- (void)reloadData;

@end
