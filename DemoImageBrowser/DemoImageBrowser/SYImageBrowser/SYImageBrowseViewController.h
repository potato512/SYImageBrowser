//
//  SYImageBrowseViewController.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/10.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  图片浏览视图控制器（操作类型：删除图片、双击放大缩小图片、单击图片）
//  github：https://github.com/potato512/SYImageBrowser

#import <UIKit/UIKit.h>
#import "SYImageBrowseHelper.h"

@interface SYImageBrowseViewController : UIViewController

/// 图片源数组（UIImage类型）
@property (nonatomic, strong) NSArray *imageArray;

/// 图片当前页码
@property (nonatomic, assign) NSInteger imageIndex;

/// 图片显示样式（等比例显示，或放大显示，默认放大）
@property (nonatomic, assign) SYImageBrowseContentMode imageContentMode;

/// 删除按钮显示类型（默认显示不显示，显示文字标题，显示图标）
@property (nonatomic, assign) SYImageBrowserDeleteType deleteType;
/// 标题（默认删除）
@property (nonatomic, strong) NSString *deleteTitle;
/// 标题颜色（默认黑色）
@property (nonatomic, strong) UIColor *deleteTitleColor;
/// 标题颜色高亮（默认灰色）
@property (nonatomic, strong) UIColor *deleteTitleColorHighlight;
/// 标题字体大小（默认14）
@property (nonatomic, strong) UIFont *deleteTitleFont;
/// 标题图标（默认垃圾桶）
@property (nonatomic, strong) UIImage *deleteImage;
/// 背景颜色
@property (nonatomic, strong) UIColor *imageBgColor;

/// 图片删除回调
@property (nonatomic, copy) void (^ImageDelete)(NSArray *array);
/// 图片点击回调
@property (nonatomic, copy) void (^ImageClick)(NSInteger index);

/// 刷新信息（最后调用）
- (void)reloadData;

@end

/*
 使用示例：
 // 初始化图片浏览器
 SYImageBrowseViewController *browseVC = [[SYImageBrowseViewController alloc] init];
 // 背景颜色
 browseVC.imageBgColor = [UIColor orangeColor];
 // 图片显示模式
 browseVC.imageContentMode = SYImageBrowseContentFit;
 // 删除按钮类型
 browseVC.deleteType = SYImageBrowserDeleteTypeText;
 browseVC.deleteTitle = @"Delete";
 browseVC.deleteTitleFont = [UIFont boldSystemFontOfSize:13.0];
 browseVC.deleteTitleColor = [UIColor blackColor];
 browseVC.deleteTitleColorHighlight = [UIColor redColor];
 // 图片浏览器图片数组
 browseVC.imageArray = @[...];
 // 图片浏览器当前显示第几张图片
 browseVC.imageIndex = 3;
 // 图片浏览器浏览回调（删除图片后图片数组）
 browseVC.ImageDelete = ^(NSArray *array){
     NSLog(@"array %@", array);
     // 如果有引用其他属性，注意弱引用（避免循环引用，导致内存未释放）
 };
 // 图片点击回调
 browseVC.ImageClick = ^(NSInteger index){
     NSLog(@"点击了第 %@ 张图片", @(index));
 };
 // 刷新数据
 [browseVC reloadData];
 // 图片浏览器跳转
 [self.navigationController pushViewController:browseVC animated:YES];
 
 */


