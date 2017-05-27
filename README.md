# SYImageBrowser
图片轮播广告，或图片浏览视图控件
使用SDWebImage加载网络图片，使用时注意添加该框架。

# 效果图
![syimagebrowse.gif](./syimagebrowse.gif)

# 功能说明
 * 网络图片，或本地图以广告轮播形式显示，也可以浏览形式显示（或视图控制器浏览显示形式）
  * 自动轮播显示
  * 左右滑动显示
  * 浏览形式时，可以进行删除操作

# 广告图片轮播

~~~ javascript

// 导入头文件
#import "SYImageBrowse.h"

~~~ 

~~~ javascript
// 网络图片
//NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
//[images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
//[images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
//[images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
//[images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
//[images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
//[images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
// 本地图片
NSArray *images = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];
// 标题
NSArray *titles = @[@"01.png", @"02.png", @"03.png", @"04.png", @"05.png", @"06.png"];

~~~ 

~~~ javascript

// 实例化
SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 160.0)];
[self.view addSubview:imageView];
imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
// 图片源
imageView.images = images;
// 图片浏览模式 ImageShowRunloopType ImageShowNormalType
imageView.showType = ImageShowNormalType;
// 图片显示模式 ImageContentAspectFillType ImageContentAspectFitType
imageView.contentMode = ImageContentAspectFitType;
// 标题标签
imageView.titles = titles;
imageView.showTitle = YES;
imageView.titleLabel.textColor = [UIColor redColor];
// 页签-pageControl
imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
imageView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
// 页签-label UILabelControlType
imageView.pageType = UIPageControlType;
imageView.pageLabel.backgroundColor = [UIColor yellowColor];
imageView.pageLabel.textColor = [UIColor redColor];
// 切换按钮
imageView.showSwitch = YES;
// 自动播放
imageView.isAutoPlay = NO;
imageView.animationTime = 1.2;
// 图片浏览时才使用
imageView.show = NO;
imageView.hidden = NO;
// 滚动回调
imageView.imageScroll = ^(NSInteger index){
    NSLog(@"scroll = %@", @(index + 1));
};
// 图片点击
imageView.imageClick = ^(NSInteger index){
    [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"你点击了第 %@ 张图片", @(index + 1)] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
};
// 数据刷新
[imageView reloadData];

~~~

# 图片浏览视图控制器模式

~~~ javascript

// 初始化图片浏览器
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

~~~ 


