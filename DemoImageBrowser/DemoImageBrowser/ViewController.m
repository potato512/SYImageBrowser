//
//  ViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "ImageRunloopVC.h"
#import "ImageNormalVC.h"
#import "ImageRunloopTableVC.h"
#import "ImageBrowserVC.h"
#import "SYImageBrowser.h"
#import "SYImageBrowserController.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"图片浏览";
    
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;

    [tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSString *text = nil;
    switch (indexPath.row)
    {
        case 0: text = @"非循环广告轮播"; break;
        case 1: text = @"循环广告轮播"; break;
        case 2: text = @"循环广告轮播结合table使用"; break;
        case 3: text = @"图片浏览控制器"; break;
        case 4: text = @"图片浏览"; break;
        case 5: text = @"图片浏览弹窗"; break;
            
        default: break;
    }
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row)
    {
        ImageNormalVC *nextVC = [[ImageNormalVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (1 == indexPath.row)
    {
        ImageRunloopVC *nextVC = [[ImageRunloopVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (2 == indexPath.row)
    {
        ImageRunloopTableVC *nextVC = [[ImageRunloopTableVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (3 == indexPath.row)
    {
        NSArray *images = @[[UIImage imageNamed:@"01.jpeg"], [UIImage imageNamed:@"02.jpeg"], [UIImage imageNamed:@"03.jpeg"], [UIImage imageNamed:@"04.jpeg"], [UIImage imageNamed:@"05.jpeg"], [UIImage imageNamed:@"06.jpeg"]];
        
        SYImageBrowserController *nextVC = [[SYImageBrowserController alloc] init];
        // 背景颜色
        nextVC.imageBgColor = [UIColor orangeColor];
        // 图片显示模式 ImageContentAspectFillType ImageContentAspectFitType
        nextVC.contentMode = ImageContentAspectFitType;
        // 删除按钮类型 ImageBrowserDeleteTypeText ImageBrowserDeleteTypeImage
        nextVC.deleteType = ImageBrowserDeleteTypeImage;
        nextVC.deleteTitle = @"Delete";
        nextVC.deleteTitleFont = [UIFont boldSystemFontOfSize:13.0];
        nextVC.deleteTitleColor = [UIColor blackColor];
        nextVC.deleteTitleColorHighlight = [UIColor redColor];
        // 图片浏览器图片数组
        nextVC.images = images;
        // 图片浏览器当前显示第几张图片
        nextVC.imageIndex = 10;
        // 图片浏览器浏览回调（删除图片后图片数组）
        nextVC.ImageDelete = ^(NSArray *array){
            NSLog(@"array %@", array);
            
            // 如果有引用其他属性，注意弱引用（避免循环引用，导致内存未释放）
        };
        // 图片点击回调
        nextVC.ImageClick = ^(NSInteger index){
            [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index + 1)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        };
        // 刷新数据
        [nextVC reloadData];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (4 == indexPath.row)
    {
        ImageBrowserVC *nextVC = [[ImageBrowserVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (5 == indexPath.row)
    {
        NSArray *images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
        
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, window.frame.size.width, window.frame.size.height)];
        [window addSubview:imageView];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.images = images;
        imageView.contentMode = ImageContentAspectFillType;
        imageView.pageType = UILabelControlType;
        imageView.pageIndex = 3;
        imageView.show = YES;
        imageView.hidden = YES;
        [imageView reloadData];
    }
}

@end
