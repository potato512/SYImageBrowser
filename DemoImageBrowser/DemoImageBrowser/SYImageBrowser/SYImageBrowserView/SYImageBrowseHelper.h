//
//  SYImageBrowseHelper.h
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/11/8.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYImageBrowseView.h"
#import "SYImageBrowseScrollView.h"

// 使用SDWebImage
#import "UIImageView+WebCache.h"

/// 图片类型（图片UIImage，图片名称NSString，图片地址http://...或https://....）
typedef NS_ENUM(NSInteger, ImageType)
{
    /// 图片类型 图片UIImage
    ImageTypeData = 1,
    
    /// 图片类型 图片名称NSString
    ImageTypeName = 2,
    
    /// 图片类型 图片地址http://...或https://....
    ImageTypeUrl = 3,
};

@interface SYImageBrowseHelper : NSObject

/// 获取图片类型
+ (ImageType)getImageType:(id)object;


/// 改变字体大小及字体颜色，区分字体的颜色还是字体背景色
+ (void)AttributedString:(NSMutableAttributedString *)attributedStr
                    text:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(BOOL)bgColor;

@end
