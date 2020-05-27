//
//  Globle.h
//  TutorABC
//
//  Created by Slark on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#ifndef Globle_h
#define Globle_h
/*frame*/
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define RR(x,y,k,g) CGRectMake(x, y, k, g)
#define BorderMargin 15  //边距
#define GetRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height //获取导航栏+状态栏的高度
#define BottomSafeAreaHeight (([[UIApplication sharedApplication] statusBarFrame].size.height==44 ? 83 : 49) - 49)//底部的安全距离，全面屏手机为34pt，非全面屏手机为0pt
/*颜色*/
#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define TextGrayColor [UIColor colorWithHex:@"#8A94A6"] //灰色文字颜色
#define TextLightGrayColor [UIColor colorWithHex:@"#B5BBC6"] //浅灰色文字颜色
#define PreLoadVIewColor [UIColor colorWithHex:@"#F1F2F4"] //预加载控件浅灰色文字颜色
#define TextColor    [UIColor colorWithHex:@"#0A1F44"]      //文字颜色
/*字体大小*/
#define MiniFont [UIFont systemFontOfSize:12]
#define SmallFont [UIFont systemFontOfSize:14]
#define NormalFont [UIFont systemFontOfSize:18]
#define BigFont [UIFont systemFontOfSize:20]
#define BigerFont [UIFont systemFontOfSize:22]

#import "BoldLabel.h"//自定义的默认字体加粗标签
#import "MJExtension.h"
#import "SDWebImage.h"
#import "ITGUserProtocol.h" //获取用户信息
#import "TAAILearnViewModel.h"
#import "SensorsAnalyticsSDK.h"
#import "UIImage+EXtension.h"
/*服务器地址*/
#define PostUrl @"http://221.226.9.92:8293/aicourse/api/"
/*h5地址*/
#define HTMLUrl @"http://221.226.9.92:8295/report/html/learnReport.html"
/*Token*/
#define tempToken @"b845088dd33c4be3bfe4a9016247b2e2o91v34Fk85889027244"
#define UserId   @"123412"
#define ClientId @"1"

#define EventNamePrefix @"tutorabc"

/*服务器地址*/
//测试环境
#define PostUrl @"http://221.226.9.92:8293/aicourse/api/"
//测试环境
//#define PostUrl @"http://221.226.9.92:8294/aicourse/api/"
//#define PostUrl @"http://172.20.10.3:8082/aicourse/api/"
/*头文件*/
#import "UIView+Layer.h"
#import "UIView+Frame.h"
#import "NSString+Helper.h"
#import "BaseTableViewCell.h"
#import "BaseViewController.h"
#import "ZR_Request.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "ITGUserProtocol.h"
#endif /* Globle_h */
