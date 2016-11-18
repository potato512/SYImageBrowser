//
//  SYImageBrowse.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  图片浏览（https://github.com/potato512/SYImageBrowser）

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

#import <UIKit/UIKit.h>
#import "SYImageBrowseViewController.h"
#import "SYImageBrowseHelper.h"

@interface SYImageBrowse : UIView

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view;

/// 图片源
@property (nonatomic, strong) NSArray *imageSource;

/// 标题源
@property (nonatomic, strong) NSArray *titleSource;

/// 图片点击
@property (nonatomic, copy) void (^imageSelected)(NSInteger index);

/// 功能模式（广告轮播，或图片浏览）
@property (nonatomic, assign) SYImageBrowseMode browseMode;

/// 页码样式（pageControl，或pagelabel，默认pageControl）
@property (nonatomic, assign) SYImageBrowsePageMode pageMode;

/// 页码pageControl对齐方式（居中，居右，当标题可见时默认居右）
@property (nonatomic, assign) SYImageBrowsePageControlAlignmentMode pageAlignmentMode;

/// 页码pageControl，或pagelabel当前页码颜色
@property (nonatomic, strong) UIColor *pageSelectedColor;
/// 页码pageControl，或pagelabel常态颜色
@property (nonatomic, strong) UIColor *pageNormalColor;

/// 标题对齐方式（居左，居中，居右，默认左对齐）
@property (nonatomic, assign) SYImageBrowseTextAlignmentMode textMode;
/// 是否显示标题（默认不显示，显示时，页码pageControl对齐方式无效且右对齐）
@property (nonatomic, assign) BOOL showText;
/// 标题显示背景色（默认透明）
@property (nonatomic, strong) UIColor *textBgroundColor;
/// 标题字体景色（默认白色）
@property (nonatomic, strong) UIColor *textColor;

/// 是否显示showPageControl（默认显示）
@property (nonatomic, assign) BOOL showPageControl;

/// 是否显示删除按钮（默认隐藏）
@property (nonatomic, assign) BOOL showDeleteButton;

/// 图片删除（删除当前浏览的某一张图片）
@property (nonatomic, copy) void (^imageDelete)(NSInteger index);

/// 图片显示样式（等比例显示，或放大显示，默认放大）
@property (nonatomic, assign) SYImageBrowseContentModeMode imageContentMode;

/// 图片浏览定位（即当前显示第N张）
@property (nonatomic, assign) NSInteger pageIndex;

/// 自动播放（默认未启用，启用自动播放，或停止播放）
@property (nonatomic, assign) BOOL isAutoPlay;

/// 默认图片
@property (nonatomic, strong) UIImage *defaultImage;

@end
