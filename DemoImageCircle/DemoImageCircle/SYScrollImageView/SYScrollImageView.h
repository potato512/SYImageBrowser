//
//  SYScrollImageView.h
//  zhangshaoyu
//
//  Created by herman on 2017/5/24.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 页码控制器样式
typedef NS_ENUM(NSInteger, PageControlType)
{
    UIPageControlType = 1,
    
    UILabelControlType = 2,
};

/// 图片自动播放，或手势拖动切换
typedef NS_ENUM(NSInteger, ImageShowType)
{
    ImageShowRunloopType = 1,
    
    ImageShowNormalType = 2,
};

/// 图片内容显示模式
typedef NS_ENUM(NSInteger, ImageContentType)
{
    ImageContentAspectFitType = 1,
    
    ImageContentAspectFillType = 2,
};

@interface SYScrollImageView : UIView

/// 数据源
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

/// 默认不显示标题
@property (nonatomic, assign) BOOL showTitle;
/// 默认显示顶端居中
@property (nonatomic, strong) UILabel *titleLabel;

/// 默认UIPageControlType
@property (nonatomic, assign) PageControlType pageType;
/// 默认显示底端居中
@property (nonatomic, strong) UIPageControl *pageControl;
/// 默认显示底端居右
@property (nonatomic, strong) UILabel *pageLabel;

/// 自动播放（默认非自动播放；自动播放时在ImageShowRunloopType模式下有效；默认3.0秒）
@property (nonatomic, assign) BOOL isAutoPlay;
@property (nonatomic, assign) NSTimeInterval animationTime;

/// 默认ImageShowNormalType
@property (nonatomic, assign) ImageShowType showType;
/// 默认ImageContentAspectFillType
@property (nonatomic, assign) ImageContentType contentMode;

/// 点击回调
@property (nonatomic, copy) void (^imageClick)(NSInteger index);

/// 切换按钮
/// 是否显示（默认不显示）
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;

/// 数据刷新
- (void)reloadData;

@end
