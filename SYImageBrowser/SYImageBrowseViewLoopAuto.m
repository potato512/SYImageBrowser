//
//  SYImageBrowseViewLoopAuto.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseViewLoopAuto.h"

@interface SYImageBrowseViewLoopAuto () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imagesTmp;

@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) SYImageBrowseScrollView *firstImageView;
@property (nonatomic, strong) SYImageBrowseScrollView *secondImageView;
@property (nonatomic, strong) SYImageBrowseScrollView *thirdImageView;

@property (nonatomic, assign) NSInteger pageCount;    // 总页数
@property (nonatomic, assign) NSInteger currentPage;  // 当前页数
@property (nonatomic, assign) CGFloat currentOffX;    // 当前偏移量

@property (nonatomic, strong) id firstImage;
@property (nonatomic, strong) id secondImage;
@property (nonatomic, strong) id thirdImage;

@property (nonatomic, strong) NSTimer *timerAnimation;

@end

@implementation SYImageBrowseViewLoopAuto

#pragma mark - 视图初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.autoresizesSubviews = YES;
    
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;

    self.imageContentMode = SYImageBrowseContentFill;
    
    self.isAutoPlay = NO;
    self.animationTime = 3.0;
}

// 图片视图
- (void)setUI
{
    [self addSubview:self.imageScrollView];
    
    [self.imageScrollView addSubview:self.firstImageView];
    [self.imageScrollView addSubview:self.secondImageView];
    [self.imageScrollView addSubview:self.thirdImageView];
}

- (void)resetUI
{
    // scrollview
    self.imageScrollView.frame = self.bounds;
    self.imageScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.imageScrollView.contentOffset = CGPointMake(self.frame.size.width, 0.0);
    
    self.firstImageView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    self.secondImageView.frame = CGRectMake(self.bounds.size.width, 0.0, self.bounds.size.width, self.bounds.size.height);
    self.thirdImageView.frame = CGRectMake(self.bounds.size.width * 2, 0.0, self.bounds.size.width, self.bounds.size.height);
}

// 改变图片视图
- (void)resetPageUI
{
    // 改变图片
    NSInteger firstIndex = self.currentPage - 1;
    firstIndex = (firstIndex < 0 ? (self.pageCount - 1) : firstIndex);
    id imageObjectFirst = self.imagesTmp[firstIndex];
    id imageObjectSecond = self.imagesTmp[self.currentPage];
    NSInteger lastIndex = self.currentPage + 1;
    lastIndex = (lastIndex >= self.pageCount ? 0 : lastIndex);
    id imageObjectThird = self.imagesTmp[lastIndex];
    
    self.firstImage = imageObjectFirst;
    self.secondImage = imageObjectSecond;
    self.thirdImage = imageObjectThird;
    // SDWebImage
    [self.firstImageView.imageBrowseView setImage:self.firstImage defaultImage:self.defaultImage];
    [self.secondImageView.imageBrowseView setImage:self.secondImage defaultImage:self.defaultImage];
    [self.thirdImageView.imageBrowseView setImage:self.thirdImage defaultImage:self.defaultImage];
}

#pragma mark - 响应事件

- (void)currentImageClick
{
    if (self.imageClick)
    {
        self.imageClick(self.currentPage);
    }
}

- (void)autoPlayStatus:(BOOL)start
{
    if (_isAutoPlay)
    {
        if (start)
        {
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:self.animationTime];
            // [self startTimer];
        }
        else
        {
            [self stopTimer];
        }
    }
}

- (void)reloadData
{
    [self resetUI];
    
    // 重新刷新信息
    if (SYImageBrowseContentFit == self.imageContentMode)
    {
        self.firstImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
        self.secondImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
        self.thirdImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if (SYImageBrowseContentFill == self.imageContentMode)
    {
        self.firstImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
        self.secondImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
        self.thirdImageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.imagesTmp = [[NSMutableArray alloc] initWithArray:self.images];
    self.pageCount = self.imagesTmp.count;
    self.currentPage = 0;
    
    // 设置滚动响应
    self.imageScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
    
    if (self.images && 0 < self.images.count)
    {
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
            
        if (self.isAutoPlay)
        {
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:self.animationTime];
            // [self startTimer];
        }
        else
        {
            [self stopTimer];
        }
    }
        
    NSInteger index = self.pageIndex;
    self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
    
    // 改变图片视图
    [self resetPageUI];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoPlay)
    {
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:self.animationTime];
        // [self startTimer];
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
        
        if (self.imageScroll)
        {
            self.imageScroll(self.currentPage);
        }
    }
}

#pragma mark - getter

- (UIScrollView *)imageScrollView
{
    if (!_imageScrollView)
    {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageScrollView.autoresizesSubviews = YES;
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.scrollEnabled = YES;
        _imageScrollView.bounces = NO;
        
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
        _secondImageView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
        
        _secondImageView.isDoubleEnable = NO;
        
        WeakSYImageBrowse;
        _secondImageView.imageBrowseView.imageClick = ^(){
            [weakSYImageBrowse currentImageClick];
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
        _thirdImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _thirdImageView.isDoubleEnable = NO;
    }
    
    return _thirdImageView;
}

- (CGFloat)currentOffX
{
    return self.imageScrollView.bounds.size.width;
}

#pragma mark - setter

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;

    [UIView animateWithDuration:0.3 animations:^{
        CGFloat offX = self.imageScrollView.bounds.size.width * (self.isDirectionRight ? 2.0 : 0.0);
        [self.imageScrollView setContentOffset:CGPointMake(offX, 0.0) animated:NO];
    } completion:^(BOOL finished) {
        // 向左，或向右翻页
        self.currentPage = _pageIndex;
        self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
        [self resetPageUI];
        // 改变offset
        [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.bounds.size.width, 0.0) animated:NO];
    }];
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
            WeakSYImageBrowse;
            self.timerAnimation = [NSTimer timerWithTimeInterval:self.animationTime userInfo:nil repeats:YES handle:^(NSTimer *timer) {
                [weakSYImageBrowse autoPlayScroll];
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
            
            [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.bounds.size.width * 2, 0.0)];
            
        } completion:^(BOOL finished) {
            
            // 向左翻页
            self.currentPage++;
            self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
            [self resetPageUI];
            
            if (self.imageAutoScroll)
            {
                self.imageAutoScroll(self.currentPage);
            }
            
            // 改变offset
            [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.bounds.size.width, 0.0) animated:NO];
        }];
    }
}

@end
