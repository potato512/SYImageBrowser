//
//  UIImageView+SYImageBrowser.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/5/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "UIImageView+SYImageBrowser.h"
/// 使用SDWebImage
#import "UIImageView+WebCache.h"

@implementation UIImageView (SYImageBrowser)

/// 设置图片（网络图片/本地图片+默认图片）
- (void)setImage:(id)object defaultImage:(UIImage *)image
{
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    if ([object isKindOfClass:[NSString class]]) {
        if ([object hasPrefix:@"http://"] || [object hasPrefix:@"https://"]) {
            // 图片网络地址，即http://，或https://
            NSURL *imageUrl = [NSURL URLWithString:object];
            if (image) {
                if ([self respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:)])
                {
                    [self sd_setImageWithURL:imageUrl placeholderImage:image];
                }
            } else {
                [self sd_setImageWithURL:imageUrl];
            }
        } else {
            // 图片名称，即NSString类型
            self.image = [UIImage imageNamed:object];
        }
    } else if ([object isKindOfClass:[UIImage class]]) {
        // 图片，即UIImage类型
        self.image = object;
    }
}

@end
