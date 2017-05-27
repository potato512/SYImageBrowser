//
//  SYImageBrowserController.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/7/10.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowserController.h"

static NSInteger const tagImageView = 1000;
#define WidthView (self.mainScrollView.frame.size.width)
#define HeightView (self.mainScrollView.frame.size.height)

@interface SYImageBrowserController ()

@property (nonatomic, strong) SYImageBrowser *imageBrowser;
@property (nonatomic, strong) NSMutableArray *mainArray;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentTotal;
@property (nonatomic, assign) NSInteger defaultTotal;

@end

@implementation SYImageBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化
    _deleteType = ImageBrowserDeleteTypeText;
    _contentMode = ImageContentAspectFitType;
    _deleteTitle = @"删除";
    _deleteTitleColor = [UIColor blackColor];
    _deleteTitleColorHighlight = [UIColor lightGrayColor];
    _deleteTitleFont = [UIFont systemFontOfSize:14.0];
    _deleteImage = [UIImage imageNamed:@"SYDeleteImage"];
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
    if (_deleteType == ImageBrowserDeleteTypeText)
    {
        [button setTitle:_deleteTitle forState:UIControlStateNormal];
        button.titleLabel.font = _deleteTitleFont;
        [button setTitleColor:_deleteTitleColor forState:UIControlStateNormal];
        [button setTitleColor:_deleteTitleColorHighlight forState:UIControlStateHighlighted];
    }
    else if (_deleteType == ImageBrowserDeleteTypeImage)
    {
        [button setImage:_deleteImage forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)resetUI
{
    if (self.imageBrowser.superview == nil)
    {
        [self.view addSubview:_imageBrowser];
    }
    
    self.imageBrowser.pageIndex = self.currentIndex;
    self.imageBrowser.images = self.mainArray;
    [self.imageBrowser reloadData];
    
    [self setNavigationTitle];
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

- (SYImageBrowser *)imageBrowser
{
    if (_imageBrowser == nil)
    {
        _imageBrowser = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, (self.view.frame.size.height - 64.0))];
        _imageBrowser.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) weakSelf = self;
        _imageBrowser.imageScroll = ^(NSInteger index) {
            // 重置当前页码
            weakSelf.currentIndex = index;
            // 重置标题
            [weakSelf setNavigationTitle];
        };
        _imageBrowser.imageClick = ^(NSInteger index) {
            if (weakSelf.ImageClick)
            {
                weakSelf.ImageClick(index);
            }
        };
    }
    return _imageBrowser;
}

#pragma mark - setter

- (void)setImageBgColor:(UIColor *)imageBgColor
{
    _imageBgColor = imageBgColor;
    if (_imageBgColor)
    {
        self.imageBrowser.backgroundColor = _imageBgColor;
    }
}

#pragma mark - methord

/// 刷新信息（最后调用）
- (void)reloadData
{
    self.mainArray = [[NSMutableArray alloc] initWithArray:_images];
    
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
    
    self.imageBrowser.contentMode = self.contentMode;
    
    [self resetUI];
}


@end
