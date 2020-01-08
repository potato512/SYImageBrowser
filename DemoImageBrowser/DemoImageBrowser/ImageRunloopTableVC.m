//
//  ImageRunloopTableVC.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "ImageRunloopTableVC.h"
#import "SYImageBrowser.h"

@interface ImageRunloopTableVC () <SYImageBrowserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation ImageRunloopTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"循环广告轮播带table";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, 300) scrollDirection:UIImageScrollDirectionHorizontal];
    imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    // 图片轮播模式
    imageView.scrollMode = UIImageScrollLoop;
    // 图片显示模式
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 页签-pageControl
    imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
    imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    // 页签-label
    imageView.pageControlType = UIImagePageControl;
    imageView.pageLabel.backgroundColor = [UIColor yellowColor];
    imageView.pageLabel.textColor = [UIColor redColor];
    // 自动播放
    imageView.autoAnimation = YES;
    imageView.autoDuration = 2.0;
    // 数据刷新
    imageView.deletage = self;
    [imageView reloadData];

    
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    table.tableHeaderView = imageView;
    table.tableFooterView = [[UIView alloc] init];
    table.delegate = self;
    table.dataSource = self;
}


#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row %@", indexPath];
    return cell;
}

#pragma mark - browser

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
    return self.images.count;
}
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
{
    UIImageView *imageview = view;
    if (imageview == nil) {
        imageview = [[UIImageView alloc] init];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSString *url = self.images[index];
    imageview.image = [UIImage imageNamed:url];
    NSLog(@"index %@, url %@", @(index), url);
    return imageview;
}

@end
