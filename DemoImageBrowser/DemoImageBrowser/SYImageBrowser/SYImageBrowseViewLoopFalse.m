//
//  SYImageBrowseViewLoopFalse.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 17/4/28.
//  Copyright © 2017年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseViewLoopFalse.h"

#pragma mark - UICollectionViewCell

/// 复用标识
static NSString *const identifierSYAdvertisingCell = @"SYAdvertisingCell";

@interface SYAdvertisingCell : UICollectionViewCell

/// 图片控件
@property (nonatomic, strong) SYImageBrowseScrollView *imageView;
//@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SYAdvertisingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    
    return self;
}

#pragma mark - 视图

- (void)setUI
{
    self.imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    [self.contentView addSubview:self.imageView];
}

#pragma mark - setter

- (SYImageBrowseScrollView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[SYImageBrowseScrollView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    
    return _imageView;
}

@end

#pragma mark - UICollectionView

@interface SYImageBrowseViewLoopFalse () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SYImageBrowseViewLoopFalse

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];
    }
    return self;
}

#pragma mark - 视图

- (void)setUI
{
    // 确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    //
    [self addSubview:self.collectionView];
    //
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    //
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    //
    [self.collectionView registerClass:[SYAdvertisingCell class] forCellWithReuseIdentifier:identifierSYAdvertisingCell];
    //
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - 响应

- (void)reloadUIView
{
    // 重新刷新信息
    if (self.images && 0 < self.images.count)
    {
        [self.collectionView reloadData];
        
        // 设置滚动响应
        self.collectionView.scrollEnabled = (1 >= self.images.count ? NO : YES);
        
        // 改变图片视图
        [self.collectionView setContentOffset:CGPointMake(self.frame.size.width * self.pageIndex, 0.0) animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource

// 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 添加一个补充视图(页眉或页脚)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYAdvertisingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierSYAdvertisingCell forIndexPath:indexPath];
    if (SYImageBrowseContentFit == self.imageContentMode)
    {
        cell.imageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if (SYImageBrowseContentFill == self.imageContentMode)
    {
        cell.imageView.imageBrowseView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    id imageObject = self.images[indexPath.row];
    [cell.imageView.imageBrowseView setImage:imageObject defaultImage:self.defaultImage];
 
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

// 定义每个UICollectionView的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

// 最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// 最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// 设定页眉的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

// 设定页脚的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate

// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.imageScroll)
    {
        self.imageScroll(indexPath.row);
    }
}

// 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentOffset x = %@", @(scrollView.contentOffset.x));
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat widthPage = self.frame.size.width;
    CGFloat contentX = scrollView.contentOffset.x;
    NSInteger page = contentX / widthPage;
    if (self.imageScroll)
    {
        self.imageScroll(page);
    }
    
    NSLog(@"page %@", @(page));
}

#pragma mark - setter

- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    // 改变图片视图
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width * _pageIndex, 0.0) animated:YES];
}

@end

