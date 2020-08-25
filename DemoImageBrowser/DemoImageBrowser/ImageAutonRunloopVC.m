//
//  ImageAutonRunloopVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 2019/12/28.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "ImageAutonRunloopVC.h"
#import "SYImageBrowser.h"

@interface ImageAutonRunloopVC () <SYImageBrowserDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
//
@property (nonatomic, strong) SYImageBrowser *imageView;

@end

@implementation ImageAutonRunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自动循环广告轮播";
    [self setUI];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(animationStop) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(animationStart) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)loadView
{
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animationStart];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self animationStop];
}

- (void)animationStop
{
    if (self.imageView) {
        [self.imageView animationStopWhileAuto:YES];
    }
}
- (void)animationStart
{
    if (self.imageView) {
        [self.imageView animationStopWhileAuto:NO];
    }
}


- (void)setUI
{
    CGFloat height = 160;
    
    self.imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:self.imageView];
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.imageView.tag = 1;
    // 图片轮播模式
    self.imageView.scrollMode = UIImageScrollLoop;
    self.imageView.autoAnimation = YES;
    self.imageView.autoDuration = 3;
    // 页签-pageControl
//    imageView.currentPage = 2;
    self.imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, 40)];
    [self.imageView addSubview:label];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.redColor;
    label.tag = 1000;
    
    // 数据刷新
    self.imageView.deletage = self;
    [self.imageView reloadData];
    
    
    UIView *currentView = self.imageView;
    
    SYImageBrowser *imageView2 = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10), self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:imageView2];
    imageView2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    imageView2.tag = 2;
    // 图片轮播模式
    imageView2.scrollMode = UIImageScrollLoop;
    imageView2.autoAnimation = YES;
    imageView2.autoDuration = 3;
    // 页签-pageControl
    imageView2.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView2.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 数据刷新
    imageView2.deletage = self;
    [imageView2 reloadData];

    currentView = imageView2;
    
    
    
    //
//    SYImageBrowser *imageView3 = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, (currentView.frame.origin.y + currentView.frame.size.height + 10), self.view.frame.size.width, height) scrollDirection:UIImageScrollDirectionHorizontal];
//    [self.view addSubview:imageView3];
//    imageView3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
//    imageView3.tag = 3;
//    // 图片轮播模式
//    imageView3.scrollMode = UIImageScrollLoop;
//    imageView3.autoAnimation = YES;
//    imageView3.autoDuration = 3;
//    // 数据刷新
//    imageView3.deletage = self;
//    [imageView3 reloadData];
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


- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
{
    if (browser.tag == 2) {
        return 1;
    } else if (browser.tag == 3) {
        return 2;
    }
    return self.images.count;
}
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
{
    if (browser.tag == 2) {
        if (view == nil) {
            NSString *imageurl = self.images.lastObject;
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.image = [UIImage imageNamed:imageurl];
            return imageview;
        }
        return view;
    } else if (browser.tag == 3) {
        if (view == nil) {
            NSString *imageurl = self.images[index];
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.image = [UIImage imageNamed:imageurl];
            return imageview;
        }
        return view;
    }
    
    if (view == nil) {
        NSString *imageurl = self.images[index];
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.image = [UIImage imageNamed:imageurl];
        return imageview;
    }
    return view;
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
