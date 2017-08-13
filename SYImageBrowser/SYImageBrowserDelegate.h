//
//  SYImageBrowserDelegate.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 2017/8/13.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYImageBrowserDelegate <NSObject>

/// 滚动时的索引代理
- (void)imageBrowserDidScroll:(NSInteger)index;

@end
