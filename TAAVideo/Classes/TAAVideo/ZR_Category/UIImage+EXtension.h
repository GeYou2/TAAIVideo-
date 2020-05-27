//
//  UIImage+EXtension.h
//  TutorABC
//
//  Created by 葛优 on 2020/5/26.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (EXtension)

+ (UIImage *)imageWithColor:(UIColor *)color;
/** 设置图片的渐变色(颜色->图片)
 
 @param colors 渐变颜色数组 @param gradientType 渐变样式 @param imgSize 图片大小 @return 颜色->图片
 */

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
@end

NS_ASSUME_NONNULL_END
