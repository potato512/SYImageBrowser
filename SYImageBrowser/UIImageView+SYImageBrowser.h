//
//  UIImageView+SYImageBrowser.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/5/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SYImageBrowser)

/// 设置图片（网络图片/本地图片+默认图片）
- (void)setImage:(id)object defaultImage:(UIImage *)image;

@end
