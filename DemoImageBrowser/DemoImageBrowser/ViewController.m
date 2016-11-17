//
//  ViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYImageBrowse.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"图片浏览";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"browser" style:UIBarButtonItemStyleDone target:self action:@selector(showImageClick:)];
    
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
//    NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
//    NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
//    
//    CGRect rect = self.view.bounds;
//    rect = CGRectMake(10.0, 10.0, 100.0, 100.0);
//    SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
//    imageBrowse.showText = YES;
//    imageBrowse.isAutoPlay = YES;
//    imageBrowse.showPageControl = NO;
//    imageBrowse.imageSource = images;
//    imageBrowse.titleSource = titles;
//    imageBrowse.pageIndex = 3;
//    imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//    imageBrowse.imageSelected = ^(NSInteger index){
//        NSLog(@"imageSelected %ld", index);
//    };
//    imageBrowse.browseMode = ImageBrowseAdvertisement;
//    imageBrowse.textMode = textAlignmentCenter;
//    imageBrowse.pageMode = ImagePageControl;
//    imageBrowse.pageAlignmentMode = pageControlAlignmentCenter;
//    imageBrowse.pageNormalColor = [UIColor redColor];
//    imageBrowse.pageSelectedColor = [UIColor greenColor];
//    imageBrowse.showDeleteButton = YES;
//    imageBrowse.imageDelete = ^(NSInteger index){
//        NSLog(@"imageDelete %ld", index);
//    };
//    imageBrowse.imageContentMode = ImageContentFill;
}

- (void)showImageClick:(UIBarButtonItem *)button
{
    // 初始化图片浏览器
    SYImageBrowseViewController *browseVC = [[SYImageBrowseViewController alloc] init];
    // 删除按钮类型
    browseVC.deleteType = SYImageBrowserDeleteTypeText;
    // 图片浏览器图片数组
    NSArray *images = @[[UIImage imageNamed:@"01"], [UIImage imageNamed:@"02"], [UIImage imageNamed:@"03"], [UIImage imageNamed:@"04"], [UIImage imageNamed:@"05"], [UIImage imageNamed:@"06"]];    
    browseVC.imageArray = images;
    // 图片浏览器当前显示第几张图片
    browseVC.imageIndex = 2;
    // 图片浏览器浏览回调（删除图片后图片数组）
    browseVC.ImageDelete = ^(NSArray *array){
        NSLog(@"array %@", array);
        
        // 如果有引用其他属性，注意弱引用（避免循环引用，导致内存未释放）
    };
    // 图片浏览器跳转
    [self.navigationController pushViewController:browseVC animated:YES];
}

@end
