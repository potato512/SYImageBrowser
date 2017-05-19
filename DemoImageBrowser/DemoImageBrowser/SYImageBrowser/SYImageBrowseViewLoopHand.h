//
//  SYImageBrowseViewLoopHand.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYImageBrowseHelper.h"

@interface SYImageBrowseViewLoopHand : UIView

/// 图片信息
@property (nonatomic, strong) NSArray *images;

/// 图片点击回调
@property (nonatomic, copy) void (^imageClick)(NSInteger index);
/// 图片滚动回调
@property (nonatomic, copy) void (^imageScroll)(NSInteger index);

/// 图片显示样式（等比例显示，放大显示，默认放大）
@property (nonatomic, assign) SYImageBrowseContentMode imageContentMode;

/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger pageIndex;

/// 默认图片
@property (nonatomic, strong) UIImage *defaultImage;

/// 刷新信息（最后调用）
- (void)reloadData;

@end
