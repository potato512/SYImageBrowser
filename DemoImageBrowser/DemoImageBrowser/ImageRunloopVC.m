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
    
    self.navigationItem.title = @"手动循环广告轮播";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)setUI
{
    CGFloat height = (self.view.frame.size.height - 10 * 4) / 3;
    height = 160;
    
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    imageView.tag = 1;
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollLoop;
    // 页签-pageControl
//    imageView.currentPage = 2;
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    // 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 40)];
    [imageView addSubview:label];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.redColor;
    label.tag = 1000;
    
    // 数据刷新
    imageView.deletage = self;
    [imageView reloadData];
    
    
    
    UIView *currentView = imageView;
    //
    SYImageBrowser *imageView2 = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10), self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:imageView2];
    imageView2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    imageView2.tag = 2;
    imageView2.hiddenWhileSinglePage = YES;
    // 图片轮播模式
    imageView2.scrollMode = UIImageScrollLoop;
    // 页签-pageControl
    imageView2.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView2.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 数据刷新
    imageView2.deletage = self;
    [imageView2 reloadData];

    
    
    currentView = imageView2;
    //
    SYImageBrowser *imageView3 = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10), self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:imageView3];
    imageView3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    imageView3.tag = 3;
    // 图片轮播模式
    imageView3.scrollMode = UIImageScrollLoop;
    // 数据刷新
    imageView3.deletage = self;
    [imageView3 reloadData];
}

- (NSArray *)images
{
    if (_images == nil) {
        _images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
//        _images = @[];
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


- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
{
//    if (browser.tag == 2) {
//        return 1;
//    } else if (browser.tag == 3) {
//        return 2;
//    }
    return self.images.count;
}
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
{
//    if (browser.tag == 2) {
//        UIImageView *imageview = view;
//        if (imageview == nil) {
//            imageview = [[UIImageView alloc] init];
//            imageview.contentMode = UIViewContentModeScaleAspectFit;
//        }
//        NSString *imageurl = self.images[index];
//        imageview.image = [UIImage imageNamed:imageurl];
//        return imageview;
//    } else if (browser.tag == 3) {
//        UIImageView *imageview = view;
//        if (imageview == nil) {
//            imageview = [[UIImageView alloc] init];
//            imageview.contentMode = UIViewContentModeScaleAspectFit;
//        }
//        NSString *imageurl = self.images[index];
//        imageview.image = [UIImage imageNamed:imageurl];
//        return imageview;
//    }
    
    UIImageView *imageview = view;
    if (imageview == nil) {
        imageview = [[UIImageView alloc] init];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSString *imageurl = self.images[index];
    imageview.image = [UIImage imageNamed:imageurl];
    return imageview;
}
- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index
{
    if (browser.tag == 2 || browser.tag == 3) {
        NSLog(@"browser.tag（%@） index = %@", @(browser.tag), @(index));
        return;
    }
    NSLog(@"browser.tag（%@） index = %@", @(browser.tag), @(index));
    UILabel *label = [browser viewWithTag:1000];
    label.text = self.titles[index];
}
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index
{
    [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了(tag = %@)第 %@ 张图片", @(browser.tag), @(index)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}

@end
