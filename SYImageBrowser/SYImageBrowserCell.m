//
//  SYImageBrowserCell.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowserCell.h"

@implementation SYImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        [self.contentView addSubview:_imageview];
        _imageview.backgroundColor = [UIColor clearColor];
        _imageview.clipsToBounds = YES;
        _imageview.layer.masksToBounds = YES;
        _imageview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

@end
