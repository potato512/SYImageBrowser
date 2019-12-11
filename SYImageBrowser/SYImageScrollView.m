//
//  SYImageScrollView.m
//  zhangshaoyu
//
//  Created by herman on 2017/8/16.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYImageScrollView.h"

static CGFloat const scaleMin = 1.0;
static CGFloat const scaleMax = 2.0;

@interface SYImageScrollView () <UIScrollViewDelegate>
{
    BOOL isScaleBig;
}

@end

@implementation SYImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 两个手指拿捏缩放
        self.minimumZoomScale = scaleMin;
        self.maximumZoomScale = scaleMax;
        self.delegate = self;
        
        isScaleBig = NO;
    }
    return self;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // 设置被缩放的对应视图
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 居中显示
    [self centerShow:scrollView imageview:self.imageView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // 缩放效果
    // 放大或缩小
    if (scrollView.minimumZoomScale >= scale) {
        [scrollView setZoomScale:scaleMin animated:YES];
        isScaleBig = NO;
    }
    if (scrollView.maximumZoomScale <= scale) {
        [scrollView setZoomScale:scaleMax animated:YES];
        isScaleBig = YES;
    }
}

#pragma mark - 手势

- (void)addGesture
{
    // 双击缩放
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    doubleTap.numberOfTapsRequired = 2;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:doubleTap];
    
    // 单击隐藏
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
    
    // 区分单双击
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)doubleClick:(UITapGestureRecognizer *)gestureRecognizer
{
    // 先放大，后缩小
    if (isScaleBig) {
        [self setZoomScale:scaleMin animated:YES];
        isScaleBig = NO;
    } else {
        [self setZoomScale:scaleMax animated:YES];
        isScaleBig = YES;
    }
}

- (void)singleClick:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.hiddenClick) {
        self.hiddenClick();
    }
}

#pragma mark -

- (void)centerShow:(UIScrollView *)scrollview imageview:(UIImageView *)imageview
{
    // 居中显示
    CGFloat offsetX = (scrollview.bounds.size.width > scrollview.contentSize.width) ? (scrollview.bounds.size.width - scrollview.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollview.bounds.size.height > scrollview.contentSize.height) ?
    (scrollview.bounds.size.height - scrollview.contentSize.height) * 0.5 : 0.0;
    imageview.center = CGPointMake(scrollview.contentSize.width * 0.5 + offsetX, scrollview.contentSize.height * 0.5 + offsetY);
}

#pragma mark - setter

- (void)setIsInitialize:(BOOL)isInitialize
{
    _isInitialize = isInitialize;
    if (_isInitialize) {
        isScaleBig = NO;
        [self setZoomScale:scaleMin animated:NO];
        [self centerShow:self imageview:self.imageView];
    }
}

- (void)setImageView:(UIImageView *)imageView
{
    if (_imageView == imageView) {
        return;
    }
    _imageView = imageView;
    if (_imageView) {
        [self addSubview:_imageView];
        _imageView.frame = self.bounds;
        _imageView.backgroundColor = UIColor.clearColor;
        _imageView.clipsToBounds = YES;
        _imageView.layer.masksToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addGesture];
    }
}

@end
