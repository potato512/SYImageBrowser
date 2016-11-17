//
//  SYImageBrowseViewController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/10.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseViewController.h"

#define WidthView (self.mainScrollView.frame.size.width)
#define HeightView (self.mainScrollView.frame.size.height)

@interface SYImageBrowseViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSMutableArray *mainArray;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentTotal;
@property (nonatomic, assign) NSInteger defaultTotal;

@end

@implementation SYImageBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图

- (void)setUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self resetUI];
}

- (void)resetUI
{
    RemoveSubViews(self.mainScrollView);
    
    for (int i = 0; i < self.currentTotal; i++)
    {
        CGRect rect = CGRectMake((i * WidthView), 0.0, WidthView, HeightView);
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
        [self.mainScrollView addSubview:imageview];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

        UIImage *image = self.mainArray[i];
        imageview.image = image;
    }
    
    self.mainScrollView.contentSize = CGSizeMake((self.currentTotal * WidthView), HeightView);
    
    [self setNavigationTitle];
    
    self.mainScrollView.contentOffset = CGPointMake((self.currentIndex * WidthView), 0.0);
}

void RemoveSubViews(UIView *view)
{
    if (view)
    {
        NSInteger count = view.subviews.count;
        count -= 1;
        for (NSInteger i = count; i >= 0; i--)
        {
            UIView *subview = view.subviews[i];
            [subview removeFromSuperview];
        }
    }
}

- (void)setNavigationTitle
{
    NSString *title = [[NSString alloc] initWithFormat:@"%ld/%ld", ((long)self.currentIndex + 1), (long)self.currentTotal];
    if (0 == self.currentTotal)
    {
        title = @"0/0";
    }
    self.title = title;
}

#pragma mark - 响应事件

- (void)imageDelete
{
    if (0 == self.currentTotal)
    {
        return;
    }
    
    [self.mainArray removeObjectAtIndex:self.currentIndex];
    
    NSInteger index = self.currentTotal - 1;
    
    self.currentTotal = self.mainArray.count;
    
    if (0 == self.currentIndex)
    {
        self.currentIndex = 0;
    }
    else if (index == self.currentIndex)
    {
        self.currentIndex = self.currentTotal - 1;
    }
    
    [self resetUI];
    
    if (self.ImageDelete && (self.defaultTotal != self.currentTotal))
    {
        self.ImageDelete(self.mainArray);
    }
}

#pragma mark - setter

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    self.mainArray = [[NSMutableArray alloc] initWithArray:_imageArray];
    
    self.currentTotal = self.mainArray.count;
    self.defaultTotal = self.currentTotal;
    
    [self resetUI];
}

- (void)setImageIndex:(NSInteger)imageIndex
{
    _imageIndex = imageIndex;
    
    self.currentIndex = _imageIndex;
    
    [self resetUI];
}

- (void)setDeleteType:(SYImageBrowserDeleteType)deleteType
{
    _deleteType = deleteType;
    if (_deleteType == SYImageBrowserDeleteTypeText)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(imageDelete)];
    }
    else if (_deleteType == SYImageBrowserDeleteTypeImage)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 0.0, 35.0, 35.0);
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"SYDeleteImage"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageDelete) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView)
    {
        NSInteger currentPage = self.mainScrollView.contentOffset.x / WidthView;
        self.currentIndex = currentPage;
        
        [self setNavigationTitle];
    }
}

@end
