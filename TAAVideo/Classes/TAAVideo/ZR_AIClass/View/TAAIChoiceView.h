//
//  TAAIChoiceView.h
//  DevelopmentFramework
//
//  Created by Slark on 2020/5/11.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAAIChoiceView.h"
@protocol TAAIChoiceViewDelegate <NSObject>

- (void)selectedViewWithTag:(NSString*)tag WithChoiceView:(id)choiceView;

@end

typedef NS_ENUM(NSUInteger,TAAIChoiceState){
    TAAIChoiceStateSelected = 0,//单选样式
    TAAIChoiceStateUnSelected = 1,//未选样式,超时未选择也为该样式
    TAAIChoiceStateSelectedRight = 2,//选择正确
    TAAIChoiceStateSelectedFalse = 3,//选择错误
};

@interface TAAIChoiceView : UIView

@property (nonatomic, assign) TAAIChoiceState choiceState;
@property (nonatomic, weak) id<TAAIChoiceViewDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)titleString AndSelectedTag:(NSString*)stringTag;

@end


