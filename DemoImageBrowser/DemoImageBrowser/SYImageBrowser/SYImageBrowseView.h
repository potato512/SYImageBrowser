//
//  SYImageBrowseView.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/11/8.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYImageBrowseView : UIImageView

/// 点击响应回调-单击
@property (nonatomic, copy) void (^imageClick)(void);

/// 设置图片（网络图片/本地图片+默认图片）
- (void)setImage:(id)object defaultImage:(UIImage *)image;

@end
