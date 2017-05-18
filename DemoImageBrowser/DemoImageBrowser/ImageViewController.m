//
//  ImageViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/18.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ImageViewController.h"
#import "SYImageBrowser/SYImageBrowseView.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:imageview];
//    imageview.image = [UIImage imageNamed:@"01"];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    imageview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageview.autoresizesSubviews = YES;
//    imageview.layer.masksToBounds = YES;
//    imageview.clipsToBounds = YES;
    
//    SYImageBrowseView *imageview = [[SYImageBrowseView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:imageview];
//    [imageview setImage:[UIImage imageNamed:@"01"] defaultImage:nil];
//    imageview.contentMode = UIViewContentModeScaleAspectFit;
//    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    SYImageBrowseScrollView *imageview = [[SYImageBrowseScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageview];
    imageview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [imageview.imageBrowseView setImage:[UIImage imageNamed:@"01"] defaultImage:nil];
    imageview.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;

}

@end
