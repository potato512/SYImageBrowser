//
//  SYImageBrowseHelper.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/11/8.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  github：https://github.com/potato512/SYImageBrowser

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SYImageBrowseUIImageView.h"
#import "SYImageBrowseScrollView.h"
#import "NSTimer+SYImageBrowse.h"

// 使用SDWebImage
#import "UIImageView+WebCache.h"

/// 弱引用
#define WeakSYImageBrowse __weak typeof(self) weakSYImageBrowse = self


/// 全屏宽度
#define SYImageBrowseWidth [UIScreen mainScreen].bounds.size.width
/// 全屏高度
#define SYImageBrowseHeight [UIScreen mainScreen].bounds.size.height

static CGFloat const SYImageBrowseOriginXY = 10.0;
/// 页码大小
static CGFloat const SYImageBrowseSizePage = 30.0;

/// 图片缩小比例
static CGFloat const SYImageBrowseScaleMin = 0.5;
/// 图片放大比例
static CGFloat const SYImageBrowseScaleMax = 2.0;


/// 图片类型（图片UIImage，图片名称NSString，图片地址http://...或https://....）
typedef NS_ENUM(NSInteger, SYImageType)
{
    /// 图片类型 图片UIImage
    SYImageTypeData = 1,
    
    /// 图片类型 图片名称NSString
    SYImageTypeName = 2,
    
    /// 图片类型 图片地址http://...或https://....
    SYImageTypeUrl = 3,
};

/// 浏览功能模式（广告轮播，或图片浏览。广告轮播时没有删除按钮属性）
typedef NS_ENUM(NSInteger, SYImageBrowseMode)
{
    /// 广告轮播
    SYImageBrowseAdvertisement = 1,
    
    /// 图片浏览
    SYImageBrowseViewShow = 2,
};

/// 广告图片的轮播模式（循环、不循环。非循环模式下自动播放无效）
typedef NS_ENUM(NSInteger, SYImageBrowseLoopType)
{
    /// 广告图片的轮播模式-循环
    SYImageBrowseLoopTypeTrue = 1,
    
    /// 广告图片的轮播模式-不循环
    SYImageBrowseLoopTypeFalse = 2,
};

/// 图片显示样式（等比例显示，或放大显示，图片浏览功能下才有效）
typedef NS_ENUM(NSInteger, SYImageBrowseContentMode)
{
    /// 等比例
    SYImageBrowseContentFit = 1,
    
    /// 放大
    SYImageBrowseContentFill = 2,
};

/// 页码显示样式（pageControl，或label）
typedef NS_ENUM(NSInteger, SYImageBrowsePageMode)
{
    /// pageControl
    SYImageBrowsePageControl = 1,
    
    /// pagelabel
    SYImageBrowsePagelabel = 2,
};

/// 删除按钮显示类型（不显示，显示文字标题，显示图标）
typedef NS_ENUM(NSInteger, SYImageBrowserDeleteType)
{
    /// 删除按钮显示类型-显示文字标题
    SYImageBrowserDeleteTypeText = 1,
    
    /// 删除按钮显示类型-显示图标
    SYImageBrowserDeleteTypeImage = 2
};

@interface SYImageBrowseHelper : NSObject

/// 获取图片类型
+ (SYImageType)getImageType:(id)object;


/// 改变字体大小及字体颜色，区分字体的颜色还是字体背景色
+ (void)AttributedString:(NSMutableAttributedString *)attributedStr
                    text:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(BOOL)bgColor;

/// 删除子视图
void SYImageBrowseRemoveSubViews(UIView *view);

@end
