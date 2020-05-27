//
//  TAAIScoreImageView.h
//  TutorABC
//
//  Created by Slark on 2020/5/23.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,TAAIScoreState){
    TAAIScoreStateGreat = 0,
    TAAIScoreStateOops, //基本图层
    TAAIScoreStateReadGood,//分支图层
    TAAIScoreStateReadCommon,//跟读
};


@interface TAAIScoreImageView : UIView

@property (nonatomic, copy) NSString *scoreString;
@property (nonatomic, copy) NSString *stateImageString;
@property (nonatomic, assign) TAAIScoreState scoreState;

@end

NS_ASSUME_NONNULL_END
