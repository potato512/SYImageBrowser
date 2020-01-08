//
//  SYImageBrowserCell.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowserCell.h"
#import "SYImageScrollView.h"

@interface SYImageBrowserCell ()

@property (nonatomic, strong) SYImageScrollView *imageScrollView;

@end

@implementation SYImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark - setter/getter

- (void)setShowView:(UIView *)showView
{
    _showView = showView;
    if (_showView) {
        _showView.frame = CGRectZero;
        _showView.backgroundColor = UIColor.clearColor;
        _showView.clipsToBounds = YES;
        _showView.layer.masksToBounds = YES;
        _showView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (SYImageScrollView *)imageScrollView
{
    if (_imageScrollView == nil) {
        _imageScrollView = [[SYImageScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.clipsToBounds = YES;
        _imageScrollView.layer.masksToBounds = YES;
        _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:self.imageScrollView];
    }
    return _imageScrollView;
}

#pragma mark -

- (void)reloadItem
{
    // 隐藏或显示的子视图
    if (self.isBrowser) {
        self.imageScrollView.showView = self.showView;
        self.imageScrollView.hidden = NO;
        // 初始化
        self.imageScrollView.isInitialize = YES;
        // 大小
        if (!CGSizeEqualToSize(self.sizeItem, CGSizeZero)) {
            CGRect rect = self.imageScrollView.frame;
            rect.size.width = self.sizeItem.width;
            rect.size.height = self.sizeItem.height;
            self.imageScrollView.frame = rect;
            
            CGRect rectSubView = self.imageScrollView.showView.frame;
            rectSubView.size.width = self.sizeItem.width;
            rectSubView.size.height = self.sizeItem.height;
            self.imageScrollView.showView.frame = rectSubView;
        }
        
        // 单击隐藏回调
        typeof(self) __weak weakSelf = self;
        self.imageScrollView.hiddenClick = ^(){
            if (weakSelf.hiddenClick) {
                weakSelf.hiddenClick();
            }
        };
    } else {
        [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.contentView addSubview:self.showView];
        // 大小
        if (!CGSizeEqualToSize(self.sizeItem, CGSizeZero)) {
            CGRect rect = self.showView.frame;
            rect.size.width = self.sizeItem.width;
            rect.size.height = self.sizeItem.height;
            self.showView.frame = rect;
        }
    }
}

@end
