//
//  TAAIQuestionModel.h
//  TutorABC
//
//  Created by Slark on 2020/5/19.
//  Copyright © 2020 Slark. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAIQuestionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *questionName;
@property (nonatomic, copy) NSString *correctAnswer;
@property (nonatomic, strong) NSArray *questionExtOptionList;
@property (nonatomic, copy) NSString *bgUrl;
@property (nonatomic, copy) NSString *answerAnalysis;
@property (nonatomic, strong) NSDictionary *feedBackDic;
@property (nonatomic, copy) NSString *questionType;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, strong) NSArray *questionExtFeedbackList;//第一个是正确 第二个是错误
@property (nonatomic, strong) NSArray *followList;

@end

NS_ASSUME_NONNULL_END
