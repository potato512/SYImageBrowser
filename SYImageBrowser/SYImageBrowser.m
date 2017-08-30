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

#define widthSelf self.frame.size.width
#define heightSelf self.frame.size.height

static CGFloat const originXY = 10.0;
static CGFloat const sizePage = 30.0;
static CGFloat const sizeLabel = 30.0;

static NSTimeInterval const durationTime = 0.3;

@interface SYImageBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isScroll;
@property (nonatomic, assign) float previousOffX;
@property (nonatomic, assign) float offx;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYImageBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _hiddenWhileSinglePage = NO;
        _enableWhileSinglePage = YES;
        
        _pageControlType = UIImagePageControl;
        _scrollMode = UIImageScrollNormal;
        _contentMode = UIViewContentModeScaleAspectFill;
        _showTitle = NO;
        _showSwitch = NO;
        _autoAnimation = NO;
        _autoDuration = 3.0;
        _pageIndex = 0;
        _isBrowser = NO;
        
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
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionLayout];
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[SYImageBrowserCell class] forCellWithReuseIdentifier:identifierSYImageBrowserCell];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthSelf - sizePage * 2 - originXY), (heightSelf - sizePage - originXY), (sizePage * 2), sizePage)];
    [self addSubview:self.pageLabel];
    self.pageLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.textColor = [UIColor blackColor];
    self.pageLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(originXY, (heightSelf - sizePage), (widthSelf - originXY * 2), sizePage)];
    [self addSubview:self.pageControl];
}

#pragma mark 页码标签

- (void)setPageUIWithPage:(NSInteger)page
{
    if (self.hiddenWhileSinglePage && 1 == self.totalPage)
    {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
        return;
    }
    
    if (self.scrollMode == UIImageScrollLoop)
    {
        page -= 1;
    }
    
    if (self.pageControlType == UIImagePageControl)
    {
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = YES;
        
        self.pageControl.currentPage = page;
    }
    else if (self.pageControlType == UIImagePageLabel)
    {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = NO;
        
        NSString *pageStr = [NSString stringWithFormat:@"%@/%@", @(page + 1), @(self.totalPage)];
        self.pageLabel.text = pageStr;
    }
    else if (self.pageControlType == UIImagePageControlHidden)
    {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
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

- (void)setTitleUIWithPage:(NSInteger)page
{
    if (self.showTitle)
    {
        NSString *title = self.titleArray[page];
        self.titleLabel.text = title;
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

#pragma mark 重置页码位置大小

- (void)setPagePointAndSize
{
    if (self.pageControlType == UIImagePageControl)
    {
        self.pageControl.hidden = NO;
        self.pageLabel.hidden = YES;
        
        CGRect rect = self.pageControl.frame;
        if (!CGPointEqualToPoint(_pagePoint, CGPointZero))
        {
            rect.origin = _pagePoint;
        }
        if (!CGSizeEqualToSize(_pageSize, CGSizeZero))
        {
            rect.size = _pageSize;
        }
        self.pageControl.frame = rect;
    }
    else if (self.pageControlType == UIImagePageLabel)
    {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = NO;
        
        CGRect rect = self.pageLabel.frame;
        if (!CGPointEqualToPoint(_pagePoint, CGPointZero))
        {
            rect.origin = _pagePoint;
        }
        if (!CGSizeEqualToSize(_pageSize, CGSizeZero))
        {
            rect.size = _pageSize;
        }
        self.pageLabel.frame = rect;
    }
    else if (self.pageControlType == UIImagePageControlHidden)
    {
        self.pageControl.hidden = YES;
        self.pageLabel.hidden = YES;
    }
    
    self.pageControl.hidesForSinglePage = (self.pageControl.hidden ? YES : _hiddenWhileSinglePage);
    if (_hiddenWhileSinglePage)
    {
        self.pageLabel.hidden = YES;
    }
}

#pragma mark 图片动画显示，或隐藏

- (void)setShowAnimationUI
{
    if (self.isBrowser)
    {
        // 设置了该属性表示图片浏览
        self.alpha = 0.0;
        [UIView animateWithDuration:durationTime animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)setHiddenAnimationUI
{
    if (self.isBrowser)
    {
        // 设置了该属性表示图片浏览
        [UIView animateWithDuration:durationTime animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (self.superview == nil)
            {
                [self removeFromSuperview];
            }
        }];
        
        return;
    }
}

#pragma mark - 响应

- (void)buttonClick:(NSInteger)index
{
    [self setHiddenAnimationUI];
    
    if (self.imageSelected)
    {
        if (self.scrollMode == UIImageScrollLoop)
        {
            index -= 1;
        }
        self.imageSelected(index);
    }
}

- (void)previousClick
{
    if (!self.enableWhileSinglePage)
    {
        return;
    }
    
    self.currentPage--;
    
    BOOL isAnimation = YES;
    if (UIImageScrollLoop == self.scrollMode)
    {
        if (self.currentPage < 1)
        {
            self.currentPage = self.imageArray.count - 2;
            isAnimation = NO;
        }
    }
    else if (UIImageScrollNormal == self.scrollMode)
    {
        if (self.currentPage < 0)
        {
            self.currentPage = 0;
            return;
        }
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:isAnimation];
}

- (void)nextClick
{
    if (!self.enableWhileSinglePage)
    {
        return;
    }
    
    self.currentPage++;
    
    BOOL isAnimation = YES;
    if (UIImageScrollLoop == self.scrollMode)
    {
        if (self.currentPage >= self.imageArray.count - 1)
        {
            self.currentPage = 1;
            isAnimation = NO;
        }
    }
    else if (UIImageScrollNormal == self.scrollMode)
    {
        if (self.currentPage >= self.totalPage)
        {
            self.currentPage = self.totalPage - 1;
            return;
        }
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:isAnimation];
}

- (void)pressDownClick
{
    [self stopTimer];
}

- (void)pressUpClick
{
    [self startTimer];
}

#pragma mark - UICollectionViewDataSource

// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierSYImageBrowserCell forIndexPath:indexPath];
    
    cell.sizeItem = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    id imageObject = self.imageArray[indexPath.row];
    cell.objectItem = imageObject;
    
    cell.defaultImage = self.defaultImage;
    cell.contentMode = self.contentMode;
    cell.isImageBrowser = self.isBrowser;
    
    // 单击隐藏回调
    typeof(self) __weak weakSelf = self;
    cell.hiddenClick = ^(){
        [weakSelf setHiddenAnimationUI];
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
    CGFloat offX = scrollView.contentOffset.x;
    
    self.currentPage = offX / widthSelf;
    if (self.scrollMode == UIImageScrollLoop)
    {
        if (self.currentPage <= 0 && offX < (widthSelf * 0.5))
        {
            self.currentPage = self.imageArray.count - 2;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        else if (self.currentPage >= self.imageArray.count - 1)
        {
            self.currentPage = 1;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    [self setPageUIWithPage:self.currentPage];
    [self setTitleUIWithPage:self.currentPage];
    
    if (self.scrollMode == UIImageScrollNormal)
    {
        if (self.isScroll)
        {
            if (self.imageScrolled)
            {
                self.isEnd = ((offX <= 0.0 || (offX >= widthSelf * (self.imageArray.count - 1))) ? YES : NO);
                if (offX > self.previousOffX)
                {
                    self.direction = 1;
                    self.offx = (offX + self.collectionView.frame.size.width - self.collectionView.contentSize.width);
                }
                else
                {
                    self.direction = 2;
                    self.offx = offX;
                }
                self.offx = fabsf(self.offx);
                
                self.imageScrolled(self.offx, self.direction, self.isEnd);
                
                self.previousOffX = offX;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollMode == UIImageScrollNormal)
    {
        self.isScroll = YES;
    }
    else if (self.scrollMode == UIImageScrollLoop)
    {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollMode == UIImageScrollLoop)
    {
        [self startTimer];
    }
}

// 调用系统方法动画停止时执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setPageUIWithPage:self.currentPage];
    [self setTitleUIWithPage:self.currentPage];
    
    NSInteger index = _currentPage;
    if (self.scrollMode == UIImageScrollLoop)
    {
        index = _currentPage - 1;
    }
    
    if (self.imageBrowserDidScroll)
    {
        self.imageBrowserDidScroll(index);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = _currentPage;
    if (self.scrollMode == UIImageScrollLoop)
    {
        index = _currentPage - 1;
    }
    
    if (self.imageBrowserDidScroll)
    {
        self.imageBrowserDidScroll(index);
    }
    if (self.deletage && [self.deletage respondsToSelector:@selector(imageBrowserDidScroll:)])
    {
        [self.deletage imageBrowserDidScroll:index];
    }
}

#pragma mark - 


#pragma mark - timer

- (void)stopTimer
{
    if (self.autoAnimation && UIImageScrollLoop == self.scrollMode)
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
    // 只有一张图片时不进行自动播放
    if (self.totalPage <= 1)
    {
        return;
    }
    
    // 自动播放模式，循环显示模式
    if (self.scrollMode == UIImageScrollLoop && self.autoAnimation)
    {
        typeof(self) __weak weakSelf = self;
        [weakSelf performSelector:@selector(startTimerScroll) withObject:nil afterDelay:_autoDuration];
    }
}

- (void)startTimerScroll
{
    if (self.timer == nil)
    {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer timerWithTimeInterval:_autoDuration userInfo:nil repeats:YES handle:^(NSTimer *timer) {
            [weakSelf autoAnimationScroll];
        }];
    }
    [self.timer timerStart];
}

- (void)autoAnimationScroll
{
    self.currentPage++;
    BOOL isAnimation = YES;
    if (self.currentPage >= self.imageArray.count - 1)
    {
        self.currentPage = 1;
        isAnimation = NO;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:isAnimation];
}

#pragma mark - setter

#pragma mark - getter

- (NSMutableArray *)titleArray
{
    if (_titleArray == nil)
    {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil)
    {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSInteger)totalPage
{
    return _images.count;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originXY, originXY, (widthSelf - originXY * 2), sizeLabel)];
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
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((widthSelf - (sizeLabel * self.totalPage)) / 2, (heightSelf - sizeLabel), (sizeLabel * self.totalPage), sizeLabel)];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

- (UILabel *)pageLabel
{
    if (_pageLabel == nil)
    {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthSelf - sizeLabel - originXY), (heightSelf - sizeLabel - originXY), sizeLabel, sizeLabel)];
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
        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(originXY, (heightSelf - sizeLabel) / 2, sizeLabel, sizeLabel)];
        _previousButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _previousButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_previousButton setImage:[UIImage imageNamed:@"previous_normal"] forState:UIControlStateNormal];
        [_previousButton setImage:[UIImage imageNamed:@"previous_highlight"] forState:UIControlStateHighlighted];
        [_previousButton addTarget:self action:@selector(previousClick) forControlEvents:UIControlEventTouchUpInside];
        [_previousButton addTarget:self action:@selector(pressDownClick) forControlEvents:UIControlEventTouchDown];
        [_previousButton addTarget:self action:@selector(pressUpClick) forControlEvents:UIControlEventTouchUpInside];
        
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
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake((widthSelf - sizeLabel - originXY), (heightSelf - sizeLabel) / 2, sizeLabel, sizeLabel)];
        _nextButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_nextButton setImage:[UIImage imageNamed:@"next_normal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"next_highlight"] forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchDown];
        [_nextButton addTarget:self action:@selector(pressDownClick) forControlEvents:UIControlEventTouchDown];
        [_nextButton addTarget:self action:@selector(pressUpClick) forControlEvents:UIControlEventTouchUpInside];
        
        _nextButton.layer.cornerRadius = sizeLabel / 2;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.clipsToBounds = YES;
    }
    return _nextButton;
}

#pragma mark - methord

- (void)reloadData
{
    if (_images && 0 < self.totalPage)
    {
        [self setTitleUI];
        [self setSwitchUI];
        [self setPagePointAndSize];
        
        // 当前有页码
        self.currentPage = _pageIndex;
        if (self.currentPage < 0)
        {
            self.currentPage = 0;
        }
        else if (self.currentPage >= self.totalPage)
        {
            self.currentPage = self.totalPage - 1;
        }
        
        // 数据源
        if (self.showTitle)
        {
            [self.titleArray removeAllObjects];
            [self.titleArray addObjectsFromArray:_titles];
        }
        [self.imageArray removeAllObjects];
        [self.imageArray addObjectsFromArray:_images];
        // 循环时
        if (self.scrollMode == UIImageScrollLoop)
        {
            [self.imageArray addObject:_images.firstObject];
            [self.imageArray insertObject:_images.lastObject atIndex:0];
            
            self.currentPage += 1;
            
            if (self.showTitle)
            {
                [self.titleArray addObject:_titles.firstObject];
                [self.titleArray insertObject:_titles.lastObject atIndex:0];
            }
        }
        
        self.pageControl.numberOfPages = self.totalPage;
        [self setPageUIWithPage:_currentPage];
        [self setTitleUIWithPage:_currentPage];
        
        if (_currentPage != 0)
        {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        [self.collectionView reloadData];
        
        // 自动循环
        [self startTimer];
        
        // 自动显示
        [self setShowAnimationUI];
        
        // 只有一张图时不能拖动
        if (!self.enableWhileSinglePage)
        {
            self.collectionView.scrollEnabled = NO;
        }
    }
}

@end
