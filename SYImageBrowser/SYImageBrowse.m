//
//  SYImageBrowse.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowse.h"
#import "SYImageBrowseHelper.h"

static CGFloat const originXY = 10.0;
static CGFloat const sizePageControl = 15.0;
static CGFloat const heightPageControl = 30.0;
static CGFloat const heightlabel = 30.0;
static CGFloat const sizePagelabel = 40.0;
static NSTimeInterval const durationTime = 3.0;

@interface SYImageBrowse () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) SYImageBrowseView *firstImageView;
@property (nonatomic, strong) SYImageBrowseView *secondImageView;
@property (nonatomic, strong) SYImageBrowseView *thirdImageView;


@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *textlabel;
@property (nonatomic, strong) UILabel *pagelabel;

@property (nonatomic, assign) NSInteger pageCount;    // 总页数
@property (nonatomic, assign) NSInteger currentPage;  // 当前页数
@property (nonatomic, assign) CGFloat currentOffX;    // 当前偏移量
@property (nonatomic, strong) id firstImage;
@property (nonatomic, strong) id secondImage;
@property (nonatomic, strong) id thirdImage;

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation SYImageBrowse

#pragma mark - 视图初始化

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.superView = [UIApplication sharedApplication].delegate.window;
        self.frame = self.superView.bounds;
    }
    
    return self;
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.superView = [UIApplication sharedApplication].delegate.window;
        self.frame = self.superView.bounds;
        if (view)
        {
            self.superView = view;
            self.frame = frame;
        }
        
        [self.superView addSubview:self];
        
        [self setUI];
    }
    
    return self;
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)removeFromSuperview
{
    [self stopTimer];
    [super removeFromSuperview];
}

// 图片视图
- (void)setUI
{
    self.mainScrollView.frame = self.bounds;
    [self addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
    self.mainScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0.0);
    
    self.firstImageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds));
    [self.mainScrollView addSubview:self.firstImageView];
    
    self.secondImageView.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.bounds), 0.0, CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds));
    [self.mainScrollView addSubview:self.secondImageView];
    
    self.thirdImageView.frame = CGRectMake(CGRectGetWidth(self.mainScrollView.bounds) * 2, 0.0, CGRectGetWidth(self.mainScrollView.bounds), CGRectGetHeight(self.mainScrollView.bounds));
    [self.mainScrollView addSubview:self.thirdImageView];
    
    // pageControl
    self.pageControl.frame = CGRectMake(0.0, (CGRectGetHeight(self.bounds) - heightPageControl), CGRectGetWidth(self.bounds), heightPageControl);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.pageControl];
    self.pageControl.hidden = NO;
    
    // pagelabel
    self.pagelabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - sizePagelabel - originXY), (CGRectGetHeight(self.bounds) - sizePagelabel - originXY), sizePagelabel, sizePagelabel);
    [self addSubview:self.pagelabel];
    self.pagelabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.pagelabel.hidden = YES;
    
    self.textlabel.frame = CGRectMake(originXY, (CGRectGetHeight(self.bounds) - heightlabel), (CGRectGetWidth(self.bounds) - originXY * 2), heightlabel);
    [self addSubview:self.textlabel];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.textlabel.hidden = YES;
}

// 改变图片视图，标题
- (void)resetPageUI
{
    // 改变标题
    if (self.titles && 0 < self.titles.count)
    {
        if (self.currentPage <= (self.titles.count - 1))
        {
            // 避免数据源个数不统一时异常
            NSString *title = self.titles[self.currentPage];
            self.textlabel.text = title;
        }
        else
        {
            self.textlabel.text = @"";
        }
    }
    
    [self setPageControlHidden];
    // 改变页码
    // pageControl
    self.pageControl.currentPage = self.currentPage;
    // pagelabel
    [self resetPagelabelUI];
    
    // 改变图片
    NSInteger firstIndex = self.currentPage - 1;
    firstIndex = (firstIndex < 0 ? (self.pageCount - 1) : firstIndex);
    id imageObjectFirst = self.images[firstIndex];
    id imageObjectSecond = self.images[self.currentPage];
    NSInteger lastIndex = self.currentPage + 1;
    lastIndex = (lastIndex >= self.pageCount ? 0 : lastIndex);
    id imageObjectThird = self.images[lastIndex];
    
    self.firstImage = imageObjectFirst;
    self.secondImage = imageObjectSecond;
    self.thirdImage = imageObjectThird;
    // SDWebImage
    [self.firstImageView setImage:self.firstImage defaultImage:self.defaultImage];
    [self.secondImageView setImage:self.secondImage defaultImage:self.defaultImage];
    [self.thirdImageView setImage:self.thirdImage defaultImage:self.defaultImage];
}

// 设置页码控制器隐藏或显示
- (void)setPageControlHidden
{
    if (ImagePageControl == _pageMode)
    {
        self.pagelabel.hidden = YES;
        
        //        self.pageControl.hidden = NO;
        self.pageControl.hidden = !_showPageControl;
    }
    else if (ImagePagelabel == _pageMode)
    {
        //        self.pagelabel.hidden = NO;
        self.pagelabel.hidden = !_showPageControl;
        
        self.pageControl.hidden = YES;
    }
}

// 改变页码pageControl位置
- (void)resetPageControlUI
{
    CGFloat widthPageControl = self.pageCount * sizePageControl;
    
    CGRect rectText = self.textlabel.frame;
    rectText.size.width = CGRectGetWidth(self.bounds) - originXY * 3 - widthPageControl;
    self.textlabel.frame = rectText;
    
    CGFloat originXPageControl = (CGRectGetWidth(self.bounds) - widthPageControl) / 2;
    if (self.showText)
    {
        originXPageControl = (CGRectGetWidth(self.bounds) - widthPageControl - originXY);
    }
    else
    {
        if (pageControlAlignmentCenter == self.pageAlignmentMode)
        {
            originXPageControl = (CGRectGetWidth(self.bounds) - widthPageControl) / 2;
        }
        else if (pageControlAlignmentRight == self.pageAlignmentMode)
        {
            originXPageControl = (CGRectGetWidth(self.bounds) - widthPageControl - originXY);
        }
    }
    CGRect rectPageControl = self.pageControl.frame;
    rectPageControl.origin.x = originXPageControl;
    rectPageControl.size.width = widthPageControl;
    self.pageControl.frame = rectPageControl;
}

// 改变页码pagelabel的字段颜色
- (void)resetPagelabelUI
{
    if (self.pageNormalColor || self.pageSelectedColor)
    {
        NSString *currentPageStr = [[NSString alloc] initWithFormat:@"%ld", (self.currentPage + 1)];
        NSMutableAttributedString *currentPageAtt = [[NSMutableAttributedString alloc] initWithString:currentPageStr];
        
        NSString *normalPageStr = [[NSString alloc] initWithFormat:@"%ld", self.pageCount];
        NSMutableAttributedString *normalPageAtt = [[NSMutableAttributedString alloc] initWithString:normalPageStr];
        
        if (self.pageSelectedColor)
        {
            [SYImageBrowseHelper AttributedString:currentPageAtt text:currentPageStr font:self.textlabel.font color:_pageSelectedColor bgColor:NO];
        }
        if (self.pageNormalColor)
        {
            [SYImageBrowseHelper AttributedString:normalPageAtt text:normalPageStr font:self.textlabel.font color:_pageNormalColor bgColor:NO];
        }
        
        NSMutableAttributedString *pageAttributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:currentPageAtt];
        NSAttributedString *signAttStr = [[NSAttributedString alloc] initWithString:@"/"];
        [pageAttributedStr appendAttributedString:signAttStr];
        [pageAttributedStr appendAttributedString:normalPageAtt];
        self.pagelabel.attributedText = pageAttributedStr;
    }
    else
    {
        self.pagelabel.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (self.currentPage + 1), self.pageCount];
    }
}

#pragma mark - 响应事件

- (void)hiddenClick
{
    if (self.imageSelected)
    {
        self.imageSelected(self.currentPage);
    }
}

- (void)deleteClick
{
    // 回调处理
    if (self.imageDelete)
    {
        self.imageDelete(self.currentPage);
    }
    
    // 改变图片源
    [self.images removeObjectAtIndex:self.currentPage];
    // 改变标题源
    [self.titles removeObjectAtIndex:self.currentPage];
    self.pageCount = self.images.count;
    if (self.currentPage >= self.pageCount - 1)
    {
        self.currentPage = (1 == self.pageCount ? 0 : (self.pageCount - 1));
    }
    if (1 <= self.pageCount)
    {
        [self resetPageUI];
        // 设置滚动响应
        self.mainScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
    }
    else
    {
        [self removeFromSuperview];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView)
    {
        CGFloat offX = self.mainScrollView.contentOffset.x;
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
        [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mainScrollView.bounds), 0.0) animated:NO];
    }
}

#pragma mark - setter

#pragma mark 图片视图

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView)
    {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.scrollEnabled = YES;
        
        _mainScrollView.delegate = self;
    }
    
    return _mainScrollView;
}

// SDWebImage

- (UIImageView *)firstImageView
{
    if (!_firstImageView)
    {
        _firstImageView = [[SYImageBrowseView alloc] init];
        _firstImageView.backgroundColor = [UIColor clearColor];
        _firstImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _firstImageView;
}

- (UIImageView *)secondImageView
{
    if (!_secondImageView)
    {
        _secondImageView = [[SYImageBrowseView alloc] init];
        _secondImageView.backgroundColor = [UIColor clearColor];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        SYImageBrowse __weak *weakSelf = self;
        _secondImageView.imageClick = ^(){
            [weakSelf hiddenClick];
        };
    }
    
    return _secondImageView;
}

- (UIImageView *)thirdImageView
{
    if (!_thirdImageView)
    {
        _thirdImageView = [[SYImageBrowseView alloc] init];
        _thirdImageView.backgroundColor = [UIColor clearColor];
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _thirdImageView;
}



- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    
    return _pageControl;
}

- (UILabel *)pagelabel
{
    if (!_pagelabel)
    {
        _pagelabel = [[UILabel alloc] init];
        _pagelabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        _pagelabel.textColor = [UIColor whiteColor];
        _pagelabel.textAlignment = NSTextAlignmentCenter;
        _pagelabel.font = [UIFont systemFontOfSize:12.0];
        
        _pagelabel.layer.cornerRadius = sizePagelabel / 2;
        _pagelabel.layer.masksToBounds = YES;
    }
    
    return _pagelabel;
}

- (UILabel *)textlabel
{
    if (!_textlabel)
    {
        _textlabel = [[UILabel alloc] init];
        _textlabel.backgroundColor = [UIColor clearColor];
        _textlabel.textColor = [UIColor whiteColor];
        
        _textlabel.textColor = [UIColor whiteColor];
        _textlabel.textAlignment = NSTextAlignmentLeft;
        _textlabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    return _textlabel;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton)
    {
        UIImage *deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
        CGFloat widthImage = 50.0;
        CGFloat heightImage = deleteImage.size.height * widthImage / deleteImage.size.width;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - widthImage - 10.0), 10.0, widthImage, heightImage);
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

- (NSTimer *)scrollTimer
{
    if (!_scrollTimer)
    {
        _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:durationTime target:self selector:@selector(autoPlayScroll) userInfo:nil repeats:YES];
        
        [self stopTimer];
    }
    
    return _scrollTimer;
}

#pragma mark getter

- (CGFloat)currentOffX
{
    return CGRectGetWidth(self.mainScrollView.bounds);
}

#pragma mark 数据源

- (void)setImageSource:(NSArray *)imageSource
{
    _imageSource = imageSource;
    if (_imageSource && 0 < _imageSource.count)
    {
        self.images = [[NSMutableArray alloc] initWithArray:_imageSource];
        self.pageCount = self.images.count;
        self.currentPage = 0;
        
        // 设置页码
        // 1 pageControl
        self.pageControl.numberOfPages = self.pageCount;
        self.pageControl.currentPage = self.currentPage;
        self.pageControl.hidden = (1 == self.pageCount ? YES : NO);
        // 2 pagelabel
        [self resetPagelabelUI];
        // 3
        [self resetPageControlUI];
        
        if (0 != self.pageIndex)
        {
            NSInteger index = self.pageIndex - 1;
            self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
            
            // 设置滚动响应
            self.mainScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
            
            // 改变图片视图，标题
            [self resetPageUI];
        }
        else
        {
            // 设置滚动响应
            self.mainScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
            
            if (1 >= self.pageCount)
            {
                id imageObject = self.images.firstObject;
                
                self.secondImage = imageObject;
            }
            else
            {
                id imageObjectFirst = self.images.lastObject;
                id imageObjectSecond = self.images.firstObject;
                id imageObjectThird = self.images[1];
                
                self.firstImage = imageObjectFirst;
                self.secondImage = imageObjectSecond;
                self.thirdImage = imageObjectThird;
            }
            
            // SDWebImage
            [self.firstImageView setImage:self.firstImage defaultImage:self.defaultImage];
            [self.secondImageView setImage:self.secondImage defaultImage:self.defaultImage];
            [self.thirdImageView setImage:self.thirdImage defaultImage:self.defaultImage];
            
            if (self.isAutoPlay)
            {
                //                [self startTimer];
                [self performSelector:@selector(startTimer) withObject:nil afterDelay:durationTime];
            }
        }
    }
}

- (void)setTitleSource:(NSArray *)titleSource
{
    _titleSource = titleSource;
    if (_titleSource && 0 < _titleSource.count)
    {
        self.titles = [[NSMutableArray alloc] initWithArray:_titleSource];
        NSString *title = self.titles[self.currentPage];
        self.textlabel.text = title;
    }
}

- (void)setBrowseMode:(ImageBrowseMode)browseMode
{
    _browseMode = browseMode;
    if (ImageBrowseAdvertisement == _browseMode)
    {
        // 可以点击跳转其他视图，可以设置自动播放，可以循环播放
        // 不能点击退出浏览，不能有删除按钮，不能定位第N张图片
    }
    else if (ImageBrowseView == _browseMode)
    {
        // 不可以点击跳转其他视图，不可以自动播
        // 可以点击退出浏览，可以有删除按钮，可以定位第N张图片，可以循环播放
    }
}

- (void)setPageMode:(ImagePageMode)pageMode
{
    _pageMode = pageMode;
    
    [self setPageControlHidden];
}

- (void)setPageAlignmentMode:(PageControlAlignmentMode)pageAlignmentMode
{
    _pageAlignmentMode = pageAlignmentMode;
    
    [self resetPageControlUI];
}

- (void)setPageSelectedColor:(UIColor *)pageSelectedColor
{
    _pageSelectedColor = pageSelectedColor;
    self.pageControl.currentPageIndicatorTintColor = _pageSelectedColor;
    
    [self resetPagelabelUI];
}

- (void)setPageNormalColor:(UIColor *)pageNormalColor
{
    _pageNormalColor = pageNormalColor;
    self.pageControl.pageIndicatorTintColor = _pageNormalColor;
    
    [self resetPagelabelUI];
}

- (void)setShowText:(BOOL)showText
{
    _showText = showText;
    self.textlabel.hidden = !_showText;
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    [self setPageControlHidden];
}

- (void)setTextMode:(TextAlignmentMode)textMode
{
    _textMode = textMode;
    if (textAlignmentLeft == _textMode)
    {
        self.textlabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (textAlignmentCenter == _textMode)
    {
        self.textlabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (textAlignmentLeft == _textMode)
    {
        self.textlabel.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setShowDeleteButton:(BOOL)showDeleteButton
{
    _showDeleteButton = showDeleteButton;
    
    self.deleteButton.hidden = !_showDeleteButton;
    if (!self.deleteButton.superview)
    {
        [self addSubview:self.deleteButton];
    }
}

- (void)setImageContentMode:(ImageContentModeMode)imageContentMode
{
    _imageContentMode = imageContentMode;
    
    if (ImageContentFit == _imageContentMode)
    {
        self.firstImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.secondImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.thirdImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if (ImageContentFill == _imageContentMode)
    {
        self.firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    
    if (0 == self.pageCount)
    {
        return;
    }
    
    NSInteger index = _pageIndex - 1;
    self.currentPage = (index < 0 ? 0 : (index >= self.pageCount ? (self.pageCount - 1) : index));
    
    // 设置滚动响应
    _mainScrollView.scrollEnabled = (1 >= self.pageCount ? NO : YES);
    
    // 改变图片视图，标题
    [self resetPageUI];
}

- (void)setIsAutoPlay:(BOOL)isAutoPlay
{
    _isAutoPlay = isAutoPlay;
    
    if (_isAutoPlay)
    {
        //        [self startTimer];
        [self performSelector:@selector(startTimer) withObject:nil afterDelay:durationTime];
    }
    else
    {
        [self stopTimer];
    }
}

#pragma mark - 自动播放

- (void)autoPlayScroll
{
    if (1 < self.pageCount)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mainScrollView.bounds) * 2, 0.0)];
            
        } completion:^(BOOL finished) {
            
            // 向左翻页
            self.currentPage++;
            self.currentPage = (self.currentPage >= self.pageCount ? 0 : self.currentPage);
            [self resetPageUI];
            
            // 改变offset
            [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mainScrollView.bounds), 0.0) animated:NO];
        }];
    }
}

#pragma mark - 定时器

- (void)stopTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (![self.scrollTimer isValid])
    {
        return ;
    }
    [self.scrollTimer setFireDate:[NSDate distantFuture]];
}

- (void)startTimer
{
    if (self.imageSource && 0 != self.imageSource.count)
    {
        if (![self.scrollTimer isValid])
        {
            return ;
        }
        [self.scrollTimer setFireDate:[NSDate date]];
    }
}

@end
