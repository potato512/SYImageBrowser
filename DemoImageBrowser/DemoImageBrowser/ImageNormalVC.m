//
//  ImageNormalVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageNormalVC.h"
#import "SYImageBrowser.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ImageNormalVC () <SYImageBrowserDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ImageNormalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"非循环广告轮播";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, 240) scrollDirection:UIImageScrollDirectionHorizontal];
    [self.view addSubview:imageView];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollNormal;
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    // 页签-label 
    imageView.pageControlType = UIImagePageControl;
    // 数据刷新
    imageView.deletage = self;

    //
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, imageView.frame.size.width - 40, 30)];
    [imageView addSubview:titleLabel];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.tag = 1000;
    titleLabel.backgroundColor = UIColor.lightGrayColor;
    
    imageView.tag = 1;
    [imageView reloadData];
    
    
    //
    SYImageBrowser *imageView2 = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 260, self.view.frame.size.width, 240) scrollDirection:UIImageScrollDirectionVertical];
    [self.view addSubview:imageView2];
    imageView2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片轮播模式
    imageView2.scrollMode = UIImageScrollNormal;
    // 页签-label
    imageView2.pageControlType = UIImagePageLabel;
    imageView2.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView2.pageLabel.textColor = [UIColor redColor];
    // 数据刷新
    imageView2.deletage = self;

    //
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, imageView2.frame.size.width - 40, 30)];
    [imageView2 addSubview:titleLabel2];
    titleLabel2.textColor = [UIColor redColor];
    titleLabel2.font = [UIFont systemFontOfSize:13];
    titleLabel2.tag = 1000;
    titleLabel2.backgroundColor = UIColor.lightGrayColor;
    imageView2.currentPage = 3;
    imageView2.tag = 2;
    [imageView2 reloadData];
}

- (NSArray *)images
{
    if (_images == nil) {
//        _images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
        _images = @[@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg", @"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg", @"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg", @"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg", @"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg", @"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    }
    return _images;
}

- (NSArray *)titles
{
    if (_titles == nil) {
        // 标题
        _titles = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    }
    return _titles;
}

- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
{
    if (browser.tag == 1) {
        return self.images.count;
    }
    
    
    return self.images.count;
}
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
{
    if (browser.tag == 1) {
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
    
//    UIView *imageview = [[UIView alloc] init];
    NSString *imageurl = self.images[index];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [imageview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
//    imageview.image = [UIImage imageNamed:imageurl];
    return imageview;
}
- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index
{
    UILabel *label = [browser viewWithTag:1000];
    NSString *title = self.titles[index];
    
    if (browser.tag == 1) {
        NSLog(@"水平滑动：scroll %@", @(index));
        label.text = [NSString stringWithFormat:@"左右滑动：%@", title];
        label.textColor = UIColor.redColor;
        if (index == 3) {
            label.textColor = UIColor.greenColor;
        }
        return;
    }
    NSLog(@"上下滑动：scroll %@", @(index));
    
    label.text = [NSString stringWithFormat:@"上下滑动：%@", title];
    label.textColor = UIColor.orangeColor;
    if (index == 3) {
        label.textColor = UIColor.blueColor;
    }
}
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index
{
    if (browser.tag == 1) {
        NSLog(@"左右滑动：click %@", @(index));
        return;
    }
    NSLog(@"上下滑动：click %@", @(index));
}
- (void)imageBrowser:(SYImageBrowser *)browser direction:(UIImageSlideDirection)direction contentOffX:(CGFloat)offX end:(BOOL)isEnd
{
    if (browser.tag == 1) {
        NSLog(@"左右滑动：direction %@, offx %@, end %@", @(direction), @(offX), @(isEnd));
        return;
    }
    NSLog(@"上下滑动：direction %@, offx %@, end %@", @(direction), @(offX), @(isEnd));
}

@end
