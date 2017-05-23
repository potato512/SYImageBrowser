//
//  SYImageBrowserScrollView.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseScrollView.h"

@interface SYImageBrowseScrollView () <UIScrollViewDelegate>

// 是否改变了大小
@property (nonatomic, assign) BOOL isScale;

@end

@implementation SYImageBrowseScrollView

#pragma mark - 实例化

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setDefaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaultInit];
        self.imageBrowseView.frame = self.bounds;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.imageBrowseView.frame = self.bounds;
}

- (void)setDefaultInit
{
    self.delegate = self;
    self.minimumZoomScale = SYImageBrowseScaleMin;
    self.maximumZoomScale = SYImageBrowseScaleMax;
    
    _isDoubleEnable = YES;
    [self addSubview:self.imageBrowseView];
    
    [self doubleRecognizer];
}

#pragma mark - 响应

- (void)doubleRecognizer
{
    // 双击事件放大，或缩小手势
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
    tapRecognizer.numberOfTapsRequired = 2;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapRecognizer];
}

- (void)doubleClick
{
    if (!_isDoubleEnable)
    {
        return;
    }
    
    CGFloat scale = self.zoomScale;
    if (SYImageBrowseScaleMin == scale)
    {
        [self setZoomScale:(scale / SYImageBrowseScaleMin) animated:YES];
    }
    else
    {
        [self setZoomScale:(scale * SYImageBrowseScaleMin) animated:YES];
    }
}

#pragma mark 居中显示

- (void)imageShowInCenter
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width) ? (self.bounds.size.width - self.contentSize.width) * SYImageBrowseScaleMin : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height) ? (self.bounds.size.height - self.contentSize.height) * SYImageBrowseScaleMin : 0.0;
    self.imageBrowseView.center = CGPointMake(self.contentSize.width * SYImageBrowseScaleMin + offsetX, self.contentSize.height * SYImageBrowseScaleMin + offsetY);
}

#pragma mark - setter

- (void)setIsOriginal:(BOOL)isOriginal
{
    _isOriginal = isOriginal;
    if (_isOriginal && self.isScale)
    {
        CGFloat scale = self.zoomScale;
        if (SYImageBrowseScaleMin == scale)
        {
            [self setZoomScale:(scale / SYImageBrowseScaleMin) animated:YES];
        }
        else
        {
            [self setZoomScale:(scale * SYImageBrowseScaleMin) animated:YES];
        }
    }
}

#pragma mark - getter

- (SYImageBrowseUIImageView *)imageBrowseView
{
    if (_imageBrowseView == nil)
    {
        _imageBrowseView = [[SYImageBrowseUIImageView alloc] init];
    }
    
    return _imageBrowseView;
}

- (BOOL)isScale
{
    if (self.zoomScale == 1.0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // 设置被缩放的视图
    return self.imageBrowseView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 居中显示
    [self imageShowInCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // 缩放效果，放大或缩小
    if (scrollView.minimumZoomScale >= scale)
    {
        [scrollView setZoomScale:SYImageBrowseScaleMin animated:YES];
    }
    if (scrollView.maximumZoomScale <= scale)
    {
        [scrollView setZoomScale:SYImageBrowseScaleMax animated:YES];
    }
}

@end
