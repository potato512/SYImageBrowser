//
//  SYImageBrowserScrollView.h
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//  图标浏览

#import <UIKit/UIKit.h>
#import "SYImageBrowseHelper.h"

@interface SYImageBrowseScrollView : UIScrollView

/// 图片
@property (nonatomic, strong) SYImageBrowseUIImageView *imageBrowseView;

/// 开启或关闭双击事件（默认开启）
@property (nonatomic, assign) BOOL isDoubleEnable;

/// 恢复原始大小
@property (nonatomic, assign) BOOL isOriginal;

@end
