//
//  SYImageBrowser.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  github：https://github.com/potato512/SYImageBrowser


#import <UIKit/UIKit.h>
#import "SYImageBrowserDelegate.h"

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

@interface SYImageBrowser : UIView

/// 限制使用init方法
- (instancetype)init __attribute__((unavailable("init 方法不可用，请用 initWithFrame:")));

/// 默认不显示标题
@property (nonatomic, assign) BOOL showTitle;
/// 默认显示顶端居中
@property (nonatomic, strong) UILabel *titleLabel;

/// 当且仅当只有一张图片时，是否显示页签（默认NO，即显示）
@property (nonatomic, assign) BOOL hiddenWhileSinglePage;
/// 当且仅当只有一张图片时，禁止拖动响应（默认YES，即可拖动响应）
@property (nonatomic, assign) BOOL enableWhileSinglePage;

/// 默认UIImagePageControl
@property (nonatomic, assign) UIImagePageControlType pageControlType;
/// 默认显示底端居中
@property (nonatomic, strong) UIPageControl *pageControl;
/// 默认显示底端居右
@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, assign) CGPoint pagePoint;
@property (nonatomic, assign) CGSize pageSize;


/// 自动播放（默认非自动播放；且在UIImageScrollLoop模式下有效）
@property (nonatomic, assign) BOOL autoAnimation;
/// 自动播放时间间隔（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoDuration;

/// 默认UIImageScrollNormal
@property (nonatomic, assign) UIImageScrollMode scrollMode;


/// 切换按钮
/// 是否显示（默认不显示）
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;

/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger pageIndex;

/// 调用这些方法，属性时，表示图片被浏览
/// 默认淡入动画（默认NO）
@property (nonatomic, assign) BOOL isBrowser;

/// 代理
@property (nonatomic, weak) id<SYImageBrowserDelegate> deletage;

/// 数据刷新
- (void)reloadData;

@end

/*
 
 使用示例
 NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 
 // 实例化
 SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 160.0)];
 [self.view addSubview:imageView];
 imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
 // 图片源
 imageView.images = images;
 // 图片浏览模式 UIImageScrollLoop UIImageScrollNormal
 imageView.scrollMode = UIImageScrollNormal;
 // 图片显示模式
 imageView.contentMode = UIViewContentModeScaleAspectFit;
 // 标题标签
 imageView.titles = titles;
 imageView.showTitle = YES;
 imageView.titleLabel.textColor = [UIColor redColor];
 // 页签-pageControl
 imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
 imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
 // 页签-label UIImagePageControlHidden UIImagePageControl UIImagePageLabel
 imageView.pageControlType = UIImagePageControl;
 imageView.pageLabel.backgroundColor = [UIColor yellowColor];
 imageView.pageLabel.textColor = [UIColor redColor];
 // 切换按钮
 imageView.showSwitch = YES;
 // 自动播放
 imageView.isAutoPlay = NO;
 imageView.animationTime = 1.2;
 // 图片浏览
 imageView.isBrowser = YES;
 // 滚动回调
 imageView.imageScroll = ^(NSInteger index){
     NSLog(@"scroll = %@", @(index + 1));
 };
 // 图片点击
 imageView.imageClick = ^(NSInteger index){
     [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index + 1)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
 };
 // 数据刷新
 [imageView reloadData];
 
 */

