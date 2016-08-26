//
//  SYHelper.m
//  zhangshaoyu
//
//  Created by zhangshaoyu on 15/11/8.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "SYImageBrowseHelper.h"

@implementation SYImageBrowseHelper

/// 获取图片类型
+ (ImageType)getImageType:(id)object
{
    ImageType type = ImageTypeData;
    
    if ([object isKindOfClass:[NSString class]])
    {
        if ([object hasPrefix:@"http://"] || [object hasPrefix:@"https://"])
        {
            // 图片网络地址，即http://，或https://
            type = ImageTypeUrl;
        }
        else
        {
            // 图片名称，即NSString类型
            type = ImageTypeName;
        }
    }
    else if ([object isKindOfClass:[UIImage class]])
    {
        // 图片，即UIImage类型
        type = ImageTypeData;
    }
    
    return type;
}

/// 改变字体大小及字体颜色，区分字体的颜色还是字体背景色
+ (void)AttributedString:(NSMutableAttributedString *)attributedStr
                    text:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(BOOL)bgColor
{
    if ((!attributedStr || 0 == attributedStr.length) || (!text || 0 == text.length) || !font || !color)
    {
        return;
    }
    
    // 字体设置范围
    NSRange range = [attributedStr.string rangeOfString:text];
    
    // 字体大小
    [attributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:range];
    
    // 字体颜色
    [attributedStr addAttribute:(bgColor ? NSBackgroundColorAttributeName : NSForegroundColorAttributeName)
                          value:color
                          range:range];
}

@end
