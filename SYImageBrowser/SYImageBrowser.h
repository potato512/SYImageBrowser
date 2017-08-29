//
//  SYImageBrowser.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  github：https://github.com/potato512/SYImageBrowser


#import <UIKit/UIKit.h>
#import "SYImageBrowserDelegate.h"

/// 页码控制器样式，默认UIPageControlType
typedef NS_ENUM(NSInteger, UIImagePageControlType)
{
    UIImagePageControlHidden = 0,
    
    UIImagePageControl = 1,
    
    UIImagePageLabel = 2,
};

/// 图片轮播方式，默认ImageScrollNormal
typedef NS_ENUM(NSInteger, UIImageScrollMode)
{
    /// 循环
    UIImageScrollLoop = 1,
    
    /// 非循环
    UIImageScrollNormal = 2,
};

@interface SYImageBrowser : UIView

/// 限制使用init方法
- (instancetype)init __attribute__((unavailable("init 方法不可用，请用 initWithFrame:")));

/// 数据源
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

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
/// 默认UIViewContentModeScaleAspectFill
@property (nonatomic, assign) UIViewContentMode contentMode;


/// 图片点击响应
@property (nonatomic, copy) void (^imageSelected)(NSInteger index);
/// 图片滚动响应（contentOffX滚动距离；direction表示方向，1向左，2向右；isEnd表示最左或最右边）
@property (nonatomic, copy) void (^imageScrolled)(float contentOffX, NSInteger direction, BOOL isEnd);


/// 切换按钮
/// 是否显示（默认不显示）
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;


/// 默认图标（默认无）
@property (nonatomic, strong) UIImage *defaultImage;

/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger pageIndex;


/// 调用这些方法，属性时，表示图片被浏览
/// 默认淡入动画（默认NO）
@property (nonatomic, assign) BOOL isBrowser;


/// 滚动时的索引
/// block索引
@property (nonatomic, copy) void (^imageBrowserDidScroll)(NSInteger index);
/// 代理
@property (nonatomic, assign) id<SYImageBrowserDelegate>deletage;
/// 代理索引

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
 // 图片浏览模式 ImageShowRunloopType ImageShowNormalType
 imageView.showType = ImageShowNormalType;
 // 图片显示模式 ImageContentAspectFillType ImageContentAspectFitType
 imageView.contentMode = ImageContentAspectFitType;
 // 标题标签
 imageView.titles = titles;
 imageView.showTitle = YES;
 imageView.titleLabel.textColor = [UIColor redColor];
 // 页签-pageControl
 imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
 imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
 // 页签-label UILabelControlType
 imageView.pageType = UIPageControlType;
 imageView.pageLabel.backgroundColor = [UIColor yellowColor];
 imageView.pageLabel.textColor = [UIColor redColor];
 // 切换按钮
 imageView.showSwitch = YES;
 // 自动播放
 imageView.isAutoPlay = NO;
 imageView.animationTime = 1.2;
 // 图片浏览时才使用
 imageView.show = NO;
 imageView.hidden = NO;
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

