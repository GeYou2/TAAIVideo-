//
//  UIView+Layer.m
//  CCFounctionKit
//
//  Created by Slark on 17/2/6.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

/**
 *边角颜色的set get
 */
- (void)setLayerBorderColor:(UIColor *)layerBorderColor{
    self.layer.borderColor = layerBorderColor.CGColor;
    [self _config];
}

- (UIColor*)layerBorderColor{
    return [UIColor colorWithCGColor:self.layer
            .borderColor];
}

/**
 *圆角的set get
 */
-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius{
    self.layer.cornerRadius = layerCornerRadius;
    [self _config];
}

-(CGFloat)layerCornerRadius{
    return self.layer.cornerRadius;
}

/**
 *边框宽的set get
 */
- (void)setLayerBorderWidth:(CGFloat)layerBorderWidth{
    self.layer.borderWidth = layerBorderWidth;
}

- (CGFloat)layerBorderWidth{
    return self.layer.borderWidth;
}

/**
 *同事需要设置时 直接调用
 */
- (void)setLayerCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
}

- (void)_config {
    self.layer.masksToBounds = YES;
//    // 栅格化 - 提高性能
//    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //self.layer.shouldRasterize = YES;
}

@end
