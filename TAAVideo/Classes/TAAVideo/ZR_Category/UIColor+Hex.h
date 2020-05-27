//
//  UIColor+Hex.h
//
//  Created by 葛优 on 2020/3/13.
//  Copyright © 2020年 rangguangyu. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
根据16进制生成颜色（透明度为1）
*/
+ (UIColor *)colorWithHex:(NSString *)color;

//根据16进制生成颜色，可指定透明度
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 根据16进制生成颜色
 直接传16进制数字
 */
+ (UIColor *)UIColorFromHex:(NSUInteger)rgb alpha:(CGFloat)alpha;

/**
 根据16进制生成颜色（透明度为1）
  直接传16进制数字
 */
+ (UIColor *)UIColorFromHex:(NSUInteger)rgb;
/**
 根据颜色生成16进制
 返回值： #FFFFFF
 */
+ (NSString *)HexFromUIColor:(UIColor *)color;


/*
 字符串的16进制转换成字符串
 如：0x125678
 **/
+ (UIColor *)UIColorFormHexString:(NSString *)hexString;

/*
 获取16进制中的R颜色
 **/
+ (NSString *)getRColorFromHex:(NSString *)hexString;


/*
 获取16进制中的G色
 **/
+ (NSString *)getGColorFromHex:(NSString *)hexString;


/*
 获取16进制中的B色
 **/
+ (NSString *)getBColorFromHex:(NSString *)hexString;
@end
