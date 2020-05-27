//
//  TAAIAlertView.h
//  TutorABC
//
//  Created by Slark on 2020/5/8.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TAAIAlertViewType) {
    TAAIAlertViewTypeNormal,         //普通alert
    TAAIAlertViewTypeActionSheet,    //普通actionSheet
    TAAIAlertViewTypeCustom,         //自定义
};

@interface TAAIAlertView : UIView

@property (nonatomic, assign) TAAIAlertViewType  type;
//contentView为自定义弹窗的容器，请优先指定contentView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CAAnimation *showAnimation;
@property (nonatomic, strong) CAAnimation *dismissAnimation;
@property (nonatomic, assign) BOOL clickBgHidden;//点击背景是否自动隐藏，默认为YES
//默认show在keywindow中
- (void)show;
//在指定的view上显示
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end


