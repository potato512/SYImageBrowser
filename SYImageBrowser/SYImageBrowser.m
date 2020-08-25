//
//  SYImageBrowser.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowser.h"
#import "NSTimer+SYImageBrowser.h"
#import "SYImageBrowserCell.h"

#define widthSelf  (self.frame.size.width)
#define heightSelf (self.frame.size.height)

static CGFloat const numberScale = 0.5;
//
static CGFloat const originXY = 10.0;
static CGFloat const sizePage = 30.0;
static CGFloat const sizeLabel = 30.0;

static NSTimeInterval const durationTime = 0.3;

@interface SYImageBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalImage; // 总数，区分循环模式
@property (nonatomic, assign) NSInteger numberImage;
@property (nonatomic, assign) NSInteger indexRowPrevious;
@property (nonatomic, assign) NSInteger indexPage; // 页码

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dequeueReusableViews;

@property (nonatomic, assign) BOOL isDragScroll;
@property (nonatomic, assign) CGFloat previousContentOff;
@property (nonatomic, assign) CGFloat offx;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) UIImageScrollDirection scrollDirection;

@end

@implementation SYImageBrowser

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UIImageScrollDirection)direction
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        self.hiddenWhileSinglePage = NO;
        
        self.pageControlType = UIImagePageControl;
        self.scrollMode = UIImageScrollNormal;
        self.autoAnimation = NO;
        self.autoDuration = 3.0;
        self.currentPage = 0;
        self.isBrowser = NO;
        //
        self.scrollDirection = direction;
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
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.scrollDirection = (self.scrollDirection == UIImageScrollDirectionHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical);
    self.collectionLayout.itemSize = self.frame.size;
    //
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[SYImageBrowserCell class] forCellWithReuseIdentifier:identifierSYImageBrowserCell];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

#pragma mark 复用视图

//- (NSMutableArray *)dequeueReusableViews
//{
//    if (_dequeueReusableViews == nil) {
//        _dequeueReusableViews = [[NSMutableArray alloc] init];
//        for (NSInteger index = 0; index < self.numberImage; index++) {
//            [_dequeueReusableViews addObject:[NSNull null]];
//        }
//    }
//    return _dequeueReusableViews;
//}

#pragma mark 页码标签

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(originXY, (heightSelf - sizePage), (widthSelf - originXY * 2), sizePage)];
        _pageControl.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.pageControl];
    }
    return _pageControl;
}

- (UILabel *)pageLabel
{
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthSelf - sizeLabel - originXY), (heightSelf - sizeLabel - originXY), sizeLabel, sizeLabel)];
        _pageLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize:12.0];
        _pageLabel.textColor = [UIColor whiteColor];
        
        _pageLabel.layer.cornerRadius = sizeLabel / 2;
        _pageLabel.layer.masksToBounds = YES;
        _pageLabel.clipsToBounds = YES;
        
        [self addSubview:_pageLabel];
    }
    return _pageLabel;
}

- (void)setPageUIWithPage:(NSInteger)page
{
    if (self.hiddenWhileSinglePage && 1 == self.numberImage) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
        return;
    }
    
    if (self.pageControlType == UIImagePageControl) {
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = YES;
        
        self.pageControl.currentPage = page;
    } else if (self.pageControlType == UIImagePageLabel) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = NO;
        
        NSString *pageStr = [NSString stringWithFormat:@"%@/%@", @(page + 1), @(self.numberImage)];
        self.pageLabel.text = pageStr;
    } else if (self.pageControlType == UIImagePageControlHidden) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
    }
    
    if (!self.pageLabel.hidden) {
        [self bringSubviewToFront:self.pageLabel];
    }
    if (!self.pageControl.hidden) {
        [self bringSubviewToFront:self.pageControl];
    }
}

#pragma mark 重置页码位置大小

- (void)setPagePointAndSize
{
    if (self.pageControlType == UIImagePageControl) {
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = YES;
        
        CGRect rect = self.pageControl.frame;
        if (!CGPointEqualToPoint(self.pagePoint, CGPointZero)) {
            rect.origin = self.pagePoint;
        }
        if (!CGSizeEqualToSize(self.pageSize, CGSizeZero)) {
            rect.size = self.pageSize;
        }
        self.pageControl.frame = rect;
    } else if (self.pageControlType == UIImagePageLabel) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = NO;
        
        CGRect rect = self.pageLabel.frame;
        if (!CGPointEqualToPoint(self.pagePoint, CGPointZero)) {
            rect.origin = self.pagePoint;
        }
        if (!CGSizeEqualToSize(self.pageSize, CGSizeZero)) {
            rect.size = self.pageSize;
        }
        self.pageLabel.frame = rect;
    } else if (self.pageControlType == UIImagePageControlHidden) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
    }
    
    self.pageControl.hidesForSinglePage = (self.pageControl.hidden ? YES : self.hiddenWhileSinglePage);
    if (self.hiddenWhileSinglePage  && 1 == self.numberImage) {
        self.pageLabel.hidden = YES;
    }
}

#pragma mark 图片动画显示，或隐藏

- (void)showAnimationUI
{
    if (self.isBrowser)  {
        // 设置了该属性表示图片浏览
        self.alpha = 0.0;
        [UIView animateWithDuration:durationTime animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)hideAnimationUI
{
    if (self.isBrowser) {
        // 设置了该属性表示图片浏览
        [UIView animateWithDuration:durationTime animations:^{
            self.alpha = 0.0;
        }];
        
        return;
    }
}

#pragma mark - 响应

- (void)buttonClick:(NSInteger)index
{
    [self hideAnimationUI];

    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:didSelecteAtIndex:)]) {
        [self.deletage imageBrowser:self didSelecteAtIndex:index];
    }
}

#pragma mark - UICollectionViewDataSource

// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalImage;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierSYImageBrowserCell forIndexPath:indexPath];
    
    cell.sizeItem = CGSizeMake(self.frame.size.width, self.frame.size.height);
    cell.isBrowser = self.isBrowser;
    
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:view:viewAtIndex:)]) {
        NSInteger index = (indexPath.item % self.numberImage);
        UIView *view = self.dequeueReusableViews[index];
        if (view && [view isKindOfClass:UIView.class]) {
            view = [self.deletage imageBrowser:self view:view viewAtIndex:index];
        } else {
            view = [self.deletage imageBrowser:self view:nil viewAtIndex:index];
            if (![view isKindOfClass:UIView.class]) {
                NSLog(@"[%s]返回对象非UIView类型", __func__);
                return cell;
            }
            [self.dequeueReusableViews replaceObjectAtIndex:index withObject:view];
        }
        cell.showView = view;
    }
    
    // 单击隐藏回调
    typeof(self) __weak weakSelf = self;
    cell.hiddenClick = ^(){
        [weakSelf hideAnimationUI];
    };
    
    [cell reloadItem];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

// 定义每个UICollectionView的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

// 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// 最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

#pragma mark - UICollectionViewDelegate

// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self buttonClick:indexPath.row];
}

// 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOff = scrollView.contentOffset.x;
    CGFloat contentSize = widthSelf;
    if (self.scrollDirection == UIImageScrollDirectionVertical) {
        contentOff = scrollView.contentOffset.y;
        contentSize = heightSelf;
    }
    
    NSInteger index = self.indexPage % self.numberImage;
    [self setPageUIWithPage:index];
    
    if (self.isDragScroll) {
        self.isEnd = ((contentOff <= 0.0 || (contentOff >= contentSize * (self.numberImage - 1))) ? YES : NO);
        if (contentOff > self.previousContentOff) {
            self.direction = UIImageSlideDirectionLeft;
            self.offx = (contentOff + self.collectionView.frame.size.width - self.collectionView.contentSize.width);
            if (self.scrollDirection == UIImageScrollDirectionVertical) {
                self.direction = UIImageSlideDirectionUpward;
                self.offx = (contentOff + self.collectionView.frame.size.height - self.collectionView.contentSize.height);
            }
        } else {
            self.direction = UIImageSlideDirectionRight;
            self.offx = contentOff;
            if (self.scrollDirection == UIImageScrollDirectionVertical) {
                self.direction = UIImageSlideDirectionDownward;
            }
        }
        self.offx = fabs(self.offx);
        self.previousContentOff = contentOff;
        self.indexRowPrevious = index;
        
        if (self.scrollMode == UIImageScrollNormal) {
            if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:direction:contentOffX:end:)]) {
                [self.deletage imageBrowser:self direction:self.direction contentOffX:self.offx end:self.isEnd];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragScroll = YES;
    if (self.scrollMode == UIImageScrollNormal) {
        
    } else if (self.scrollMode == UIImageScrollLoop) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDragScroll = NO;
    if (self.scrollMode == UIImageScrollLoop) {
        [self startTimer];
    }
}

// 调用系统方法动画停止时执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = self.indexPage % self.numberImage;
    
    [self setPageUIWithPage:index];
    
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:didScrollAtIndex:)]) {
        [self.deletage imageBrowser:self didScrollAtIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = self.indexPage % self.numberImage;
    
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:didScrollAtIndex:)]) {
        [self.deletage imageBrowser:self didScrollAtIndex:index];
    }
}

#pragma mark - timer

- (void)stopTimer
{
    if (self.autoAnimation && UIImageScrollLoop == self.scrollMode) {
        [NSThread cancelPreviousPerformRequestsWithTarget:self];
        if (self.timer) {
            [self.timer timerStop];
            self.timer = nil;
        }
    }
}

- (void)startTimer
{
    // 只有一张图片时不进行自动播放
    if (self.numberImage <= 1) {
        return;
    }
    
    // 自动播放模式，循环显示模式
    if (self.scrollMode == UIImageScrollLoop && self.autoAnimation) {
        typeof(self) __weak weakSelf = self;
        [weakSelf performSelector:@selector(startTimerScroll) withObject:nil afterDelay:_autoDuration];
    }
}

- (void)startTimerScroll
{
    if (self.timer == nil) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:self.autoDuration userInfo:nil repeats:YES handle:^(NSTimer *timer) {
            [weakSelf autoAnimationScroll];
        }];
    }
    [self.timer timerStart];
}

- (void)autoAnimationScroll
{
    NSInteger index = self.indexPage;
    index += 1;

    [self scrollToIndex:index animation:YES];
}

- (void)scrollToIndex:(NSInteger)index animation:(BOOL)isAnimation
{
    if (index >= self.totalImage) {
        if (self.scrollMode == UIImageScrollLoop) {
            index = self.totalImage * numberScale;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:isAnimation];
}

#pragma mark - setter

- (void)setHiddenWhileSinglePage:(BOOL)hiddenWhileSinglePage
{
    _hiddenWhileSinglePage = hiddenWhileSinglePage;
    if (_hiddenWhileSinglePage) {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = NO;
    }
}

#pragma mark - methord

- (NSInteger)indexPage
{
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    if (self.collectionLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.collectionLayout.itemSize.width * numberScale) / self.collectionLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + self.collectionLayout.itemSize.height * numberScale) / self.collectionLayout.itemSize.height;
    }
    return MAX(0, index);
}

/// 自动播放时，停止播放，或继续播放
- (void)animationStopWhileAuto:(BOOL)isPause
{
    if (self.autoAnimation) {
        if (isPause) {
            [self stopTimer];
        } else {
            [self startTimer];
        }
    }
}

- (void)reloadData
{
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowserNumberOfImages:)]) {
        self.numberImage = [self.deletage imageBrowserNumberOfImages:self];
    }
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowser:didScrollAtIndex:)]) {
        [self.deletage imageBrowser:self didScrollAtIndex:self.currentPage];
    }
    
    if (0 < self.numberImage) {
        self.collectionView.hidden = NO;
        //
        self.totalImage = self.numberImage;
        if (self.scrollMode == UIImageScrollLoop && 1 < self.totalImage) {
            self.totalImage = self.numberImage * 100;
        }
        //
        [self setPagePointAndSize];
        // 当前有页码
        NSInteger index = self.currentPage;
        if (self.scrollMode == UIImageScrollLoop) {
            index = self.totalImage * numberScale + self.currentPage;
        }
        
        NSInteger numberPage = self.numberImage;
        self.pageControl.numberOfPages = numberPage;
        [self setPageUIWithPage:index];

        [self scrollToIndex:index animation:NO];
        
        [self.collectionView reloadData];
        
        // 自动循环
        [self startTimer];
        
        // 自动显示
        [self showAnimationUI];
        
        // 只有一张图时不能拖动
        self.collectionView.scrollEnabled = YES;
        if (1 == self.totalImage) {
            self.collectionView.scrollEnabled = NO;
        }
    }
}

@end
