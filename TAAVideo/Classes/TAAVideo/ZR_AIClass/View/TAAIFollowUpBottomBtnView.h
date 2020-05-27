//
//  TAAIFollowUpBottomBtnView.h
//  TutorABC
//
//  Created by Slark on 2020/5/6.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAAIPartModel.h"
@protocol TAAIFollowUpBottomBtnViewDelegate <NSObject>

- (void)followUpBottomBtnViewDidClickRecordBtn;
- (void)followUpBottomBtnViewDidClickReLearnBtn;
- (void)followUpBottomBtnViewDidClickLearnAgainBtn;
- (void)followUpBottomBtnViewDidClickContinueBtn;
- (void)followUpBottomBtnViewDidClickCancelBtn;
- (void)followUpBottomBtnViewDidChangeBtns:(NSString *)score allMessage:(NSDictionary *)messageDic;
- (void)followReadGood;
- (void)followReadBad;
@end

typedef NS_ENUM(NSUInteger,FollowReadState){
    FollowReadStateCommon = 0,
    FollowReadStateGood,
    FollowReadStateDefault,
};

@interface TAAIFollowUpBottomBtnView : UIView

@property (nonatomic,assign)FollowReadState readState;
@property (nonatomic, weak) id<TAAIFollowUpBottomBtnViewDelegate> delegate;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, strong) TAAIPartModel *partModel;
@property (nonatomic, strong) NSTimer *bottomTimer;
@property (nonatomic, strong) NSString *contentText;//跟读文本
- (void)creatChEngine;//创建驰声引擎

@end


