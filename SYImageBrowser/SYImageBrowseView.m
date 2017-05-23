//
//  SYImageBrowseView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseView.h"
#import "SYImageBrowseViewLoopHand.h"
#import "SYImageBrowseViewLoopAuto.h"

#define widthImage (50.0 * self.frame.size.width / SYImageBrowseWidth)

@interface SYImageBrowseView ()

@property (nonatomic, strong) NSMutableArray *imagesTmp;
@property (nonatomic, strong) NSMutableArray *titlesTmp;

@property (nonatomic, strong) SYImageBrowseViewLoopAuto *loopAutoView;
@property (nonatomic, strong) SYImageBrowseViewLoopHand *loopHandView;

@property (nonatomic, strong) UIPageControl *pageControlTmp;
@property (nonatomic, strong) UILabel *textLabelTmp;
@property (nonatomic, strong) UILabel *pageLabelTmp;

@property (nonatomic, assign) NSInteger pageCount;    // 总页数
@property (nonatomic, assign) NSInteger currentPage;  // 当前页数

@property (nonatomic, strong) UIButton *buttonManager;
@property (nonatomic, strong) UIButton *buttonPrevious;
@property (nonatomic, strong) UIButton *buttonNext;

@property (nonatomic, strong) NSTimer *timerAnimation;

@end

@implementation SYImageBrowseView

#pragma mark - 视图初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        
        [self initializeUI];
        [self setUI];
        [self resetUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view
{
    self = [super init];
    if (self)
    {
        if (view)
        {
            [view addSubview:self];
        }
        self.frame = frame;
        
        [self initializeUI];
        [self setUI];
        [self resetUI];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ 被释放了", self);
}

#pragma mark - 视图

- (void)initializeUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    _loopType = SYImageBrowseLoopTypeTrue;
    _browseMode = SYImageBrowseAdvertisement;
    _imageContentMode = SYImageBrowseContentFill;
    _pageMode = SYImageBrowsePageControl;

    _showText = NO;

    _showButton = NO;
    
    _showSwitchButton = NO;
    
    _pageIndex = 0;
    
    _isAutoPlay = NO;
    _animationTime = 3.0;
}

// 图片视图
- (void)setUI
{
    [self addSubview:self.loopHandView];
    [self addSubview:self.loopAutoView];
    
    [self addSubview:self.pageControlTmp];
    [self addSubview:self.pageLabelTmp];
    [self addSubview:self.textLabelTmp];
    
    [self addSubview:self.buttonManager];
    [self addSubview:self.buttonPrevious];
    [self addSubview:self.buttonNext];
}

- (void)resetUI
{
    // scrollview
    self.loopAutoView.frame = self.bounds;
    self.loopHandView.frame = self.bounds;

    // buttonDelete
    
    // buttonPrevious
    self.buttonPrevious.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    // buttonNext
    self.buttonNext.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    self.loopHandView.hidden = YES;
    self.loopAutoView.hidden = NO;
    self.pageLabelTmp.hidden = YES;
    self.pageControlTmp.hidden = NO;
    self.textLabelTmp.hidden = YES;
    self.buttonManager.hidden = YES;
    self.buttonPrevious.hidden = YES;
    self.buttonNext.hidden = YES;
}

// 改变图片视图，标题
- (void)resetPageUI
{
    // 改变标题
    if (self.titlesTmp && 0 < self.titlesTmp.count)
    {
        if (self.currentPage <= (self.titlesTmp.count - 1))
        {
            // 避免数据源个数不统一时异常
            NSString *title = self.titlesTmp[self.currentPage];
            self.textLabelTmp.text = title;
        }
        else
        {
            self.textLabelTmp.text = @"";
        }
    }

    // 改变页码
    // pageControl
    self.pageControlTmp.currentPage = self.currentPage;
    // pagelabel
    [self resetPagelabelUI];
}

// 图片模式显示或隐藏设置
- (void)imageLoopShowSetting
{
    if (SYImageBrowseLoopTypeFalse == self.loopType)
    {
        self.loopHandView.hidden = NO;
        self.loopHandView.imageContentMode = self.imageContentMode;
        
        self.loopAutoView.hidden = YES;
    }
    else if (SYImageBrowseLoopTypeTrue == self.loopType)
    {
        self.loopHandView.hidden = YES;
        
        self.loopAutoView.hidden = NO;
        self.loopAutoView.imageContentMode = self.imageContentMode;
    }
}

// 设置有效的位置
- (void)validFrameWithView:(UIView *)view frame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, CGRectZero))
    {
        CGRect rect = view.frame;
        rect.origin.x = frame.origin.x;
        if (rect.origin.x >= self.frame.size.width)
        {
            rect.origin.x = self.frame.size.width - rect.size.width;
        }
        rect.origin.y = frame.origin.y;
        if (rect.origin.y >= self.frame.size.height)
        {
            rect.origin.y = self.frame.size.height - rect.size.height;
        }
        if ([view isEqual:self.pageControlTmp])
        {
            if (rect.size.width <= frame.size.width)
            {
                rect.size.width = frame.size.width;
                if (rect.size.width >= self.frame.size.width)
                {
                    rect.size.width = self.frame.size.width - rect.origin.x;
                }
            }
        }
        else
        {
            rect.size.width = frame.size.width;
            if (rect.size.width >= self.frame.size.width)
            {
                rect.size.width = self.frame.size.width - rect.origin.x;
            }
        }
        rect.size.height = frame.size.height;
        if (rect.size.height >= self.frame.size.height)
        {
            rect.size.height = self.frame.size.height - rect.origin.y;
        }
        view.frame = rect;
    }
}

// 设置页码控制器隐藏或显示
- (void)pageShowSetting
{
    if (SYImageBrowsePageControl == self.pageMode)
    {
        self.pageLabelTmp.hidden = YES;
        self.pageLabelTmp.alpha = 0.0;
        
        self.pageControlTmp.hidden = NO;
        self.pageControlTmp.alpha = 1.0;
    }
    else if (SYImageBrowsePagelabel == self.pageMode)
    {
        self.pageLabelTmp.hidden = NO;
        self.pageLabelTmp.alpha = 1.0;
        
        // pagelabel，默认右下角
        self.pageLabelTmp.frame = CGRectMake((self.frame.size.width - SYImageBrowseSizePage - SYImageBrowseOriginXY), (self.frame.size.height - SYImageBrowseSizePage - SYImageBrowseOriginXY), SYImageBrowseSizePage, SYImageBrowseSizePage);
        [self validFrameWithView:self.pageLabelTmp frame:self.pageLabelFrame];
        
        self.pageControlTmp.hidden = YES;
        self.pageControlTmp.alpha = 0.0;
    }
    
    if (self.showText)
    {
        self.textLabelTmp.hidden = NO;
        self.textLabelTmp.alpha = 1.0;
        
        // textlabel，默认左下角
        self.textLabelTmp.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - SYImageBrowseSizePage), (self.frame.size.width - SYImageBrowseOriginXY * 2), SYImageBrowseSizePage);
        [self validFrameWithView:self.textLabelTmp frame:self.textLabelFrame];
    }
    else
    {
        self.textLabelTmp.hidden = YES;
        self.textLabelTmp.alpha = 0.0;
    }
}

// 设置按钮隐藏或显示等属性
- (void)buttonShowSetting
{
    self.buttonManager.hidden = YES;
    if (self.showButton && SYImageBrowseViewShow == self.browseMode)
    {
        self.buttonManager.hidden = NO;
        
        UIImage *deleteImage = [self.buttonManager backgroundImageForState:UIControlStateNormal];
        CGFloat heightImage = deleteImage.size.height * widthImage / deleteImage.size.width;
        self.buttonManager.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), SYImageBrowseOriginXY, widthImage, heightImage);
    }
    
    self.buttonPrevious.hidden = !self.showSwitchButton;
    if (self.imagePrevious)
    {
        [self.buttonPrevious setImage:self.imagePrevious forState:UIControlStateNormal];
        [self.buttonPrevious setTitle:@"" forState:UIControlStateNormal];
    }
    if (self.imagePreviousHighlight)
    {
        [self.buttonPrevious setImage:self.imagePreviousHighlight forState:UIControlStateHighlighted];
        [self.buttonPrevious setTitle:@"" forState:UIControlStateNormal];
    }
    
    self.buttonNext.hidden = !self.showSwitchButton;
    if (self.imageNext)
    {
        [self.buttonNext setImage:self.imageNext forState:UIControlStateHighlighted];
        [self.buttonNext setTitle:@"" forState:UIControlStateNormal];
    }
    if (self.imageNextHighlight)
    {
        [self.buttonNext setImage:self.imageNextHighlight forState:UIControlStateHighlighted];
        [self.buttonNext setTitle:@"" forState:UIControlStateNormal];
    }
}

// 改变页码pageControl位置
- (void)resetPageControlUI
{
    // pageControl，默认右下角
    CGFloat widthPageControl = self.pageCount * (SYImageBrowseSizePage / 1.6);
    self.pageControlTmp.frame = CGRectMake((self.frame.size.width - widthPageControl), (self.frame.size.height - SYImageBrowseSizePage), widthPageControl, SYImageBrowseSizePage);
    [self validFrameWithView:self.pageControlTmp frame:self.pageControlFrame];
}

// 改变页码pagelabel的字段颜色
- (void)resetPagelabelUI
{
    self.pageLabelTmp.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (self.currentPage + 1), self.pageCount];
}

#pragma mark - 响应事件

- (void)managerClick
{
    // 回调处理
    if (self.imageManager)
    {
        self.imageManager(SYImageBrowseButtonTypeDelete, self.currentPage);
    }
    
     /*
    // 改变图片源
    [self.imagesTmp removeObjectAtIndex:self.currentPage];
    // 改变标题源
    [self.titlesTmp removeObjectAtIndex:self.currentPage];
    // 总页数
    self.pageCount = self.imagesTmp.count;
    // 改变当前页
    if (self.currentPage >= self.pageCount - 1)
    {
        self.currentPage = (1 == self.pageCount ? 0 : (self.pageCount - 1));
    }
    // 重置视图
    if (1 <= self.pageCount)
    {
        [self resetPageUI];
    }
    else
    {
        [self removeFromSuperview];
    }
    // 重置页码
    self.pageControlTmp.numberOfPages = self.pageCount;
    self.pageControlTmp.currentPage = self.currentPage;
    self.pageControlTmp.hidden = (1 == self.pageCount ? YES : NO);
    
    if (self.loopHandView.hidden)
    {
        self.loopAutoView.images = self.imagesTmp;
        self.loopAutoView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopHandView.images = self.imagesTmp;
        self.loopHandView.pageIndex = self.currentPage;
    }
    */
}

- (void)previousClick
{
    if ((0 == self.currentPage && self.loopAutoView.hidden) || 1 == self.images.count)
    {
        return;
    }
    
    // 向右翻页
    self.currentPage--;
    self.currentPage = (self.currentPage < 0 ? (self.pageCount - 1) : self.currentPage);
    [self resetPageUI];
    // 改变offset
    if (self.loopHandView.hidden)
    {
        self.loopAutoView.isDirectionRight = NO;
        self.loopAutoView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopHandView.pageIndex = self.currentPage;
    }
    NSLog(@"- currentPage = %@", @(self.currentPage));
}

- (void)nextClick
{
    if (((self.pageCount - 1) == self.currentPage && self.loopAutoView.hidden) || 1 == self.images.count)
    {
        return;
    }
    
    // 向左翻页
    self.currentPage++;
    self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
    [self resetPageUI];
    // 改变offset
    if (self.loopHandView.hidden)
    {
        self.loopAutoView.isDirectionRight = YES;
        self.loopAutoView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopHandView.pageIndex = self.currentPage;
    }
    NSLog(@"+ currentPage = %@", @(self.currentPage));
}

- (void)pressDownClick
{
    NSLog(@"down press");
    
    if (self.loopHandView.hidden)
    {
        [self.loopAutoView autoPlayStatus:NO];
    }
}

- (void)pressUpClick
{
    NSLog(@"up press");
    
    if (self.loopHandView.hidden)
    {
        [self.loopAutoView autoPlayStatus:YES];
    }
}


- (void)reloadData
{
    [self resetUI];
    
    // 重新刷新信息
    [self imageLoopShowSetting];
    [self pageShowSetting];
    [self buttonShowSetting];

    if (SYImageBrowseAdvertisement == self.browseMode)
    {
        // 可以点击跳转其他视图，可以设置自动播放，可以循环播放
        // 不能点击退出浏览，不能有删除按钮，不能定位第N张图片
        
        self.showButton = NO;
        self.pageIndex = 0;
    }
    else if (SYImageBrowseViewShow == _browseMode)
    {
        // 不可以点击跳转其他视图，不可以自动播
        // 可以点击退出浏览，可以有删除按钮，可以定位第N张图片，可以循环播放
        
        self.isAutoPlay = NO;
    }
    
    if (self.images && 0 < self.images.count)
    {
        self.imagesTmp = [[NSMutableArray alloc] initWithArray:self.images];
        self.pageCount = self.imagesTmp.count;
        self.currentPage = 0;
    }

    // 设置页码
    // 1 pageControlTmp
    self.pageControlTmp.numberOfPages = self.pageCount;
    self.pageControlTmp.currentPage = self.currentPage;
    self.pageControlTmp.hidden = (1 == self.pageCount ? YES : NO);
    // 2
    if (SYImageBrowseAdvertisement == self.browseMode)
    {
        self.pageIndex = 0;
    }
    if (0 != self.pageIndex)
    {
        NSInteger index = self.pageIndex - 1;
        self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
    }
    // 3
    if ((self.titles && 0 < self.titles.count) && (self.titles.count == self.images.count))
    {
        self.titlesTmp = [[NSMutableArray alloc] initWithArray:self.titles];
        NSString *title = self.titlesTmp[self.currentPage];
        self.textLabelTmp.text = title;
    }
    // 4
    // 改变图片视图，标题
    [self resetPageUI];
    // pagelabel
    [self resetPagelabelUI];
    // pageControl
    [self resetPageControlUI];
    // 5
    if (self.loopHandView.hidden)
    {
        self.loopAutoView.images = self.imagesTmp;
        self.loopAutoView.pageIndex = self.currentPage;
        self.loopAutoView.isAutoPlay = self.isAutoPlay;
        [self.loopAutoView reloadData];
    }
    else
    {
        self.loopHandView.images = self.imagesTmp;
        self.loopHandView.pageIndex = self.currentPage;
        [self.loopHandView reloadData];
    }
}

#pragma mark - getter

- (SYImageBrowseViewLoopHand *)loopHandView
{
    if (!_loopHandView)
    {
        _loopHandView = [[SYImageBrowseViewLoopHand alloc] initWithFrame:self.bounds];
        _loopHandView.backgroundColor = [UIColor clearColor];
        
        WeakSYImageBrowse;
        _loopHandView.imageScroll = ^(NSInteger index){
            weakSYImageBrowse.currentPage = index;
            // 改变图片视图，标题
            [weakSYImageBrowse resetPageUI];
        };
        _loopHandView.imageClick = ^(NSInteger index){
            if (weakSYImageBrowse.imageClick)
            {
                weakSYImageBrowse.imageClick(index);
            }
        };
    }
    
    return _loopHandView;
}

- (SYImageBrowseViewLoopAuto *)loopAutoView
{
    if (!_loopAutoView)
    {
        _loopAutoView = [[SYImageBrowseViewLoopAuto alloc] initWithFrame:self.bounds];
        _loopAutoView.backgroundColor = [UIColor clearColor];
        
        WeakSYImageBrowse;
        _loopAutoView.imageScroll = ^(NSInteger index){
            weakSYImageBrowse.currentPage = index;
            // 改变图片视图，标题
            [weakSYImageBrowse resetPageUI];
        };
        _loopAutoView.imageClick = ^(NSInteger index){
            if (weakSYImageBrowse.imageClick)
            {
                weakSYImageBrowse.imageClick(index);
            }
        };
        _loopAutoView.imageAutoScroll = ^(NSInteger index){
            weakSYImageBrowse.currentPage = index;
            // 改变图片视图，标题
            [weakSYImageBrowse resetPageUI];
        };
    }
    
    return _loopAutoView;
}

- (UIPageControl *)pageControlTmp
{
    if (!_pageControlTmp)
    {
        _pageControlTmp = [[UIPageControl alloc] init];
        _pageControlTmp.backgroundColor = [UIColor clearColor];
        
        _pageControlTmp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    return _pageControlTmp;
}

- (UILabel *)pageLabelTmp
{
    if (!_pageLabelTmp)
    {
        _pageLabelTmp = [[UILabel alloc] init];
        _pageLabelTmp.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        _pageLabelTmp.textColor = [UIColor whiteColor];
        _pageLabelTmp.textAlignment = NSTextAlignmentCenter;
        _pageLabelTmp.font = [UIFont systemFontOfSize:12.0];
        
        _pageLabelTmp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _pageLabelTmp.layer.cornerRadius = SYImageBrowseSizePage / 2;
        _pageLabelTmp.layer.masksToBounds = YES;
    }
    
    return _pageLabelTmp;
}

- (UILabel *)textLabelTmp
{
    if (!_textLabelTmp)
    {
        _textLabelTmp = [[UILabel alloc] init];
        _textLabelTmp.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _textLabelTmp.textColor = [UIColor whiteColor];
        
        _textLabelTmp.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _textLabelTmp.textColor = [UIColor whiteColor];
        _textLabelTmp.textAlignment = NSTextAlignmentCenter;
        _textLabelTmp.font = [UIFont systemFontOfSize:12.0];
    }
    
    return _textLabelTmp;
}

- (UIButton *)buttonManager
{
    if (!_buttonManager)
    {
        _buttonManager = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonManager.backgroundColor = [UIColor clearColor];
        UIImage *deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
        [_buttonManager setBackgroundImage:deleteImage forState:UIControlStateNormal];
        [_buttonManager addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonManager;
}

- (UIButton *)buttonPrevious
{
    if (!_buttonPrevious)
    {
        _buttonPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonPrevious.backgroundColor = [UIColor clearColor];
        [_buttonPrevious setTitle:@"<" forState:UIControlStateNormal];
        [_buttonPrevious setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonPrevious setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _buttonPrevious.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [_buttonPrevious addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchDown];
        [_buttonPrevious addTarget:self action:@selector(pressDownClick) forControlEvents:UIControlEventTouchDown];
        [_buttonPrevious addTarget:self action:@selector(pressUpClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonPrevious;
}

- (UIButton *)buttonNext
{
    if (!_buttonNext)
    {
        _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonNext.backgroundColor = [UIColor clearColor];
        [_buttonNext setTitle:@">" forState:UIControlStateNormal];
        [_buttonNext setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonNext setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        _buttonNext.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [_buttonNext addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchDown];
        [_buttonNext addTarget:self action:@selector(pressDownClick) forControlEvents:UIControlEventTouchDown];
        [_buttonNext addTarget:self action:@selector(pressUpClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonNext;
}

- (CGFloat)currentOffX
{
    return CGRectGetWidth(self.bounds);
}

- (UIPageControl *)pageControl
{
    return self.pageControlTmp;
}

- (UILabel *)pageLabel
{
    return self.pageLabelTmp;
}

- (UILabel *)textLabel
{
    return self.textLabelTmp;
}

@end
