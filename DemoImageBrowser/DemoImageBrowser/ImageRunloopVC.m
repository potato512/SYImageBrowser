//
//  ImageRunloopVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageRunloopVC.h"
#import "SYImageBrowser.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ImageRunloopVC () <SYImageBrowserDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ImageRunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"循环广告轮播";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, 300)];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    //
    imageView.enableWhileSinglePage = YES;
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollLoop;
    // 图片显示模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 标题标签
    imageView.showTitle = YES;
    imageView.titleLabel.textColor = [UIColor redColor];
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 页签-label 
    imageView.pageControlType = UIImagePageControl;
    imageView.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView.pageLabel.textColor = [UIColor redColor];
    // 切换按钮
    imageView.showSwitch = YES;
    // 自动播放
    imageView.autoAnimation = NO;
    imageView.autoDuration = 2.0;
    // 数据刷新
    imageView.deletage = self;
    [imageView reloadData];
}

- (NSArray *)images
{
    if (_images == nil) {
        _images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    }
    return _images;
}

- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    }
    return _titles;
}

- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index
{
    NSLog(@"browser.tag（%@） index = %@", @(browser.tag), @(index));
}
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index
{
    [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了(tag = %@)第 %@ 张图片", @(browser.tag), @(index)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}
- (NSString *)imageBrowser:(SYImageBrowser *)browser titleAtIndex:(NSInteger)index
{
    NSString *title = self.titles[index];
    return title;
}
- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
{
    return self.images.count;
}
- (UIImageView *)imageBrowser:(SYImageBrowser *)browser imageAtIndex:(NSInteger)index
{
    NSString *imageurl = self.images[index];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.image = [UIImage imageNamed:imageurl];
    return imageview;
}

@end
