//
//  SYImageBrowseView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  github：https://github.com/potato512/SYImageBrowser


#import <UIKit/UIKit.h>
#import "SYImageBrowseHelper.h"

@interface SYImageBrowseView : UIView

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view;
- (instancetype)initWithFrame:(CGRect)frame;

/// 图片源
@property (nonatomic, strong) NSArray *images;

/// 标题源
@property (nonatomic, strong) NSArray *titles;

/// 图片点击
@property (nonatomic, copy) void (^imageClick)(NSInteger index);

/// 广告图片的轮播模式（循环、不循环。默认循环）
@property (nonatomic, assign) SYImageBrowseLoopType loopType;
/// 功能模式（广告轮播，或图片浏览）
@property (nonatomic, assign) SYImageBrowseMode browseMode;
/// 图片显示样式（等比例显示，放大显示，默认放大）
@property (nonatomic, assign) SYImageBrowseContentMode imageContentMode;
/// 页码样式（pageControl/pagelabel，默认pageControl）
@property (nonatomic, assign) SYImageBrowsePageMode pageMode;

/// 页码pageControl（默认左上角显示）
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
/// 页码pageControl位置（默认右下角）
@property (nonatomic, assign) CGRect pageControlFrame;

/// 页码pageLabel（默认不显示，显示时右下角）
@property (nonatomic, strong, readonly) UILabel *pageLabel;
/// 页码pageLabel位置（默认右下角）
@property (nonatomic, assign) CGRect pageLabelFrame;

/// 是否显示标题（默认不显示）
@property (nonatomic, assign) BOOL showText;
/// 标题标签（默认不显示，显示时在左下角，且字符居中对齐）
@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 标题标签textLabel位置（默认左下角）
@property (nonatomic, assign) CGRect textLabelFrame;

#warning 待完善
/// 是否显示图片操作按钮（默认隐藏NO，注意浏览模式下有效）
@property (nonatomic, assign) BOOL showButton;
/// 图片操作回调（注意浏览模式下有效）
@property (nonatomic, copy) void (^imageManager)(SYImageBrowseButtonType type, NSInteger index);

/// 是否显示左右切换按钮（默认隐藏）
@property (nonatomic, assign) BOOL showSwitchButton;
/// 图片左
@property (nonatomic, strong) UIImage *imagePrevious;
/// 图片左高亮
@property (nonatomic, strong) UIImage *imagePreviousHighlight;
/// 图片右
@property (nonatomic, strong) UIImage *imageNext;
/// 图片右高亮
@property (nonatomic, strong) UIImage *imageNextHighlight;

/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger pageIndex;

/// 自动播放（默认未启用，启用自动播放，或停止播放）
@property (nonatomic, assign) BOOL isAutoPlay;
/// 自动播放时间长（默认3秒）
@property (nonatomic, assign) NSTimeInterval animationTime;

/// 默认图片
@property (nonatomic, strong) UIImage *defaultImage;

/// 刷新信息（最后调用）
- (void)reloadData;

@end

/*
 
 使用示例
 NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 
 // 实例化
 SYImageBrowseView *imageView = [[SYImageBrowseView alloc] initWithFrame:self.view.bounds view:self.view];
 imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 imageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
 // 循环模式
 imageView.loopType = SYImageBrowseLoopTypeTrue;
 // 类型 SYImageBrowseViewShow SYImageBrowseAdvertisement
 imageView.browseMode = SYImageBrowseViewShow;
 // 页码control
 imageView.pageMode = SYImageBrowsePageControl;
 imageView.pageControl.backgroundColor = [UIColor yellowColor];
 imageView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
 imageView.pageControl.pageIndicatorTintColor = [UIColor greenColor];
 imageView.pageControlFrame = CGRectMake(10.0, 10.0, 30.0, 30.0);
 // 页码label
 // imageView.pageMode = SYImageBrowsePagelabel;
 // imageView.pageLabel.backgroundColor = [UIColor yellowColor];
 // imageView.pageLabel.textColor = [UIColor redColor];
 // imageView.pageLabelFrame = CGRectMake(10.0, 10.0, 30.0, 30.0);
 // 当前页码
 imageView.pageIndex = 3;
 // 标题
 imageView.showText = YES;
 imageView.textLabelFrame = CGRectMake(50.0.0, 10.0, 80.0, 30.0);
 //
 imageView.showSwitchButton = YES;
 // 自动播放 YES,NO
 imageView.isAutoPlay = NO;
 imageView.animationTime = 3.0;
 // 图片样式 SYImageBrowseContentFill,SYImageBrowseContentFit
 imageView.imageContentMode = SYImageBrowseContentFill;
 // 默认图片
 imageView.defaultImage = [UIImage imageNamed:@"DefaultImage"];
 // 数据源
 imageView.images = self.images;
 imageView.titles = self.titles;
 // 交互
 WeakSYImageBrowse;
 imageView.imageClick = ^(NSInteger index){
     NSLog(@"imageSelected %ld", index);
     
     SYImageBrowseViewController *browseVC = [SYImageBrowseViewController new];
     browseVC.imageArray = weakSYImageBrowse.images;
     browseVC.imageIndex = 2;
     [browseVC reloadData];
     [weakSYImageBrowse.navigationController pushViewController:browseVC animated:YES];
 };
 // 删除按钮（浏览模式才有效）
 imageView.showButton = YES;
 imageView.imageManager = ^(SYImageBrowseButtonType type, NSInteger index){
     NSLog(@"imageDelete %ld", type);
 };
 // 刷新数据
 [imageView reloadData];
 
 */

