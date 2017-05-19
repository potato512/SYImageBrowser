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

@property (nonatomic, strong) SYImageBrowseView *imageViewButton;
@property (nonatomic, strong) SYImageBrowseView *imageViewAuto;
@property (nonatomic, strong) SYImageBrowseView *imageViewPageControl;
@property (nonatomic, strong) SYImageBrowseView *imageViewBrowse;

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
    self.imageViewButton.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 100.0);
    [self.imageViewButton reloadData];
    
    UIView *currentView = self.imageViewButton;

    self.imageViewAuto.frame = CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10.0), currentView.frame.size.width, 100.0);
    [self.imageViewAuto reloadData];

    currentView = self.imageViewAuto;
    
    self.imageViewPageControl.frame = CGRectMake(10.0, (currentView.frame.origin.y + currentView.frame.size.height + 10.0), (self.view.frame.size.width - 10.0 * 2), 100.0);
    [self.imageViewPageControl reloadData];
    
    currentView = self.imageViewPageControl;

    self.imageViewBrowse.frame = CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10.0), self.view.frame.size.width, (self.view.frame.size.height - (currentView.frame.origin.y + currentView.frame.size.height + 10.0) - 10.0));
    self.imageViewBrowse.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.imageViewBrowse reloadData];
}

- (NSArray *)images
{
    // 网络图片
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:7];
    [array addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
    [array addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
    [array addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
    [array addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
    [array addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
    [array addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    // 本地图片
    // NSArray *array = @[[UIImage imageNamed:@"01"], [UIImage imageNamed:@"02"], [UIImage imageNamed:@"03"], [UIImage imageNamed:@"04"], [UIImage imageNamed:@"05"], [UIImage imageNamed:@"06"]];
    
    return array;
}

- (NSArray *)titles
{
    return @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];;
}

- (SYImageBrowseView *)imageViewButton
{
    if (_imageViewButton == nil)
    {
        _imageViewButton = [[SYImageBrowseView alloc] initWithFrame:CGRectZero view:self.view];
        // 循环模式
        _imageViewButton.loopType = SYImageBrowseLoopTypeTrue;
        // 类型
        _imageViewButton.browseMode = SYImageBrowseAdvertisement;
        // 页码
        _imageViewButton.pageMode = SYImageBrowsePagelabel;
        _imageViewButton.pageLabel.backgroundColor = [UIColor yellowColor];
        _imageViewButton.pageLabel.textColor = [UIColor redColor];
        _imageViewButton.pageLabelFrame = CGRectMake(10.0, 10.0, 30.0, 30.0);
        // 当前页码
        _imageViewButton.pageIndex = 3;
        // 标题
        _imageViewButton.showText = YES;
        _imageViewButton.textLabelFrame = CGRectMake(50.0, 10.0, 60.0, 30.0);
        // 显示切换按钮
        _imageViewButton.showSwitchButton = YES;
        // 图片样式 SYImageBrowseContentFill,SYImageBrowseContentFit
        _imageViewButton.imageContentMode = SYImageBrowseContentFill;
        // 默认图片
        _imageViewButton.defaultImage = [UIImage imageNamed:@"DefaultImage"];
        // 数据源
        _imageViewButton.images = self.images;
        _imageViewButton.titles = self.titles;
    }
    return _imageViewButton;
}

- (SYImageBrowseView *)imageViewAuto
{
    if (_imageViewAuto == nil)
    {
        _imageViewAuto = [[SYImageBrowseView alloc] initWithFrame:CGRectZero view:self.view];
        // 循环模式
        _imageViewAuto.loopType = SYImageBrowseLoopTypeTrue;
        // 类型
        _imageViewAuto.browseMode = SYImageBrowseAdvertisement;
        // 页码
        _imageViewAuto.pageMode = SYImageBrowsePagelabel;
        _imageViewAuto.pageLabel.backgroundColor = [UIColor whiteColor];
        _imageViewAuto.pageLabel.textColor = [UIColor blackColor];
//        _imageViewAuto.pageLabelPoint = CGPointMake(30.0, 30.0);
        // 当前页码
        _imageViewAuto.pageIndex = 1;
        // 标题
        _imageViewAuto.showText = YES;
//        _imageViewAuto.textLabelPoint = CGPointMake(10.0, 100.0);
        // 隐藏切换按钮
        _imageViewAuto.showSwitchButton = NO;
        // 自动播放 YES,NO
        _imageViewAuto.isAutoPlay = YES;
        _imageViewAuto.animationTime = 3.0;
        // 图片样式 SYImageBrowseContentFill,SYImageBrowseContentFit
        _imageViewAuto.imageContentMode = SYImageBrowseContentFit;
        // 默认图片
        _imageViewAuto.defaultImage = [UIImage imageNamed:@"DefaultImage"];
        // 数据源
        _imageViewAuto.images = self.images;
        _imageViewAuto.titles = self.titles;
    }
    return _imageViewAuto;
}

- (SYImageBrowseView *)imageViewPageControl
{
    if (_imageViewPageControl == nil)
    {
        _imageViewPageControl = [[SYImageBrowseView alloc] initWithFrame:CGRectZero view:self.view];
        // 循环模式
        _imageViewPageControl.loopType = SYImageBrowseLoopTypeTrue;
        // 类型
        _imageViewPageControl.browseMode = SYImageBrowseAdvertisement;
        // 页码
        _imageViewPageControl.pageMode = SYImageBrowsePageControl;
        _imageViewPageControl.pageControl.backgroundColor = [UIColor yellowColor];
        _imageViewPageControl.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _imageViewPageControl.pageControl.pageIndicatorTintColor = [UIColor greenColor];
        _imageViewPageControl.pageControlFrame = CGRectMake(10.0, 10.0, 60.0, 30.0);
        // 当前显示页面
        _imageViewPageControl.pageIndex = 3;
        // 显示切换按钮
        _imageViewPageControl.showSwitchButton = YES;
        // 图片样式
        _imageViewPageControl.imageContentMode = SYImageBrowseContentFill;
        // 图片
        // 默认图片
        _imageViewPageControl.defaultImage = [UIImage imageNamed:@"DefaultImage"];
        // 数据源
        _imageViewPageControl.images = self.images;
        _imageViewPageControl.titles = self.titles;
    }
    return _imageViewPageControl;
}

- (SYImageBrowseView *)imageViewBrowse
{
    if (_imageViewBrowse == nil)
    {
        _imageViewBrowse = [[SYImageBrowseView alloc] initWithFrame:CGRectZero view:self.view];
        // 循环模式
        _imageViewBrowse.loopType = SYImageBrowseLoopTypeTrue;
        // 类型
        _imageViewBrowse.browseMode = SYImageBrowseViewShow;
        // 当前页码
        _imageViewBrowse.pageIndex = 3;
        // 标题
        _imageViewBrowse.showText = YES;
        // 显示切换按钮
        _imageViewBrowse.showSwitchButton = YES;
        // 自动播放 YES,NO
        _imageViewBrowse.isAutoPlay = NO;
        _imageViewBrowse.animationTime = 3.0;
        // 图片样式 SYImageBrowseContentFill,SYImageBrowseContentFit
        _imageViewBrowse.imageContentMode = SYImageBrowseContentFill;
        // 图片
        // 默认图片
        _imageViewBrowse.defaultImage = [UIImage imageNamed:@"DefaultImage"];
        // 数据源
        _imageViewBrowse.images = self.images;
        _imageViewBrowse.titles = self.titles;
        // 交互
        WeakSYImageBrowse;
        _imageViewBrowse.imageClick = ^(NSInteger index){
            NSLog(@"imageSelected %ld", index);
            
            SYImageBrowseViewController *browseVC = [SYImageBrowseViewController new];
            browseVC.imageArray = weakSYImageBrowse.images;
            browseVC.imageIndex = 2;
            [browseVC reloadData];
            [weakSYImageBrowse.navigationController pushViewController:browseVC animated:YES];
        };
        // 删除按钮（浏览模式才有效）
        _imageViewBrowse.showButton = YES;
        _imageViewBrowse.imageManager = ^(SYImageBrowseButtonType type, NSInteger index){
            NSLog(@"imageDelete %ld", type);
        };
    }
    return _imageViewBrowse;
}

@end
