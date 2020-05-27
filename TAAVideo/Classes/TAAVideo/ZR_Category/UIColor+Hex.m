//
//  UIColor+Hex.h
//
//  Created by 葛优 on 2020/3/13.
//  Copyright © 2020年 rangguangyu. All rights reserved.
//
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)UIColorFromHex:(NSUInteger)rgb alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0
                           green:((float)((rgb & 0xFF00) >> 8))/255.0
                            blue:((float)(rgb & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)UIColorFromHex:(NSUInteger)rgb{
    return [UIColor UIColorFromHex:rgb alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHex:(NSString *)color{
    return [self colorWithHexString:color alpha:1.0f];
}

+ (NSString *)HexFromUIColor:(UIColor *)color{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    
    
    
    return [NSString stringWithFormat:@"#%X%X%X",(int)((CGColorGetComponents(color.CGColor))[0] *255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

/*
 字符串的16进制转换成字符串
 **/
+ (UIColor *)UIColorFormHexString:(NSString *)hexString{
    // 将字符串所表示的16进制转换为数字
    return [self UIColorFromHex:[self hexStringChangeToInteger:hexString]];
}


+ (NSUInteger)hexStringChangeToInteger:(NSString *)hexString{
    NSString *changeHexString = hexString;
    if ([hexString rangeOfString:@"#"].location != NSNotFound) {
        
        changeHexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        
    }
    unsigned long color = strtoul([changeHexString UTF8String], 0, 16);
    NSUInteger integer = (NSUInteger)color;
    return integer;
}

+ (NSString *)getRColorFromHex:(NSString *)hexString{
    NSUInteger rgb = [self hexStringChangeToInteger:hexString];
    return [NSString stringWithFormat:@"%f", ((float)((rgb & 0xFF0000) >> 16))];
}

/*
 获取16进制中的G色
 **/
+ (NSString *)getGColorFromHex:(NSString *)hexString{
    NSUInteger rgb = [self hexStringChangeToInteger:hexString];
    return [NSString stringWithFormat:@"%f",((float)((rgb & 0xFF00) >> 8))];
}

/*
 获取16进制中的B色
 **/
+ (NSString *)getBColorFromHex:(NSString *)hexString{
    NSUInteger rgb = [self hexStringChangeToInteger:hexString];
    return [NSString stringWithFormat:@"%f", ((float)(rgb & 0xFF))];
}
@end
