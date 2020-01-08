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

  * 循环或非循环模式 done
  * 自动循环模式 done
  * 自定义视图 done
  * 水平或竖直显示 done
  * 卡片样式
  * banner或浏览 done
  * 浏览模式缩放 done


# pod管理
~~~ javascript
pod 'SYImageBrowser'
~~~ 

# 广告图片轮播

~~~ javascript

// 导入头文件
#import "SYImageBrowser.h"

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
SYImageBrowser *imageView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, 240) scrollDirection:UIImageScrollDirectionHorizontal];
imageView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];

[self.view addSubview:imageView];
~~~ 

~~~ javascript
// 图片轮播模式
imageView.scrollMode = UIImageScrollNormal;
// 图片轮播模式 或循环模式
imageView.scrollMode = UIImageScrollLoop;

// 自动播放
imageView.autoAnimation = YES;
// 自动播放时间
imageView.autoDuration = 3;

// 页签-pageControl
imageView.pageControl.pageIndicatorTintColor = [UIColor redColor];
imageView.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
// 页签-或label 
imageView.pageControlType = UIImagePageControl;
// 当前页码
imageView.currentPage = 2;

// 浏览模式
imageView.isBrowser = YES;

// 只有一张图片时隐藏页码
imageView.hiddenWhileSinglePage = YES;

~~~ 

~~~ javascript
// 标题
UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, imageView.frame.size.width - 40, 30)];
titleLabel.textColor = [UIColor redColor];
titleLabel.font = [UIFont systemFontOfSize:13];
titleLabel.tag = 1000;
titleLabel.backgroundColor = UIColor.lightGrayColor;

[imageView addSubview:titleLabel];
~~~ 

~~~ javascript

// 代理，实现协议方法<SYImageBrowserDelegate>
imageView.deletage = self;
[imageView reloadData];

~~~ 

### 代理方法实现

~~~ javascript
// 数量
- (NSInteger)imageBrowserNumberOfImages:(SYImageBrowser *)browser
{
    return self.images.count;
}

// 视图
- (UIView *)imageBrowser:(SYImageBrowser *)browser view:(UIView *)view viewAtIndex:(NSInteger)index
{
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

// 滚动
- (void)imageBrowser:(SYImageBrowser *)browser didScrollAtIndex:(NSInteger)index
{
    UILabel *label = [browser viewWithTag:1000];
    NSString *title = self.titles[index];

    NSLog(@"滑动：scroll %@", @(index));
    
    label.text = [NSString stringWithFormat:@"滑动：%@", title];
    label.textColor = UIColor.orangeColor;
    if (index == 3) {
        label.textColor = UIColor.blueColor;
    }
}

// 点击
- (void)imageBrowser:(SYImageBrowser *)browser didSelecteAtIndex:(NSInteger)index
{
    NSLog(@"click %@", @(index));
}

// 滑动
- (void)imageBrowser:(SYImageBrowser *)browser direction:(UIImageSlideDirection)direction contentOffX:(CGFloat)offX end:(BOOL)isEnd
{
    NSLog(@"滑动：direction %@, offx %@, end %@", @(direction), @(offX), @(isEnd));
}

~~~ 



#### 修改完善
* 20200108
  * 版本号：2.3.0
  * 优化修改
    * 新增代理方法
    * 去掉SDWebImage集成

* 20191126
  * 版本号：2.2.6
  * 优化修改
    * 去掉默认绿色背景
    * 格式化处理
    
* 20170906
  * 版本号：2.2.5
  * 优化修改
    * 没有图片时，显示默认图标
    * 没有图片时，不显示页码标签

* 20170830
  * 版本号：2.2.4
  * 自动播放时返回索引回调

* 20170829
  * 版本号：2.2.3
  * 添加属性：设置单页模式下隐藏页码


* 20170818
  * 版本号：2.2.2
  * 修改非循环模式下，偏移量计算错误的bug

* 20170817
  * 版本号：2.2.1
  * 修改轮播模式不显示的bug
  
* 20170816
  * 版本号：2.2.0
  * 放大浏览属性修改
    * 弃用：
      * @property (nonatomic, assign) BOOL show;
      * @property (nonatomic, assign) BOOL hidden;
    * 变更为：
      * @property (nonatomic, assign) BOOL isBrowser;
  * 新增属性参数
    * @property (nonatomic, assign) BOOL hiddenWhileSinglePage;
  * 新增功能：图片浏览模式下 isBrowser = YES 时，图片的放大缩小、显示隐藏
    * 双击放大，或缩小
    * 两个手指捏合放大，或缩小
    * 单击隐藏

* 20170813
  * 版本号：2.1.0
  * 添加滚动结束后的索引
    * block回调
    * delegate代理

* 20170811
  * 版本号：2.0.0
  * 代码优化（UIScrollView改成UICollectionView）  

* 20170605
  * 删除弃用图片浏览视图控制器


