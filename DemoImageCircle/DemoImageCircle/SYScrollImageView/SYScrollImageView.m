//
//  SYScrollImageView.m
//  zhangshaoyu
//
//  Created by herman on 2017/5/24.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYScrollImageView.h"
#import "NSTimer+SYScrollImageView.h"

#define widthSelf self.frame.size.width
#define heightSelf self.frame.size.height
static CGFloat const origin = 10.0;
static CGFloat const sizeLabel = 30.0;
static CGFloat const pageLabel = 30.0;

@interface SYScrollImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger totalIndex;

@property (nonatomic, assign) CGFloat previousOffX;

@end

@implementation SYScrollImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    
    NSLog(@"%@ 被释放了...", self);
}

#pragma mark - 视图

- (void)setUI
{
    _pageType = UIPageControlType;
    _showType = ImageShowNormalType;
    _contentMode = ImageContentAspectFillType;
    _showTitle = NO;
    _showSwitch = NO;
    _isAutoPlay = NO;
    _animationTime = 3.0;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
}

#pragma mark 图片

- (void)setImageUI
{
    if (ImageShowRunloopType == _showType)
    {
        [self setImageRunloop];
    }
    else if (ImageShowNormalType == _showType)
    {
        [self setImageNormal];
    }

    if (ImageContentAspectFitType == _contentMode)
    {
        for (UIImageView *imageview in self.scrollView.subviews)
        {
            imageview.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else if (ImageContentAspectFillType == _contentMode)
    {
        for (UIImageView *imageview in self.scrollView.subviews)
        {
            imageview.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
}

- (void)setImageRunloop
{
    _scrollView.contentSize = CGSizeMake((widthSelf * 3), heightSelf);
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, widthSelf, heightSelf)];
    _leftImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthSelf, 0.0, widthSelf, heightSelf)];
    _centerImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_centerImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:_centerImageView.bounds];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addSubview:button];
    
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((widthSelf * 2), 0.0, widthSelf, heightSelf)];
    _rightImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_rightImageView];
}

- (void)setImageNormal
{
    _scrollView.contentSize = CGSizeMake((widthSelf * self.totalIndex), heightSelf);
    
    for (NSInteger index = 0; index < self.totalIndex; index++)
    {
        NSString *imageName = self.images[index];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.backgroundColor = [UIColor clearColor];
        imageview.frame = CGRectMake((widthSelf * index), 0.0, widthSelf, heightSelf);
        
        UIButton *button = [[UIButton alloc] initWithFrame:imageview.bounds];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        imageview.userInteractionEnabled = YES;
        [imageview addSubview:button];
        
        [self.scrollView addSubview:imageview];
    }
}

#pragma mark 页码标签

- (void)setPageUI
{
    if (UIPageControlType == _pageType)
    {
        [self addSubview:self.pageControl];
        self.pageControl.numberOfPages = _totalIndex;
        self.pageControl.currentPage = 0;
        
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = YES;
    }
    else if (UILabelControlType == _pageType)
    {
        [self addSubview:self.pageLabel];
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%@", @(1), @(_totalIndex)];
        
        self.pageLabel.hidden = NO;
        self.pageControl.hidden = YES;
    }
}

#pragma mark 标题标签

- (void)setTitleUI
{
    self.titleLabel.hidden = YES;
    if (_showTitle)
    {
        self.titleLabel.hidden = NO;
        [self addSubview:self.titleLabel];
    }
}

#pragma mark 切换按钮

- (void)setSwitchUI
{
    self.previousButton.hidden = YES;
    self.nextButton.hidden = YES;
    if (_showSwitch)
    {
        self.previousButton.hidden = NO;
        [self addSubview:self.previousButton];
        
        self.nextButton.hidden = NO;
        [self addSubview:self.nextButton];
    }
}

#pragma mark - 响应

- (void)buttonClick
{
    if (self.imageClick)
    {
        self.imageClick(self.currentIndex);
    }
}

- (void)previousClick
{
    self.currentIndex--;
    if (self.currentIndex < 0)
    {
        self.currentIndex = 0;
    }
    [self.scrollView scrollRectToVisible:CGRectMake((widthSelf * self.currentIndex), 0.0, widthSelf, heightSelf) animated:YES];
}

- (void)nextClick
{
    self.currentIndex++;
    if (self.currentIndex >= self.totalIndex)
    {
        self.currentIndex = self.totalIndex - 1;
    }
    [self.scrollView scrollRectToVisible:CGRectMake((widthSelf * self.currentIndex), 0.0, widthSelf, heightSelf) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 即将手势拖动时，如果是自动播放，则停止自动播放
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 手势拖动结束时，如果是自动播放，则恢复自动播放
    [self startTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
//    [self showImagePageLabel];
}

// 手动拖动动画停止时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (ImageShowRunloopType == _showType)
//    {
//        self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
//        [self showImagePageLabel];
//    }
//    else if (ImageShowNormalType == _showType)
//    {
//        self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
//        [self showImagePageLabel];
//    }
    
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self showImagePageLabel];
}

// 调用系统方法动画停止时执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self showImagePageLabel];
}

#pragma mark - timer

- (void)stopTimer
{
    if (self.images && 2 <= self.images.count && self.isAutoPlay && ImageShowRunloopType == self.showType)
    {
        [NSThread cancelPreviousPerformRequestsWithTarget:self];
        if (self.timer)
        {
            [self.timer timerStop];
            self.timer = nil;
        }
    }
}

- (void)startTimer
{
    // 有2张以上图片，自动播放模式，循环显示模式
    if (self.images && 2 <= self.images.count && self.isAutoPlay && ImageShowRunloopType == self.showType)
    {
        [self performSelector:@selector(startTimerScroll) withObject:nil afterDelay:_animationTime];
    }
}

- (void)startTimerScroll
{
    if (self.timer == nil)
    {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:_animationTime userInfo:nil repeats:YES handle:^(NSTimer *timer) {
            [weakSelf autoPlayScroll];
        }];
    }
    [self.timer timerStart];
}

// 自动播放
- (void)autoPlayScroll
{
    self.currentIndex++;
    self.currentIndex = (self.currentIndex >= self.totalIndex ? 0 : self.currentIndex);
    [self.scrollView setContentOffset:CGPointMake((widthSelf * 2), 0.0) animated:YES];
}

#pragma mark - setter

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin, origin, (widthSelf - origin * 2), sizeLabel)];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((widthSelf - (sizeLabel * _totalIndex)) / 2, (heightSelf - sizeLabel), (sizeLabel * _totalIndex), sizeLabel)];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

- (UILabel *)pageLabel
{
    if (_pageLabel == nil)
    {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthSelf - pageLabel - origin), (heightSelf - pageLabel - origin), pageLabel, pageLabel)];
        _pageLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize:12.0];
        _pageLabel.textColor = [UIColor whiteColor];
        
        _pageLabel.layer.cornerRadius = sizeLabel / 2;
        _pageLabel.layer.masksToBounds = YES;
        _pageLabel.clipsToBounds = YES;
    }
    return _pageLabel;
}

- (UIButton *)previousButton
{
    if (_previousButton == nil)
    {
        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(origin, (heightSelf - sizeLabel) / 2, sizeLabel, sizeLabel)];
        _previousButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _previousButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_previousButton setImage:[UIImage imageNamed:@"previous_normal"] forState:UIControlStateNormal];
        [_previousButton setImage:[UIImage imageNamed:@"previous_highlight"] forState:UIControlStateHighlighted];
        [_previousButton addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
        
        _previousButton.layer.cornerRadius = sizeLabel / 2;
        _previousButton.layer.masksToBounds = YES;
        _previousButton.clipsToBounds = YES;
    }
    return _previousButton;
}

- (UIButton *)nextButton
{
    if (_nextButton == nil)
    {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake((widthSelf - sizeLabel - origin), (heightSelf - sizeLabel) / 2, sizeLabel, sizeLabel)];
        _nextButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_nextButton setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        
        _nextButton.layer.cornerRadius = sizeLabel / 2;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.clipsToBounds = YES;
    }
    return _nextButton;
}

#pragma mark - methord

- (void)showImagePageLabel
{
    if (ImageShowRunloopType == _showType)
    {
        NSLog(@"currentIndex = %ld", self.currentIndex);
        // 循环时
        NSInteger leftIndex = self.currentIndex - 1;
        leftIndex = (leftIndex < 0 ? (self.totalIndex - 1) : leftIndex);
        NSString *leftImage = self.images[leftIndex];
        self.leftImageView.image = [UIImage imageNamed:leftImage];
        
        NSString *centerImage = self.images[self.currentIndex];
        self.centerImageView.image = [UIImage imageNamed:centerImage];
        
        NSInteger rightIndex = self.currentIndex + 1;
        rightIndex = (rightIndex >= self.totalIndex ? 0 : rightIndex);
        NSString *rightImage = self.images[rightIndex];
        self.rightImageView.image = [UIImage imageNamed:rightImage];
        
        [self.scrollView setContentOffset:CGPointMake(widthSelf, 0.0) animated:NO];
    }
    else if (ImageShowNormalType == _showType)
    {
        // 非循环时
        
    }
    
    // 标题
    if (self.showTitle)
    {
        if (self.currentIndex <= self.titles.count - 1)
        {
            NSString *title = self.titles[self.currentIndex];
            self.titleLabel.text = title;
        }
    }
    
    // 页码
    if (UIPageControlType == self.pageType)
    {
        self.pageControl.currentPage = self.currentIndex;
    }
    else if (UILabelControlType == self.pageType)
    {
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.currentIndex + 1), @(self.totalIndex)];
    }
}

- (void)reloadData
{
    _currentIndex = 0;
    _totalIndex = self.images.count;
    
    [self setImageUI];
    [self setPageUI];
    [self setTitleUI];
    [self setSwitchUI];
    
    [self showImagePageLabel];
    
    [self startTimer];
}

@end
