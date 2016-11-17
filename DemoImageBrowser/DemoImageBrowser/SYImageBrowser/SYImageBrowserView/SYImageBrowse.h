//
//  SYImageBrowse.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  图片浏览，图片广告功能封装（https://github.com/potato512/SYImageBrowser）

/*
 1、广告轮播
 1-1 自动播放
 1-2 手动翻看
 1-3 点击响应
 1-3-1 跳转其他视图
 
 2、图片浏览
 2-1 手动翻看
 2-2 删除
 2-3 定位第N张
 2-4 点击响应
 2-4-1 退出图片浏览
 2-5 图片显示（等比例，或全屏）
 
 3、显示样式
 3-1 页码显示（即多个小点样式）
 3-1-1 页码显示位置
 3-1-2 页码显示颜色（当前页码颜色，未选择页码颜色）
 3-2 图片标题
 3-2-1 标题显示位置
 3-3 页数显示（即1/N样式）
 
 
 图片拿捏放大缩小显示
 图片双击放大缩小显示
 
 
 使用示例
 NSArray *images = @[@"01.jpg", @"02.jpg", @"03.jpg", @"04.jpg", @"05.jpg", @"06.jpg"];
 NSArray *titles = @[@"01.jpg", @"02.jpg", @"03.jpg", @"04.jpg", @"05.jpg", @"06.jpg"];
 
 CGRect rect = self.view.bounds;
 SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
 imageBrowse.showText = YES;
 imageBrowse.isAutoPlay = YES;
 imageBrowse.showPageControl = NO;
 imageBrowse.imageSource = images;
 imageBrowse.titleSource = titles;
 imageBrowse.pageIndex = 3;
 imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
 imageBrowse.imageSelected = ^(NSInteger index){
        NSLog(@"imageSelected %ld", index);
 };
 imageBrowse.browseMode = ImageBrowseAdvertisement;
 imageBrowse.textMode = textAlignmentCenter;
 imageBrowse.pageMode = ImagePageControl;
 imageBrowse.pageAlignmentMode = pageControlAlignmentCenter;
 imageBrowse.pageNormalColor = [UIColor redColor];
 imageBrowse.pageSelectedColor = [UIColor greenColor];
 imageBrowse.showDeleteButton = YES;
 imageBrowse.imageDelete = ^(NSInteger index){
    NSLog(@"imageDelete %ld", index);
 };
 imageBrowse.imageContentMode = ImageContentFill;
 
*/

#import <UIKit/UIKit.h>
#import "SYImageBrowseViewController.h"

/// 浏览功能模式（广告轮播，或图片浏览）
typedef NS_ENUM(NSInteger, ImageBrowseMode)
{
    /// 广告轮播
    ImageBrowseAdvertisement = 1,
    
    /// 图片浏览
    ImageBrowseView = 2,
};

/// 图片显示样式（等比例显示，或放大显示，图片浏览功能下才有效）
typedef NS_ENUM(NSInteger, ImageContentModeMode)
{
    /// 等比例
    ImageContentFit = 1,
    
    /// 放大
    ImageContentFill = 2,
};

/// 页码显示样式（pageControl，或label）
typedef NS_ENUM(NSInteger, ImagePageMode)
{
    /// pageControl
    ImagePageControl = 1,
    
    /// pagelabel
    ImagePagelabel = 2,
};

/// 页码pageControl对齐方式（居中，居右）
typedef NS_ENUM(NSInteger, PageControlAlignmentMode)
{
    /// 居中
    pageControlAlignmentCenter = 1,
    
    /// 居右
    pageControlAlignmentRight = 2,
};

/// 标题对齐方式（居左，居中，居右）
typedef NS_ENUM(NSInteger, TextAlignmentMode)
{
    /// 居左
    textAlignmentLeft = 0,
    
    /// 居中
    textAlignmentCenter = 1,
    
    /// 居右
    textAlignmentRight = 2,
};

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
@property (nonatomic, assign) ImageBrowseMode browseMode;

/// 页码样式（pageControl，或pagelabel，默认pageControl）
@property (nonatomic, assign) ImagePageMode pageMode;

/// 页码pageControl对齐方式（居中，居右，当标题可见时默认居右）
@property (nonatomic, assign) PageControlAlignmentMode pageAlignmentMode;

/// 页码pageControl，或pagelabel当前页码颜色
@property (nonatomic, strong) UIColor *pageSelectedColor;

/// 页码pageControl，或pagelabel常态颜色
@property (nonatomic, strong) UIColor *pageNormalColor;

/// 是否显示标题（默认不显示，显示时，页码pageControl对齐方式无效且右对齐）
@property (nonatomic, assign) BOOL showText;

/// 是否显示showPageControl（默认显示）
@property (nonatomic, assign) BOOL showPageControl;

/// 标题对齐方式（居左，居中，居右，默认左对齐）
@property (nonatomic, assign) TextAlignmentMode textMode;

/// 是否显示删除按钮（默认隐藏）
@property (nonatomic, assign) BOOL showDeleteButton;

/// 图片删除（删除当前浏览的某一张图片）
@property (nonatomic, copy) void (^imageDelete)(NSInteger index);

/// 图片显示样式（等比例显示，或放大显示，默认放大）
@property (nonatomic, assign) ImageContentModeMode imageContentMode;

/// 图片浏览定位（即当前显示第N张）
@property (nonatomic, assign) NSInteger pageIndex;

/// 自动播放（默认未启用，启用自动播放，或停止播放）
@property (nonatomic, assign) BOOL isAutoPlay;

/// 默认图片
@property (nonatomic, strong) UIImage *defaultImage;

@end
