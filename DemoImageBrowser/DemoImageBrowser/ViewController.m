//
//  ViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "ImageLoopTrueVC.h"
#import "ImageLoopTrueTableVC.h"
#import "ImageLoopFalseVC.h"
#import "ImageViewController.h"
#import "SYImageBrowseHeader.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *array;

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
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.array = @[[ImageLoopTrueVC class], [ImageLoopTrueTableVC class], [ImageLoopFalseVC class], [ImageViewController class], [SYImageBrowseViewController class]];
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    Class class = self.array[indexPath.row];
    NSString *text = NSStringFromClass(class);
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.array.count - 1)
    {
        // 网络图片
        //        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
        //        [images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
        //        [images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
        //        [images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
        //        [images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
        //        [images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
        //        [images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
        // 本地图片
        NSArray *images = @[[UIImage imageNamed:@"01"], [UIImage imageNamed:@"02"], [UIImage imageNamed:@"03"], [UIImage imageNamed:@"04"], [UIImage imageNamed:@"05"], [UIImage imageNamed:@"06"]];
        
        // 初始化图片浏览器
        SYImageBrowseViewController *browseVC = [[SYImageBrowseViewController alloc] init];
        // 背景颜色
        browseVC.imageBgColor = [UIColor orangeColor];
        // 图片显示模式
        browseVC.imageContentMode = SYImageBrowseContentFit;
        // 删除按钮类型
        browseVC.deleteType = SYImageBrowserDeleteTypeText;
        browseVC.deleteTitle = @"Delete";
        browseVC.deleteTitleFont = [UIFont boldSystemFontOfSize:13.0];
        browseVC.deleteTitleColor = [UIColor blackColor];
        browseVC.deleteTitleColorHighlight = [UIColor redColor];
        // 图片浏览器图片数组
        browseVC.imageArray = images;
        // 图片浏览器当前显示第几张图片
        browseVC.imageIndex = 10;
        // 图片浏览器浏览回调（删除图片后图片数组）
        browseVC.ImageDelete = ^(NSArray *array){
            NSLog(@"array %@", array);
            
            // 如果有引用其他属性，注意弱引用（避免循环引用，导致内存未释放）
        };
        // 图片点击回调
        browseVC.ImageClick = ^(NSInteger index){
            NSLog(@"点击了第 %@ 张图片", @(index));
        };
        // 刷新数据
        [browseVC reloadData];
        // 图片浏览器跳转
        [self.navigationController pushViewController:browseVC animated:YES];
    }
    else
    {
        Class class = self.array[indexPath.row];
        UIViewController *nextVC = [class new];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

@end
