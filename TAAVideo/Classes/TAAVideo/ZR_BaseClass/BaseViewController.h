//
//  BaseViewController.h
//  ios-2Block
//
//  Created by Slark on 17/1/12.
//  Copyright © 2017年 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoldLabel.h"
#import "TAAINoDataView.h"
@interface BaseViewController : UIViewController<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray* dataArray;//数据源
@property (nonatomic, assign) BOOL Hidden_BackTile;
@property (nonatomic, copy) NSString* rightItemTitle;//item文字标题
@property (nonatomic, copy) NSString* rightItemImageName;//右边item图片名称
@property (nonatomic, copy) void (^rightItemHandle)(void);//点击item回调
@property (nonatomic, strong) UIColor* arrowColor;//返回箭头颜色
@property (nonatomic, strong) UIColor* titleColor;//title颜色
@property (nonatomic, strong) UIColor* barColor;//bar背景色
@property (nonatomic, copy) NSString* leftItemImageName;
@property (nonatomic, copy) void (^leftItemHandle)(void);//点击item回调
@property (nonatomic, assign) BOOL isNetworrReachable;/** 判断是否有网络*/
@property (nonatomic, strong) UIView *navView;//自定义导航栏
@property (nonatomic, strong) UIButton *backBtn;//返回按钮
@property (nonatomic, strong) BoldLabel *navTitleLable;//页面标题
- (void)presentToVC:(UIViewController *)vc;
- (void)dismiss;
- (void)pushVC:(UIViewController *)vc;
- (void)pop;
- (void)popToRootVc;
- (void)popToVc:(UIViewController *)vc;
- (void)addchildVc:(UIViewController *)childVc;
- (void)removeChildVc:(UIViewController *)childVc;

/** 加载数据交给子类实现*/
- (void)loadData;
- (BOOL)isIPhoneX;
@end
