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
/// 页码pageControl位置（默认左上角）
@property (nonatomic, assign) CGPoint pageControlPoint;

/// 页码pageLabel（默认不显示）
@property (nonatomic, strong, readonly) UILabel *pageLabel;
/// 页码pageLabel位置（默认右下角）
@property (nonatomic, assign) CGPoint pageLabelPoint;

/// 是否显示标题（默认不显示）
@property (nonatomic, assign) BOOL showText;
/// 标题标签（默认不显示，且字符居中对齐）
@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 标题标签textLabel位置（默认居中）
@property (nonatomic, assign) CGPoint textLabelPoint;

/// 是否显示删除按钮（默认隐藏）
@property (nonatomic, assign) BOOL showDeleteButton;
/// 图片删除（删除当前浏览的某一张图片）
@property (nonatomic, copy) void (^imageDelete)(NSInteger index);

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
- (void)reloadUIView;

@end

/*
 
 使用示例
 NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 
 CGRect rect = self.view.bounds;
 rect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
 // 实例化
 SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
 imageBrowse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
 // 类型
 imageBrowse.browseMode = SYImageBrowseAdvertisement;
 // 页码
 imageBrowse.pageMode = SYImageBrowsePageControl;
 imageBrowse.pageAlignmentMode = SYImageBrowsePageControlAlignmentCenter;
 imageBrowse.pageNormalColor = [UIColor redColor];
 imageBrowse.pageSelectedColor = [UIColor greenColor];
 imageBrowse.showPageControl = YES;
 imageBrowse.pageIndex = 3;
 // 标题
 imageBrowse.showText = YES;
 imageBrowse.textMode = SYImageBrowseTextAlignmentCenter;
 imageBrowse.textBgroundColor = [UIColor redColor];
 imageBrowse.textColor = [UIColor yellowColor];
 // 自动播放
 imageBrowse.isAutoPlay = NO;
 // 图片样式
 imageBrowse.imageContentMode = SYImageBrowseContentFit;
 // 数据源
 imageBrowse.imageSource = images;
 imageBrowse.titleSource = titles;
 // 交互
 imageBrowse.imageSelected = ^(NSInteger index){
 NSLog(@"imageSelected %ld", index);
 };
 imageBrowse.showDeleteButton = YES;
 imageBrowse.imageDelete = ^(NSInteger index){
 NSLog(@"imageDelete %ld", index);
 };
 
 */

