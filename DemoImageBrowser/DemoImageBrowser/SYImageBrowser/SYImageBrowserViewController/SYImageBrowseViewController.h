//
//  SYImageBrowseViewController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/10.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  图片浏览视图控制器（可删除操作，或图片进行放大缩小）

#import <UIKit/UIKit.h>

/// 删除按钮显示类型（不显示，显示文字标题，显示图标）
typedef NS_ENUM(NSInteger, SYImageBrowserDeleteType)
{
    /// 删除按钮显示类型-显示文字标题
    SYImageBrowserDeleteTypeText = 1,
    
    /// 删除按钮显示类型-显示图标
    SYImageBrowserDeleteTypeImage = 2
};

@interface SYImageBrowseViewController : UIViewController

/// 图片源数组（UIImage类型）
@property (nonatomic, strong) NSArray *imageArray;

/// 图片当前页码
@property (nonatomic, assign) NSInteger imageIndex;

/// 删除按钮显示类型（默认显示不显示，显示文字标题，显示图标）
@property (nonatomic, assign) SYImageBrowserDeleteType deleteType;

/// 图片删除回调
@property (nonatomic, copy) void (^ImageDelete)(NSArray *array);

@end

/*
 使用说明

 // 初始化图片浏览器
 SYImageBrowseViewController *browseVC = [[SYImageBrowseViewController alloc] init];
 // 图片浏览器图片数组
 browseVC.imageArray = images;
 // 图片浏览器当前显示第几张图片
 browseVC.imageIndex = indexImg;
 // 图片浏览器浏览回调（删除图片后图片数组）
 browseVC.ImageDelete = ^(NSArray *array){
    NSLog(@"array %@", array);
 
    // 如果有引用其他属性，注意弱引用（避免循环引用，导致内存未释放）
 };
 // 图片浏览器跳转
 [self.navigationController pushViewController:browseVC animated:YES];

 */