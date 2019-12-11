//
//  SYImageBrowserDelegate.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/13.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYImageBrowser;

@protocol SYImageBrowserDelegate <NSObject>

@required
/// 图片数量
- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser;
/// 图片显示
- (UIImageView *)imageBrowser:(SYImageBrowser *)browser imageAtIndex:(NSInteger)index;

@optional
/// 滚动时的索引代理
- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index;
/// 点击操作
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index;

/// 标题显示
- (NSString *)imageBrowser:(SYImageBrowser *)browser titleAtIndex:(NSInteger)index;

/// 图片滚动响应（contentOffX滚动距离；direction表示方向，1向左，2向右；isEnd表示最左或最右边）
- (void)imageBrowser:(SYImageBrowser *)browser direction:(NSInteger)direction contentOffX:(CGFloat)offX end:(BOOL)isEnd;

@end
