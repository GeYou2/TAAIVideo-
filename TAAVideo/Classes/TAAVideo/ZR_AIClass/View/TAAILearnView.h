//
//  BaseLearnView.h
//  TutorABC
//
//  Created by Slark on 2020/5/8.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAAISectionModel.h"
#import "TAAIClassSectionModel.h"
#import "TAAIPartModel.h"
#import "TAAIProgressView.h"
@protocol TAAIMenudelegate <NSObject>

- (void)gobackClick;
- (void)hiddenSubtitle:(UIButton *)btn;
- (void)selectMenuItemAtIndex:(NSInteger)index;
- (void)retryClick;
- (void)nextClick;
- (void)startClass;
- (void)followUpViewBottomBtnViewDidClickCancelBtn;

@end

typedef NS_ENUM(NSUInteger,TAAIClassState){
    TAAIClassStateCoreVocabulary = 0,//核心词汇
    TAAIClaasStateSingleView, //基本图层
    TAAIClaasStateBranchView,//分支图层
    TAAIClassStateFollowRead,//跟读
    TAAIClassStateAnswerQuestion,//选择题
    TAAIClassStateEndQuestion,//选择结束
    TAAIClassStateEndFollowRead,
    TAAIClassStatefFeedBack,//
    TAAIClassStateFollowReadFeedBack,
    TAAIClassStateUnChoice,//未选
    TAAIClassStateNextStepState
};


@interface TAAILearnView : UIView

@property (nonatomic, assign) TAAIClassState classState;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *allSecionsArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allParts;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, weak) id<TAAIMenudelegate> delegate;

@property (nonatomic, strong) TAAIProgressView *topProgressView;

- (void)showAlert;
- (void)hiddenAlert;
- (void)showAlerViewWithSectionModel:(TAAIClassSectionModel*)sectionModel withPartModel:(TAAIPartModel*)partModel;
- (void)removeUselessSubViews;
- (void)goback;

@end


