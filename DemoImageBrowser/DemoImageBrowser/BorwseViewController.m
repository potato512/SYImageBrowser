//
//  BorwseViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/18.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "BorwseViewController.h"
#import "SYImageBrowse.h"

@interface BorwseViewController ()

@end

@implementation BorwseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"广告图";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setUI
{
    // 网络图片
//    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
//    [images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
//    [images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
//    [images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
//    [images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
//    [images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
//    [images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    // 本地图片
    NSArray *images = @[[UIImage imageNamed:@"01"], [UIImage imageNamed:@"02"], [UIImage imageNamed:@"03"], [UIImage imageNamed:@"04"], [UIImage imageNamed:@"05"], [UIImage imageNamed:@"06"]];
  
    NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
    
    CGRect rect = self.view.bounds;
    rect = CGRectMake(0.0, 0.0, self.view.frame.size.width, 200.0);
    // 实例化
    SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
    imageBrowse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    // 类型
    imageBrowse.browseMode = SYImageBrowseAdvertisement;
    // 页码
    imageBrowse.pageMode = SYImageBrowsePageControl;
    imageBrowse.pageAlignmentMode = SYImageBrowsePageControlAlignmentCenter;
    imageBrowse.pageNormalColor = [UIColor redColor];
    imageBrowse.pageSelectedColor = [UIColor greenColor];
    imageBrowse.showPageControl = YES;
    imageBrowse.pageIndex = 3;
    // 标题
    imageBrowse.showText = YES;
    imageBrowse.textMode = SYImageBrowseTextAlignmentCenter;
    imageBrowse.textBgroundColor = [UIColor redColor];
    imageBrowse.textColor = [UIColor yellowColor];
    // 自动播放
    imageBrowse.isAutoPlay = YES;
    imageBrowse.autoPlayDuration = 5.0;
    // 图片样式
    imageBrowse.imageContentMode = SYImageBrowseContentFit;
    // 数据源
    imageBrowse.imageSource = images;
    imageBrowse.titleSource = titles;
    // 交互
    imageBrowse.imageSelected = ^(NSInteger index){
        NSLog(@"imageSelected %ld", index);
    };
    imageBrowse.showDeleteButton = YES;
    imageBrowse.imageDelete = ^(NSInteger index){
        NSLog(@"imageDelete %ld", index);
    };
    
}

@end
