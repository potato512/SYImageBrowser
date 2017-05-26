//
//  RunloopVC.m
//  DemoImageCircle
//
//  Created by herman on 2017/5/27.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "RunloopVC.h"
#import "SYScrollImageView.h"

@interface RunloopVC ()

@end

@implementation RunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"循环广告轮播";
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    [imageUrls addObject:@"http://p1.pstatp.com/origin/22b30006a5279d1af209"];
    [imageUrls addObject:@"http://p1.pstatp.com/origin/22b200115aeeabef239e"];
    [imageUrls addObject:@"http://p1.pstatp.com/origin/22b400067be6dd23c320"];
    [imageUrls addObject:@"http://p3.pstatp.com/origin/20860011923bcc23df58"];
    [imageUrls addObject:@"http://p3.pstatp.com/origin/22b400067be51ab3b853"];
    [imageUrls addObject:@"http://p3.pstatp.com/origin/208300119aa46be8a80b"];
    
    NSArray *imageNames = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    
    SYScrollImageView *imageView = [[SYScrollImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 160.0)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor whiteColor];
    // 图片源
    imageView.images = imageNames;
    // 图片浏览模式 ImageShowRunloopType ImageShowNormalType
    imageView.showType = ImageShowRunloopType;
    // 图片显示模式 ImageContentAspectFillType ImageContentAspectFitType
    imageView.contentMode = ImageContentAspectFillType;
    // 标题标签
    imageView.titles = imageNames;
    imageView.showTitle = YES;
    imageView.titleLabel.textColor = [UIColor redColor];
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 页签-label UILabelControlType
    imageView.pageType = UIPageControlType;
    imageView.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView.pageLabel.textColor = [UIColor redColor];
    // 切换按钮
    imageView.showSwitch = YES;
    // 自动播放
    imageView.isAutoPlay = YES;
    imageView.animationTime = 1.2;
    // 图片点击
    imageView.imageClick = ^(NSInteger index){
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    };
    // 数据刷新
    [imageView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

@end
