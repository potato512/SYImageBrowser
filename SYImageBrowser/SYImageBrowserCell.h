//
//  SYImageBrowserCell.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/10.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const identifierSYImageBrowserCell = @"SYImageBrowserCell";

@interface SYImageBrowserCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageview;

/// 重置大小
@property (nonatomic, assign) CGSize sizeItem;
/// 浏览时缩放模式图片
@property (nonatomic, assign) BOOL isBrowser;
/// 单击隐藏回调
@property (nonatomic, copy) void (^hiddenClick)(void);

/// 刷新信息
- (void)reloadItem;

@end
