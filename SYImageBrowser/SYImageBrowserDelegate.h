//
//  SYImageBrowserDelegate.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/13.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYImageBrowser;

/// 页码控制器样式（默认UIPageControlType）
typedef NS_ENUM(NSInteger, UIImagePageControlType) {
    /// 页码控制器样式 隐藏
    UIImagePageControlHidden = 0,
    /// 页码控制器样式 页码
    UIImagePageControl = 1,
    /// 页码控制器样式 标签
    UIImagePageLabel = 2
};

/// 图片轮播方式（默认ImageScrollNormal）
typedef NS_ENUM(NSInteger, UIImageScrollMode) {
    /// 图片轮播方式 循环
    UIImageScrollLoop = 1,
    /// 图片轮播方式 非循环
    UIImageScrollNormal = 2
};

/// 视图切换方向（默认UIImageScrollDirectionHorizontal）
typedef NS_ENUM(NSInteger, UIImageScrollDirection) {
    /// 视图切换方向 水平
    UIImageScrollDirectionHorizontal = 1,
    /// 视图切换方向 竖直
    UIImageScrollDirectionVertical = 2
};

/// 视图滑动方向（默认UIImageScrollDirectionHorizontal）
typedef NS_ENUM(NSInteger, UIImageSlideDirection) {
    /// 视图滑动方向 左
    UIImageSlideDirectionLeft = 1,
    /// 视图滑动方向 右
    UIImageSlideDirectionRight = 2,
    /// 视图滑动方向 上
    UIImageSlideDirectionUpward = 3,
    /// 视图滑动方向 下
    UIImageSlideDirectionDownward = 4
};

///// 视图样式（默认全屏显示）
//typedef NS_ENUM(NSInteger, UIImageShowType) {
//    /// 视图样式 默认全屏显示
//    UIImageShowTypeDefault = 0,
//    /// 视图样式 缩放显示
//    UIImageShowTypeScale = 1,
//    /// 视图样式（默认全屏显示）
//    UIImageShowTypeDefault = 2,
//    /// 视图样式（默认全屏显示）
//    UIImageShowTypeDefault = 3
//};

@protocol SYImageBrowserDelegate <NSObject>

@required
/// 图片数量
- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser;
/// 图片显示
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index;

@optional
/// 滚动时的索引代理
- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index;
/// 点击操作
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index;

/// 图片滚动响应（contentOffX滚动距离；direction表示方向，1向左，2向右，3向上，4向下；isEnd表示最边上）
- (void)imageBrowser:(SYImageBrowser *)browser direction:(UIImageSlideDirection)direction contentOffX:(CGFloat)offX end:(BOOL)isEnd;

@end
