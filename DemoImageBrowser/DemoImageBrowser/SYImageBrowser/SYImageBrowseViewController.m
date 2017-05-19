//
//  SYImageBrowseViewController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/10.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseViewController.h"

static NSInteger const tagImageView = 1000;
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
    
    // 初始化
    _deleteTitle = @"删除";
    _deleteTitleColor = [UIColor blackColor];
    _deleteTitleColorHighlight = [UIColor lightGrayColor];
    _deleteTitleFont = [UIFont systemFontOfSize:14.0];
    _deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
    
    // 视图
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setDeleteButton];
}

#pragma mark - 创建视图

- (void)setDeleteButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, 60.0, 35.0);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(imageDelete) forControlEvents:UIControlEventTouchUpInside];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (_deleteType == SYImageBrowserDeleteTypeText)
    {
        [button setTitle:_deleteTitle forState:UIControlStateNormal];
        button.titleLabel.font = _deleteTitleFont;
        [button setTitleColor:_deleteTitleColor forState:UIControlStateNormal];
        [button setTitleColor:_deleteTitleColorHighlight forState:UIControlStateHighlighted];
    }
    else if (_deleteType == SYImageBrowserDeleteTypeImage)
    {
        [button setImage:_deleteImage forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setUI
{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - 64.0);
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = YES;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    
    [self resetUI];
}

- (void)resetUI
{
    SYImageBrowseRemoveSubViews(self.mainScrollView);
    
    for (int i = 0; i < self.currentTotal; i++)
    {
        CGRect rect = CGRectMake((i * WidthView), 0.0, WidthView, HeightView);
        SYImageBrowseScrollView *imageview = [[SYImageBrowseScrollView alloc] initWithFrame:rect];
        [self.mainScrollView addSubview:imageview];
        imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageview.imageBrowseView.contentMode = (SYImageBrowseContentFit == _imageContentMode ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill);
        imageview.tag = i + tagImageView;
        imageview.imageBrowseView.imageClick = ^(void){
            if (self.ImageClick)
            {
                self.ImageClick(i);
            }
        };
        UIImage *image = self.mainArray[i];
        [imageview.imageBrowseView setImage:image defaultImage:nil];
    }
    
    self.mainScrollView.contentSize = CGSizeMake((self.currentTotal * WidthView), HeightView);
    
    [self setNavigationTitle];
    
    self.mainScrollView.contentOffset = CGPointMake((self.currentIndex * WidthView), 0.0);
}

- (void)setNavigationTitle
{
    NSString *title = [[NSString alloc] initWithFormat:@"%ld/%ld", ((long)self.currentIndex + 1), (long)self.currentTotal];
    if (0 == self.currentTotal)
    {
        title = @"0/0";
    }
    self.navigationItem.title = title;
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

#pragma mark - getter

#pragma mark - setter

- (void)setImageBgColor:(UIColor *)imageBgColor
{
    _imageBgColor = imageBgColor;
    if (_imageBgColor)
    {
        self.mainScrollView.backgroundColor = _imageBgColor;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView)
    {
        NSInteger currentPage = self.mainScrollView.contentOffset.x / WidthView;
        
        // 重置上个视图原始大小
        if (self.currentIndex != currentPage)
        {
            NSInteger previousIndex = 0;
            if (self.currentIndex > currentPage)
            {
                // 向右滑动，变小
                previousIndex = currentPage + 1;
            }
            else
            {
                // 向左滑动，变大
                previousIndex = currentPage - 1;
            }
            SYImageBrowseScrollView *previousImageView = self.mainScrollView.subviews[previousIndex];
            previousImageView.isOriginal = YES;
        }
        
        // 重置当前页码
        self.currentIndex = currentPage;
        
        // 重置标题
        [self setNavigationTitle];
    }
}

#pragma mark - 

/// 刷新信息（最后调用）
- (void)reloadData
{
    self.mainArray = [[NSMutableArray alloc] initWithArray:_imageArray];
    
    self.currentTotal = self.mainArray.count;
    self.defaultTotal = self.currentTotal;
    
    // 防止数组越界，造成显示异常
    if (self.currentTotal == 1)
    {
        self.imageIndex = 0;
    }
    else
    {
        if (self.currentTotal <= self.imageIndex)
        {
            self.imageIndex = self.currentTotal - 1;
        }
    }
    
    self.currentIndex = self.imageIndex;
    
    [self resetUI];
}


@end
