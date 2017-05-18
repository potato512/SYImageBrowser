//
//  SYImageBrowseView.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseView.h"
#import "SYImageBrowseViewLoopFalse.h"
#import "SYImageBrowseViewLoopTrue.h"

#define widthImage (50.0 * self.frame.size.width / SYImageBrowseWidth)

/*
@interface SYImageBrowseView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imagesTmp;
@property (nonatomic, strong) NSMutableArray *titlesTmp;

@property (nonatomic, strong) SYImageBrowseViewLoopTrue *loopTrueView;
@property (nonatomic, strong) SYImageBrowseViewLoopFalse *loopFalseView;

@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) SYImageBrowseScrollView *firstImageView;
@property (nonatomic, strong) SYImageBrowseScrollView *secondImageView;
@property (nonatomic, strong) SYImageBrowseScrollView *thirdImageView;

@property (nonatomic, strong) UIPageControl *pageControlTmp;
@property (nonatomic, strong) UILabel *textLabelTmp;
@property (nonatomic, strong) UILabel *pageLabelTmp;

@property (nonatomic, assign) NSInteger pageCount;    // 总页数
@property (nonatomic, assign) NSInteger currentPage;  // 当前页数
@property (nonatomic, assign) CGFloat currentOffX;    // 当前偏移量

@property (nonatomic, strong) id firstImage;
@property (nonatomic, strong) id secondImage;
@property (nonatomic, strong) id thirdImage;

@property (nonatomic, strong) UIButton *buttonDelete;
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
        [self initializeUI];
        [self setUI];
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
    [self stopTimer];
    NSLog(@"%@ 被释放了", self);
}

#pragma mark - 视图

- (void)initializeUI
{
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    _loopType = SYImageBrowseLoopTypeTrue;
    _browseMode = SYImageBrowseAdvertisement;
    _imageContentMode = SYImageBrowseContentFill;
    _pageMode = SYImageBrowsePageControl;
    
    _pageControlPoint = CGPointMake(SYImageBrowseOriginXY, SYImageBrowseOriginXY);
    _pageLabelPoint = CGPointMake((self.frame.size.width - SYImageBrowseSizePage - SYImageBrowseOriginXY), (self.frame.size.height - SYImageBrowseSizePage - SYImageBrowseOriginXY));
    
    _showText = NO;
    _textLabelPoint = CGPointMake(SYImageBrowseOriginXY, (self.frame.size.height - SYImageBrowseSizePage) / 2);
    
    _showDeleteButton = NO;
    
    _showSwitchButton = NO;
    
    _pageIndex = 0;
    
    _isAutoPlay = NO;
    _animationTime = 3.0;
}

// 图片视图
- (void)setUI
{
    [self addSubview:self.imageScrollView];
    [self addSubview:self.pageControlTmp];
    [self addSubview:self.pageLabelTmp];
    [self addSubview:self.textLabelTmp];
    
    [self addSubview:self.buttonDelete];
    [self addSubview:self.buttonPrevious];
    [self addSubview:self.buttonNext];
}

- (void)resetUI
{
    // scrollview
    self.imageScrollView.frame = self.bounds;
    self.imageScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.imageScrollView.contentOffset = CGPointMake(self.frame.size.width, 0.0);
    
    self.firstImageView.frame = CGRectMake(0.0, 0.0, self.imageScrollView.bounds.size.width,self.imageScrollView.bounds.size.height);
    self.secondImageView.frame = CGRectMake(self.imageScrollView.bounds.size.width, 0.0, self.imageScrollView.bounds.size.width, self.imageScrollView.bounds.size.height);
    self.thirdImageView.frame = CGRectMake(self.imageScrollView.bounds.size.width * 2, 0.0, self.imageScrollView.bounds.size.width, self.imageScrollView.bounds.size.height);
    
    // pageControl
    self.pageControlTmp.frame = CGRectMake(0.0, (self.frame.size.height - SYImageBrowseSizePage), self.frame.size.width, SYImageBrowseSizePage);
    
    // pagelabel
    self.pageLabelTmp.frame = CGRectMake((self.frame.size.width - SYImageBrowseSizePage - SYImageBrowseOriginXY), (self.frame.size.height - SYImageBrowseSizePage - SYImageBrowseOriginXY), SYImageBrowseSizePage, SYImageBrowseSizePage);

    // textlabel
    self.textLabelTmp.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - SYImageBrowseSizePage) / 2, (self.frame.size.width - SYImageBrowseOriginXY * 2), SYImageBrowseSizePage);

    // buttonDelete
    
    // buttonPrevious
    self.buttonPrevious.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    // buttonNext
    self.buttonNext.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    self.pageLabelTmp.hidden = YES;
    self.pageControlTmp.hidden = NO;
    self.textLabelTmp.hidden = YES;
    self.buttonDelete.hidden = YES;
    self.buttonPrevious.hidden = YES;
    self.buttonNext.hidden = YES;
}

// 改变图片视图，标题
- (void)resetPageUI
{
    // 改变标题
    if (_titlesTmp && 0 < _titlesTmp.count)
    {
        if (_currentPage <= (_titlesTmp.count - 1))
        {
            // 避免数据源个数不统一时异常
            NSString *title = _titlesTmp[_currentPage];
            self.textLabelTmp.text = title;
        }
        else
        {
            self.textLabelTmp.text = @"";
        }
    }
    
    [self pageShowSetting];
    // 改变页码
    // pageControl
    self.pageControlTmp.currentPage = _currentPage;
    // pagelabel
    [self resetPagelabelUI];
    
    // 改变图片
    NSInteger firstIndex = _currentPage - 1;
    firstIndex = (firstIndex < 0 ? (_pageCount - 1) : firstIndex);
    id imageObjectFirst = _imagesTmp[firstIndex];
    id imageObjectSecond = _imagesTmp[_currentPage];
    NSInteger lastIndex = _currentPage + 1;
    lastIndex = (lastIndex >= _pageCount ? 0 : lastIndex);
    id imageObjectThird = _imagesTmp[lastIndex];
    
    self.firstImage = imageObjectFirst;
    self.secondImage = imageObjectSecond;
    self.thirdImage = imageObjectThird;
    // SDWebImage
    [self.firstImageView.imageBrowseView setImage:self.firstImage defaultImage:self.defaultImage];
    [self.secondImageView.imageBrowseView setImage:self.secondImage defaultImage:self.defaultImage];
    [self.thirdImageView.imageBrowseView setImage:self.thirdImage defaultImage:self.defaultImage];
}

// 设置页码控制器隐藏或显示
- (void)pageShowSetting
{
    if (SYImageBrowsePageControl == _pageMode)
    {
        self.pageLabelTmp.hidden = YES;
        self.pageLabelTmp.alpha = 0.0;
        
        self.pageControlTmp.hidden = NO;
        self.pageControlTmp.alpha = 1.0;
    }
    else if (SYImageBrowsePagelabel == _pageMode)
    {
        self.pageLabelTmp.hidden = NO;
        self.pageLabelTmp.alpha = 1.0;
        
        self.pageControlTmp.hidden = YES;
        self.pageControlTmp.alpha = 0.0;
    }
}

// 改变页码pageControl位置
- (void)resetPageControlUI
{
    CGFloat widthPageControl = _pageCount * (SYImageBrowseSizePage / 1.6);
    
    CGRect rectPageControl = self.pageControlTmp.frame;
    rectPageControl.origin.x = _pageControlPoint.x;
    rectPageControl.origin.y = _pageControlPoint.y;
    rectPageControl.size.width = widthPageControl;
    self.pageControlTmp.frame = rectPageControl;
}

// 改变页码pagelabel的字段颜色
- (void)resetPagelabelUI
{
    self.pageLabelTmp.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (_currentPage + 1), _pageCount];
}

#pragma mark - 响应事件

- (void)currentImageClick
{
    if (self.imageSelected)
    {
        self.imageSelected(_currentPage);
    }
}

- (void)deleteClick
{
    // 回调处理
    if (self.imageDelete)
    {
        self.imageDelete(_currentPage);
    }
    
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
        // 设置滚动响应
        self.imageScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
    }
    else
    {
        [self removeFromSuperview];
    }
    // 重置页码
    self.pageControlTmp.numberOfPages = self.pageCount;
    self.pageControlTmp.currentPage = self.currentPage;
    self.pageControlTmp.hidden = (1 == self.pageCount ? YES : NO);
}

- (void)previousClick
{
    // 向右翻页
    self.currentPage--;
    self.currentPage = (self.currentPage < 0 ? (self.pageCount - 1) : self.currentPage);
    [self resetPageUI];
    // 改变offset
    [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.frame.size.width, 0.0) animated:NO];
}

- (void)nextClick
{
    // 向左翻页
    self.currentPage++;
    self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
    [self resetPageUI];
    // 改变offset
    [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.frame.size.width, 0.0) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (SYImageBrowseViewShow == _browseMode)
    {
        self.secondImageView.isOriginal = YES;
    }
    
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isAutoPlay && SYImageBrowseLoopTypeTrue == _loopType)
    {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView)
    {
        CGFloat offX = self.imageScrollView.contentOffset.x;
        if (offX == self.currentOffX)
        {
            // 翻页不完全时，不响应
            return;
        }
        else if (offX >= self.currentOffX)
        {
            // 向左翻页
            self.currentPage++;
            self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
        }
        else if (offX < self.currentOffX)
        {
            // 向右翻页
            self.currentPage--;
            self.currentPage = (self.currentPage < 0 ? (self.pageCount - 1) : self.currentPage);
        }
        
        [self resetPageUI];
        
        // 改变offset
        [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.frame.size.width, 0.0) animated:NO];
    }
}

#pragma mark - getter

- (UIScrollView *)imageScrollView
{
    if (!_imageScrollView)
    {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.scrollEnabled = YES;
        
        _imageScrollView.delegate = self;
    }
    
    return _imageScrollView;
}

// SDWebImage SYImageBrowseScrollView/SYImageBrowseView

- (SYImageBrowseScrollView *)firstImageView
{
    if (!_firstImageView)
    {
        _firstImageView = [[SYImageBrowseScrollView alloc] init];
        _firstImageView.backgroundColor = [UIColor clearColor];
        _firstImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.imageScrollView addSubview:_firstImageView];
        _firstImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _firstImageView.isDoubleEnable = NO;
    }
    
    return _firstImageView;
}

- (SYImageBrowseScrollView *)secondImageView
{
    if (!_secondImageView)
    {
        _secondImageView = [[SYImageBrowseScrollView alloc] init];
        _secondImageView.backgroundColor = [UIColor clearColor];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.imageScrollView addSubview:_secondImageView];
        _secondImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _secondImageView.isDoubleEnable = NO;
        
        SYImageBrowseView __weak *weakSelf = self;
        _secondImageView.imageBrowseView.imageClick = ^(){
            [weakSelf currentImageClick];
        };
    }
    
    return _secondImageView;
}

- (SYImageBrowseScrollView *)thirdImageView
{
    if (!_thirdImageView)
    {
        _thirdImageView = [[SYImageBrowseScrollView alloc] init];
        _thirdImageView.backgroundColor = [UIColor clearColor];
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFit;

        [self.imageScrollView addSubview:_thirdImageView];
        _thirdImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _thirdImageView.isDoubleEnable = NO;
    }
    
    return _thirdImageView;
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

- (UIButton *)buttonDelete
{
    if (!_buttonDelete)
    {
        UIImage *deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
        CGFloat heightImage = deleteImage.size.height * widthImage / deleteImage.size.width;
        _buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonDelete.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), SYImageBrowseOriginXY, widthImage, heightImage);
        _buttonDelete.backgroundColor = [UIColor clearColor];
        [_buttonDelete setBackgroundImage:deleteImage forState:UIControlStateNormal];
        [_buttonDelete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonDelete;
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
        
        [_buttonPrevious addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
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
        
        [_buttonNext addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonNext;
}


- (CGFloat)currentOffX
{
    return CGRectGetWidth(self.imageScrollView.bounds);
}

- (UIPageControl *)pageControl
{
    return self.pageControlTmp;
}

- (UILabel *)pageLabel
{
    return self.pageLabelTmp;
}

#pragma mark - setter

- (void)setImages:(NSArray *)images
{
    _images = images;
    if (_images && 0 < _images.count)
    {
        self.imagesTmp = [[NSMutableArray alloc] initWithArray:_images];
        self.pageCount = self.imagesTmp.count;
        self.currentPage = 0;
        
        // 设置页码
        // 1 pageControlTmp
        self.pageControlTmp.numberOfPages = self.pageCount;
        self.pageControlTmp.currentPage = self.currentPage;
        self.pageControlTmp.hidden = (1 == self.pageCount ? YES : NO);
        // 2 pagelabel
        [self resetPagelabelUI];
        // 3 pageControl
        [self resetPageControlUI];
        
        if (0 != self.pageIndex)
        {
            NSInteger index = self.pageIndex - 1;
            self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
            
            // 设置滚动响应
            self.imageScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
            
            // 改变图片视图，标题
            [self resetPageUI];
        }
        else
        {
            // 设置滚动响应
            self.imageScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
            
            if (1 >= self.pageCount)
            {
                id imageObject = self.imagesTmp.firstObject;
                
                self.secondImage = imageObject;
            }
            else
            {
                id imageObjectFirst = self.imagesTmp.lastObject;
                id imageObjectSecond = self.imagesTmp.firstObject;
                id imageObjectThird = self.imagesTmp[1];
                
                self.firstImage = imageObjectFirst;
                self.secondImage = imageObjectSecond;
                self.thirdImage = imageObjectThird;
            }
            
            // SDWebImage
            [self.firstImageView.imageBrowseView setImage:self.firstImage defaultImage:self.defaultImage];
            [self.secondImageView.imageBrowseView setImage:self.secondImage defaultImage:self.defaultImage];
            [self.thirdImageView.imageBrowseView setImage:self.thirdImage defaultImage:self.defaultImage];
        }
        
        if (self.isAutoPlay && SYImageBrowseLoopTypeTrue == _loopType)
        {
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:_animationTime];
//            [self startTimer];
        }
    }
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    if ((_titles && 0 < _titles.count) && (_titles.count == _images.count))
    {
        self.titlesTmp = [[NSMutableArray alloc] initWithArray:_titles];
        NSString *title = self.titlesTmp[self.currentPage];
        self.textLabelTmp.text = title;
    }
}

- (void)setBrowseMode:(SYImageBrowseMode)browseMode
{
    _browseMode = browseMode;
    if (SYImageBrowseAdvertisement == _browseMode)
    {
        // 可以点击跳转其他视图，可以设置自动播放，可以循环播放
        // 不能点击退出浏览，不能有删除按钮，不能定位第N张图片
        
        self.showDeleteButton = NO;
        self.pageIndex = 0;
    }
    else if (SYImageBrowseViewShow == _browseMode)
    {
        // 不可以点击跳转其他视图，不可以自动播
        // 可以点击退出浏览，可以有删除按钮，可以定位第N张图片，可以循环播放
        
        self.isAutoPlay = NO;
        
        self.firstImageView.isDoubleEnable = YES;
        self.secondImageView.isDoubleEnable = YES;
        self.thirdImageView.isDoubleEnable = YES;
        
//        if (!_isAutoPlay)
//        {
//            self.firstImageView.isDoubleEnable = YES;
//            self.secondImageView.isDoubleEnable = YES;
//            self.thirdImageView.isDoubleEnable = YES;
//        }
    }
}

- (void)setImageContentMode:(SYImageBrowseContentMode)imageContentMode
{
    _imageContentMode = imageContentMode;
    
    if (SYImageBrowseContentFit == _imageContentMode)
    {
        self.firstImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
        self.secondImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
        self.thirdImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if (SYImageBrowseContentFill == _imageContentMode)
    {
        self.firstImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
        self.secondImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
        self.thirdImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setPageMode:(SYImageBrowsePageMode)pageMode
{
    _pageMode = pageMode;
    [self pageShowSetting];
}

- (void)setPageControlPoint:(CGPoint)pageControlPoint
{
    _pageControlPoint = pageControlPoint;
    
    CGRect rect = self.pageControlTmp.frame;
    rect.origin.x = _pageControlPoint.x;
    rect.origin.y = _pageControlPoint.y;
    self.pageControlTmp.frame = rect;
}

- (void)setPageLabelPoint:(CGPoint)pageLabelPoint
{
    _pageLabelPoint = pageLabelPoint;
    
    CGRect rect = self.pageLabelTmp.frame;
    rect.origin.x = _pageLabelPoint.x;
    rect.origin.y = _pageLabelPoint.y;
    self.pageLabelTmp.frame = rect;
}

- (void)setShowText:(BOOL)showText
{
    _showText = showText;
    self.textLabelTmp.hidden = !_showText;
}

- (void)setTextLabelPoint:(CGPoint)textLabelPoint
{
    _textLabelPoint = textLabelPoint;
    
    CGRect rect = self.textLabelTmp.frame;
    rect.origin.x = _textLabelPoint.x;
    rect.origin.y = _textLabelPoint.y;
    self.textLabelTmp.frame = rect;
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton
{
    if (_browseMode == SYImageBrowseAdvertisement)
    {
        // 广告轮播图模式时，隐藏
        self.buttonDelete.hidden = YES;
        return;
    }
    
    _showDeleteButton = showDeleteButton;
    self.buttonDelete.hidden = !_showDeleteButton;
}

- (void)setShowSwitchButton:(BOOL)showSwitchButton
{
    _showSwitchButton = showSwitchButton;
    
    self.buttonPrevious.hidden = !_showSwitchButton;
    self.buttonNext.hidden = !_showSwitchButton;
}

- (void)setImagePrevious:(UIImage *)imagePrevious
{
    _imagePrevious = imagePrevious;
    if (_imagePrevious)
    {
        [self.buttonPrevious setImage:_imagePrevious forState:UIControlStateNormal];
        [self.buttonPrevious setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setImagePreviousHighlight:(UIImage *)imagePreviousHighlight
{
    _imagePreviousHighlight = imagePreviousHighlight;
    if (_imagePreviousHighlight)
    {
        [self.buttonPrevious setImage:_imagePreviousHighlight forState:UIControlStateHighlighted];
        [self.buttonPrevious setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setImageNext:(UIImage *)imageNext
{
    _imageNext = imageNext;
    if (_imageNext)
    {
        [self.buttonNext setImage:_imageNext forState:UIControlStateHighlighted];
        [self.buttonNext setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setImageNextHighlight:(UIImage *)imageNextHighlight
{
    _imageNextHighlight = imageNextHighlight;
    if (_imageNextHighlight)
    {
        [self.buttonNext setImage:_imageNextHighlight forState:UIControlStateHighlighted];
        [self.buttonNext setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    
    if (SYImageBrowseAdvertisement == _browseMode)
    {
        _pageIndex = 0;
    }
    
    if (0 == self.pageCount)
    {
        return;
    }
    
    NSInteger index = _pageIndex - 1;
    self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
    
    // 设置滚动响应
    self.imageScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
    
    // 改变图片视图，标题
    [self resetPageUI];
}

- (void)setIsAutoPlay:(BOOL)isAutoPlay
{
    _isAutoPlay = isAutoPlay;
    
    if (_isAutoPlay && SYImageBrowseLoopTypeTrue == _loopType)
    {
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:_animationTime];
//         [self startTimer];
    }
    else
    {
        [self stopTimer];
    }
}

#pragma mark - 定时器

- (void)stopTimer
{
    [NSThread cancelPreviousPerformRequestsWithTarget:self];
    
    [self.timerAnimation timerStop];
    if (self.timerAnimation)
    {
        self.timerAnimation = nil;
    }
}

- (void)startTimer
{
    if (self.images && 0 != self.images.count)
    {
        if (self.timerAnimation == nil)
        {
            __weak typeof(self) weakSelf = self;
            self.timerAnimation = [NSTimer timerWithTimeInterval:_animationTime userInfo:nil repeats:YES handle:^(NSTimer *timer) {
                [weakSelf autoPlayScroll];
            }];
        }
        [self.timerAnimation timerStart];
    }
}

// 自动播放
- (void)autoPlayScroll
{
    if (1 < self.pageCount)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.imageScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageScrollView.bounds) * 2, 0.0)];
            
        } completion:^(BOOL finished) {
            
            // 向左翻页
            self.currentPage++;
            self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
            [self resetPageUI];
            
            // 改变offset
            [self.imageScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageScrollView.bounds), 0.0) animated:NO];
        }];
    }
}

@end
*/



@interface SYImageBrowseView ()

@property (nonatomic, strong) NSMutableArray *imagesTmp;
@property (nonatomic, strong) NSMutableArray *titlesTmp;

@property (nonatomic, strong) SYImageBrowseViewLoopTrue *loopTrueView;
@property (nonatomic, strong) SYImageBrowseViewLoopFalse *loopFalseView;

@property (nonatomic, strong) UIPageControl *pageControlTmp;
@property (nonatomic, strong) UILabel *textLabelTmp;
@property (nonatomic, strong) UILabel *pageLabelTmp;

@property (nonatomic, assign) NSInteger pageCount;    // 总页数
@property (nonatomic, assign) NSInteger currentPage;  // 当前页数

@property (nonatomic, strong) UIButton *buttonDelete;
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
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    _loopType = SYImageBrowseLoopTypeTrue;
    _browseMode = SYImageBrowseAdvertisement;
    _imageContentMode = SYImageBrowseContentFill;
    _pageMode = SYImageBrowsePageControl;
    
    _pageControlPoint = CGPointMake(SYImageBrowseOriginXY, SYImageBrowseOriginXY);
    _pageLabelPoint = CGPointMake((self.frame.size.width - SYImageBrowseSizePage - SYImageBrowseOriginXY), (self.frame.size.height - SYImageBrowseSizePage - SYImageBrowseOriginXY));
    
    _showText = NO;
    _textLabelPoint = CGPointMake(SYImageBrowseOriginXY, (self.frame.size.height - SYImageBrowseSizePage) / 2);
    
    _showDeleteButton = NO;
    
    _showSwitchButton = NO;
    
    _pageIndex = 0;
    
    _isAutoPlay = NO;
    _animationTime = 3.0;
}

// 图片视图
- (void)setUI
{
    [self addSubview:self.loopFalseView];
    [self addSubview:self.loopTrueView];
    
    [self addSubview:self.pageControlTmp];
    [self addSubview:self.pageLabelTmp];
    [self addSubview:self.textLabelTmp];
    
    [self addSubview:self.buttonDelete];
    [self addSubview:self.buttonPrevious];
    [self addSubview:self.buttonNext];
}

- (void)resetUI
{
    // scrollview
    self.loopTrueView.frame = self.bounds;
    self.loopFalseView.frame = self.bounds;
    
    // pageControl
    self.pageControlTmp.frame = CGRectMake(0.0, (self.frame.size.height - SYImageBrowseSizePage), self.frame.size.width, SYImageBrowseSizePage);
    
    // pagelabel
    self.pageLabelTmp.frame = CGRectMake((self.frame.size.width - SYImageBrowseSizePage - SYImageBrowseOriginXY), (self.frame.size.height - SYImageBrowseSizePage - SYImageBrowseOriginXY), SYImageBrowseSizePage, SYImageBrowseSizePage);
    
    // textlabel
    self.textLabelTmp.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - SYImageBrowseSizePage) / 2, (self.frame.size.width - SYImageBrowseOriginXY * 2), SYImageBrowseSizePage);
    
    // buttonDelete
    
    // buttonPrevious
    self.buttonPrevious.frame = CGRectMake(SYImageBrowseOriginXY, (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    // buttonNext
    self.buttonNext.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), (self.frame.size.height - widthImage) / 2, widthImage, widthImage);
    
    self.loopFalseView.hidden = YES;
    self.loopTrueView.hidden = NO;
    self.pageLabelTmp.hidden = YES;
    self.pageControlTmp.hidden = NO;
    self.textLabelTmp.hidden = YES;
    self.buttonDelete.hidden = YES;
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
        self.loopFalseView.hidden = NO;
        self.loopFalseView.imageContentMode = self.imageContentMode;
        
        self.loopTrueView.hidden = YES;
    }
    else if (SYImageBrowseLoopTypeTrue == self.loopType)
    {
        self.loopFalseView.hidden = YES;
        
        self.loopTrueView.hidden = NO;
        self.loopTrueView.imageContentMode = self.imageContentMode;
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
        
        CGRect rectPageControl = self.pageControlTmp.frame;
        rectPageControl.origin.x = self.pageControlPoint.x;
        rectPageControl.origin.y = self.pageControlPoint.y;
        self.pageControlTmp.frame = rectPageControl;
    }
    else if (SYImageBrowsePagelabel == self.pageMode)
    {
        self.pageLabelTmp.hidden = NO;
        self.pageLabelTmp.alpha = 1.0;
        
        CGRect rectPageLabel = self.pageLabelTmp.frame;
        rectPageLabel.origin.x = self.pageLabelPoint.x;
        rectPageLabel.origin.y = self.pageLabelPoint.y;
        self.pageLabelTmp.frame = rectPageLabel;
        
        self.pageControlTmp.hidden = YES;
        self.pageControlTmp.alpha = 0.0;
    }
    
    if (self.showText)
    {
        self.textLabelTmp.hidden = NO;
        self.textLabelTmp.alpha = 1.0;
        
        CGRect rectTextLabel = self.textLabelTmp.frame;
        rectTextLabel.origin.x = self.textLabelPoint.x;
        rectTextLabel.origin.y = self.textLabelPoint.y;
        self.textLabelTmp.frame = rectTextLabel;
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
    self.buttonDelete.hidden = !self.showDeleteButton;
    if (SYImageBrowseAdvertisement == self.browseMode)
    {
        self.buttonDelete.hidden = YES; // 广告轮播图模式时，隐藏
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
    CGFloat widthPageControl = self.pageCount * (SYImageBrowseSizePage / 1.6);
    
    CGRect rectPageControl = self.pageControlTmp.frame;
    rectPageControl.origin.x = self.pageControlPoint.x;
    rectPageControl.origin.y = self.pageControlPoint.y;
    rectPageControl.size.width = widthPageControl;
    self.pageControlTmp.frame = rectPageControl;
}

// 改变页码pagelabel的字段颜色
- (void)resetPagelabelUI
{
    self.pageLabelTmp.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (self.currentPage + 1), self.pageCount];
}

#pragma mark - 响应事件

- (void)deleteClick
{
    // 回调处理
    if (self.imageDelete)
    {
        self.imageDelete(self.currentPage);
    }
    
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
    
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.images = self.imagesTmp;
        self.loopTrueView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopFalseView.images = self.imagesTmp;
        self.loopFalseView.pageIndex = self.currentPage;
    }
}

- (void)previousClick
{
    if (0 == self.currentPage && self.loopTrueView.hidden)
    {
        return;
    }
    
    // 向右翻页
    self.currentPage--;
    self.currentPage = (self.currentPage < 0 ? (self.pageCount - 1) : self.currentPage);
    [self resetPageUI];
    // 改变offset
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.isDirectionRight = NO;
        self.loopTrueView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopFalseView.pageIndex = self.currentPage;
    }
    NSLog(@"- currentPage = %@", @(self.currentPage));
}

- (void)nextClick
{
    if ((self.pageCount - 1) == self.currentPage && self.loopTrueView.hidden)
    {
        return;
    }
    
    // 向左翻页
    self.currentPage++;
    self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
    [self resetPageUI];
    // 改变offset
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.isDirectionRight = YES;
        self.loopTrueView.pageIndex = self.currentPage;
    }
    else
    {
        self.loopFalseView.pageIndex = self.currentPage;
    }
    NSLog(@"+ currentPage = %@", @(self.currentPage));
}

- (void)pressDownClick
{
    NSLog(@"down press");
    
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.isAutoPlay = NO;
    }
}

- (void)pressUpClick
{
    NSLog(@"up press");
    
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.isAutoPlay = self.isAutoPlay;
    }
}


- (void)reloadUIView
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
        
        self.showDeleteButton = NO;
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
    if (self.loopFalseView.hidden)
    {
        self.loopTrueView.images = self.imagesTmp;
        self.loopTrueView.pageIndex = self.currentPage;
        self.loopTrueView.isAutoPlay = self.isAutoPlay;
        [self.loopTrueView reloadUIView];
    }
    else
    {
        self.loopFalseView.images = self.imagesTmp;
        self.loopFalseView.pageIndex = self.currentPage;
        [self.loopFalseView reloadUIView];
    }
}

#pragma mark - getter

- (SYImageBrowseViewLoopFalse *)loopFalseView
{
    if (!_loopFalseView)
    {
        _loopFalseView = [[SYImageBrowseViewLoopFalse alloc] initWithFrame:self.bounds];
        _loopFalseView.backgroundColor = [UIColor clearColor];
        
        WeakSYImageBrowse;
        _loopFalseView.imageScroll = ^(NSInteger index){
            weakSYImageBrowse.currentPage = index;
            // 改变图片视图，标题
            [weakSYImageBrowse resetPageUI];
        };
        _loopFalseView.imageClick = ^(NSInteger index){
            if (weakSYImageBrowse.imageClick)
            {
                weakSYImageBrowse.imageClick(index);
            }
        };
    }
    
    return _loopFalseView;
}

- (SYImageBrowseViewLoopTrue *)loopTrueView
{
    if (!_loopTrueView)
    {
        _loopTrueView = [[SYImageBrowseViewLoopTrue alloc] initWithFrame:self.bounds];
        _loopTrueView.backgroundColor = [UIColor clearColor];
        
        WeakSYImageBrowse;
        _loopTrueView.imageScroll = ^(NSInteger index){
            weakSYImageBrowse.currentPage = index;
            // 改变图片视图，标题
            [weakSYImageBrowse resetPageUI];
        };
        _loopTrueView.imageClick = ^(NSInteger index){
            if (weakSYImageBrowse.imageClick)
            {
                weakSYImageBrowse.imageClick(index);
            }
        };
    }
    
    return _loopTrueView;
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

- (UIButton *)buttonDelete
{
    if (!_buttonDelete)
    {
        UIImage *deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
        CGFloat heightImage = deleteImage.size.height * widthImage / deleteImage.size.width;
        _buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonDelete.frame = CGRectMake((self.frame.size.width - widthImage - SYImageBrowseOriginXY), SYImageBrowseOriginXY, widthImage, heightImage);
        _buttonDelete.backgroundColor = [UIColor clearColor];
        [_buttonDelete setBackgroundImage:deleteImage forState:UIControlStateNormal];
        [_buttonDelete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buttonDelete;
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

@end
