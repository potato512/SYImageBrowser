# SYImageBrowser

图片轮播广告，或图片浏览视图控件
使用SDWebImage加载网络图片，使用时注意添加该框架。

~~~ javascript

#import "SYImageBrowse.h"

// 广告数据处理，本地图片
- (void)localImage
{
    NSArray *images = @[@"01.jpg", @"02.jpg", @"03.jpg", @"04.jpg", @"05.jpg", @"06.jpg"];
    NSArray *titles = @[@"01.jpg", @"02.jpg", @"03.jpg", @"04.jpg", @"05.jpg", @"06.jpg"];

    CGRect rect = self.view.bounds;
    SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
    imageBrowse.showText = YES;
    // imageBrowse.isAutoPlay = YES;
    imageBrowse.showPageControl = YES;
    // 可放这里
//    imageBrowse.imageSource = images;
//    imageBrowse.titleSource = titles;
    imageBrowse.pageIndex = 10;
    imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    imageBrowse.imageSelected = ^(NSInteger index){
        NSLog(@"imageSelected %ld", index);
    };
    imageBrowse.browseMode = ImageBrowseAdvertisement;
    imageBrowse.textMode = textAlignmentCenter;
    imageBrowse.pageMode = ImagePagelabel;
    imageBrowse.pageNormalColor = [UIColor redColor];
    imageBrowse.pageSelectedColor = [UIColor greenColor];
    imageBrowse.showDeleteButton = YES;
    imageBrowse.imageDelete = ^(NSInteger index){
        NSLog(@"imageDelete %ld", index);
    };
    imageBrowse.imageContentMode = ImageContentFill;
    // 可放最后
    imageBrowse.imageSource = images;
    imageBrowse.titleSource = titles;
    imageBrowse.defaultImage = [UIImage imageNamed:@"defaultImage"];
}

// 广告数据处理，网络图片
- (void)networkImage
{
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:7];
    [images addObject:@"http://img0.bdstatic.com/img/image/6946388bef89760a5a2316f888602a721440491660.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/6446027056db8afa73b23eaf953dadde1410240902.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/379ee5880ae642e12c24b731501d01d91409804208.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/c9e2596284f50ce95cbed0d756fdd22b1409207983.jpg"];
    [images addObject:@"http://img0.bdstatic.com/img/image/5bb565bd8c11b67a46bcfb36cc506f6c1409130294.jpg"];
    [images addObject:@"http://d.hiphotos.baidu.com/image/w%3D230/sign=3941c09f0ef431adbcd2443a7b37ac0f/bd315c6034a85edf0647db2e4b540923dc5475f7.jpg"];
    NSArray *titles = @[@"01.jpg", @"02.jpg", @"03.jpg", @"04.jpg", @"05.jpg", @"06.jpg"];

    CGRect rect = rect = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 240.0);
    SYImageBrowse *imageBrowse = [[SYImageBrowse alloc] initWithFrame:rect view:self.view];
    imageBrowse.showText = YES;
    imageBrowse.isAutoPlay = YES;
    imageBrowse.showPageControl = YES;
    // 可放这里
//    imageBrowse.imageSource = images;
//    imageBrowse.titleSource = titles;
    imageBrowse.pageIndex = 10;
    imageBrowse.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    imageBrowse.imageSelected = ^(NSInteger index){
        NSLog(@"imageSelected %ld", index);
    };
    imageBrowse.browseMode = ImageBrowseAdvertisement;
    imageBrowse.textMode = textAlignmentCenter;
    imageBrowse.pageMode = ImagePagelabel;
    imageBrowse.pageNormalColor = [UIColor redColor];
    imageBrowse.pageSelectedColor = [UIColor greenColor];
    // imageBrowse.showDeleteButton = YES;
    // imageBrowse.imageDelete = ^(NSInteger index){
    //     NSLog(@"imageDelete %ld", index);
    // };
    imageBrowse.imageContentMode = ImageContentFill;
    // 可放最后
    imageBrowse.imageSource = images;
    imageBrowse.titleSource = titles;
    imageBrowse.defaultImage = [UIImage imageNamed:@"defaultImage"];
}

~~~

