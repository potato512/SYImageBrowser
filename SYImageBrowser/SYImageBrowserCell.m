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

- (void)setImageview:(UIImageView *)imageview
{
    _imageview = imageview;
    _imageview.frame = CGRectZero;
    _imageview.backgroundColor = UIColor.clearColor;
    _imageview.clipsToBounds = YES;
    _imageview.layer.masksToBounds = YES;
    _imageview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (SYImageScrollView *)imageScrollView
{
    if (_imageScrollView == nil) {
        _imageScrollView = [[SYImageScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.clipsToBounds = YES;
        _imageScrollView.layer.masksToBounds = YES;
        _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageScrollView;
}

#pragma mark -

- (void)reloadItem
{
    // 隐藏或显示的子视图
    if (self.isBrowser) {
        [self.contentView addSubview:self.imageScrollView];
        self.imageScrollView.hidden = NO;
        self.imageScrollView.imageView = self.imageview;
        // 初始化
        self.imageScrollView.isInitialize = YES;
        // 大小
        if (!CGSizeEqualToSize(self.sizeItem, CGSizeZero)) {
            CGRect rect = self.imageScrollView.frame;
            rect.size.width = self.sizeItem.width;
            rect.size.height = self.sizeItem.height;
            self.imageScrollView.frame = rect;
            
            CGRect rectSubView = self.imageScrollView.imageView.frame;
            rectSubView.size.width = self.sizeItem.width;
            rectSubView.size.height = self.sizeItem.height;
            self.imageScrollView.imageView.frame = rectSubView;
        }
        
        // 单击隐藏回调
        typeof(self) __weak weakSelf = self;
        self.imageScrollView.hiddenClick = ^(){
            if (weakSelf.hiddenClick) {
                weakSelf.hiddenClick();
            }
        };
    } else {
        [self.contentView addSubview:self.imageview];
        // 大小
        if (!CGSizeEqualToSize(self.sizeItem, CGSizeZero)) {
            CGRect rect = self.imageview.frame;
            rect.size.width = self.sizeItem.width;
            rect.size.height = self.sizeItem.height;
            self.imageview.frame = rect;
        }
    }
}

@end
