//
//  SYImageBrowseHelper.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/11/8.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYImageBrowseView.h"
#import "SYImageBrowseScrollView.h"

// 使用SDWebImage
#import "UIImageView+WebCache.h"

/// 全屏宽度
#define SYImageBrowseWidth [UIScreen mainScreen].bounds.size.width
/// 全屏高度
#define SYImageBrowseHeight [UIScreen mainScreen].bounds.size.height

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


/// 浏览功能模式（广告轮播，或图片浏览）
typedef NS_ENUM(NSInteger, SYImageBrowseMode)
{
    /// 广告轮播
    SYImageBrowseAdvertisement = 1,
    
    /// 图片浏览
    SYImageBrowseViewShow = 2,
};

/// 图片显示样式（等比例显示，或放大显示，图片浏览功能下才有效）
typedef NS_ENUM(NSInteger, SYImageBrowseContentModeMode)
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

/// 页码pageControl对齐方式（居中，居右）
typedef NS_ENUM(NSInteger, SYImageBrowsePageControlAlignmentMode)
{
    /// 居中
    SYImageBrowsePageControlAlignmentCenter = 1,
    
    /// 居右
    SYImageBrowsePageControlAlignmentRight = 2,
};

/// 标题对齐方式（居左，居中，居右）
typedef NS_ENUM(NSInteger, SYImageBrowseTextAlignmentMode)
{
    /// 居左
    SYImageBrowseTextAlignmentLeft = 0,
    
    /// 居中
    SYImageBrowseTextAlignmentCenter = 1,
    
    /// 居右
    SYImageBrowseTextAlignmentRight = 2,
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
