//
//  ImageLoopTrueVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageLoopTrueVC.h"
#import "SYImageBrowseHeader.h"

@interface ImageLoopTrueVC ()

@end

@implementation ImageLoopTrueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    // 网络图片
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
    [images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
    [images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    // 本地图片
    // NSArray *images = @[[UIImage imageNamed:@"01"], [UIImage imageNamed:@"02"], [UIImage imageNamed:@"03"], [UIImage imageNamed:@"04"], [UIImage imageNamed:@"05"], [UIImage imageNamed:@"06"]];
    
    NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
    
    CGRect rect = self.view.bounds;
    rect = CGRectMake(0.0, 0.0, self.view.frame.size.width, 200.0);
    // 实例化
    // 方法1
    SYImageBrowseView *imageBrowse = [[SYImageBrowseView alloc] initWithFrame:rect view:self.view];
    imageBrowse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    // 循环模式
    imageBrowse.loopType = SYImageBrowseLoopTypeTrue;
    // 类型
    imageBrowse.browseMode = SYImageBrowseAdvertisement;
    // 页码
    //
//    imageBrowse.pageMode = SYImageBrowsePageControl;
//    imageBrowse.pageControl.backgroundColor = [UIColor yellowColor];
//    imageBrowse.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    imageBrowse.pageControl.pageIndicatorTintColor = [UIColor greenColor];
//    imageBrowse.pageControlPoint = CGPointMake((imageBrowse.frame.size.width - imageBrowse.pageControl.frame.size.width), (imageBrowse.frame.size.height - imageBrowse.pageControl.frame.size.height));
    //
    imageBrowse.pageMode = SYImageBrowsePagelabel;
    imageBrowse.pageLabel.backgroundColor = [UIColor yellowColor];
    imageBrowse.pageLabel.textColor = [UIColor redColor];
    imageBrowse.pageLabelPoint = CGPointMake(10.0, 10.0);
    //
    imageBrowse.pageIndex = 3;
    // 标题
    imageBrowse.showText = YES;
    imageBrowse.textLabelPoint = CGPointMake(10.0, 30.0);
    //
    imageBrowse.showSwitchButton = YES;
    // 自动播放 YES,NO
    imageBrowse.isAutoPlay = NO;
    imageBrowse.animationTime = 3.0;
    // 图片样式 SYImageBrowseContentFill,SYImageBrowseContentFit
    imageBrowse.imageContentMode = SYImageBrowseContentFill;
    // 图片
    // 默认图片
    imageBrowse.defaultImage = [UIImage imageNamed:@"DefaultImage"];
    // 数据源
    imageBrowse.images = images;
    imageBrowse.titles = titles;
    // 交互
    imageBrowse.imageClick = ^(NSInteger index){
        NSLog(@"imageSelected %ld", index);
    };
    // 删除按钮（浏览模式才有效）
    imageBrowse.showDeleteButton = YES;
    imageBrowse.imageDelete = ^(NSInteger index){
        NSLog(@"imageDelete %ld", index);
    };
    //
    [imageBrowse reloadUIView];
}

@end
