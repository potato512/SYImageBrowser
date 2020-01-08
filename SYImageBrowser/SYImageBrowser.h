//
//  SYImageBrowser.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/10/23.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//  github：https://github.com/potato512/SYImageBrowser


#import <UIKit/UIKit.h>
#import "SYImageBrowserDelegate.h"

@interface SYImageBrowser : UIView

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UIImageScrollDirection)direction;

/// 限制使用init/initWithFrame方法
- (instancetype)init __attribute__((unavailable("init 方法不可用")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame 方法不可用")));

/// 当且仅当只有一张图片时，是否显示页签（默认NO，即显示）
@property (nonatomic, assign) BOOL hiddenWhileSinglePage;

/// 默认UIImagePageControl
@property (nonatomic, assign) UIImagePageControlType pageControlType;
/// 默认显示底端居中
@property (nonatomic, strong) UIPageControl *pageControl;
/// 默认显示底端居右
@property (nonatomic, strong) UILabel *pageLabel;

/// 页码位置
@property (nonatomic, assign) CGPoint pagePoint;
/// 页码大小
@property (nonatomic, assign) CGSize pageSize;


/// 自动播放（默认非自动播放；且在UIImageScrollLoop模式下有效）
@property (nonatomic, assign) BOOL autoAnimation;
/// 自动播放时间间隔（默认3秒）
@property (nonatomic, assign) NSTimeInterval autoDuration;

/// 默认UIImageScrollNormal
@property (nonatomic, assign) UIImageScrollMode scrollMode;


/// 图片浏览定位（即当前显示第N张，默认第一张）
@property (nonatomic, assign) NSInteger currentPage;

/// 调用这些方法，属性时，表示图片被浏览
/// 默认淡入动画（默认NO）
@property (nonatomic, assign) BOOL isBrowser;

/// 代理
@property (nonatomic, weak) id<SYImageBrowserDelegate> deletage;

/// 数据刷新
- (void)reloadData;

@end

/*
 
 使用示例
 NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
 
 // 实例化
 SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, 240) scrollDirection:UIImageScrollDirectionHorizontal];
 imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];

 [self.view addSubview:imageView];
 
 // 图片轮播模式
 imageView.scrollMode = UIImageScrollNormal;
 // 图片轮播模式 或循环模式
 imageView.scrollMode = UIImageScrollLoop;

 // 自动播放
 imageView.autoAnimation = YES;
 // 自动播放时间
 imageView.autoDuration = 3;

 // 页签-pageControl
 imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
 imageView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
 // 页签-或label
 imageView.pageControlType = UIImagePageControl;
 // 当前页码
 imageView.currentPage = 2;

 // 浏览模式
 imageView.isBrowser = YES;

 // 只有一张图片时隐藏页码
 imageView.hiddenWhileSinglePage = YES;
 
 // 代理，实现协议方法<SYImageBrowserDelegate>
 imageView.deletage = self;
 [imageView reloadData];
 
 // 数量
 - (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
 {
     return self.images.count;
 }

 // 视图
 - (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
 {
     if (view == nil) {
         NSString *imageurl = self.images[index];
         UIImageView *imageview = [[UIImageView alloc] init];
             imageview.contentMode = UIViewContentModeScaleAspectFit;
         [imageview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
 //        imageview.image = [UIImage imageNamed:imageurl];
         return imageview;
     }
     return view;
 }

 // 滚动
 - (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index
 {
     UILabel *label = [browser viewWithTag:1000];
     NSString *title = self.titles[index];

     NSLog(@"滑动：scroll %@", @(index));
     
     label.text = [NSString stringWithFormat:@"滑动：%@", title];
     label.textColor = UIColor.orangeColor;
     if (index == 3) {
         label.textColor = UIColor.blueColor;
     }
 }

 // 点击
 - (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index
 {
     NSLog(@"click %@", @(index));
 }

 // 滑动
 - (void)imageBrowser:(SYImageBrowser *)browser direction:(UIImageSlideDirection)direction contentOffX:(CGFloat)offX end:(BOOL)isEnd
 {
     NSLog(@"滑动：direction %@, offx %@, end %@", @(direction), @(offX), @(isEnd));
 }
 */

